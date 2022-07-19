Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B1E579BD3
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbiGSMc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237781AbiGSMbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11AB16F7D1;
        Tue, 19 Jul 2022 05:12:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75C51617B2;
        Tue, 19 Jul 2022 12:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43002C341C6;
        Tue, 19 Jul 2022 12:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232716;
        bh=X9WuZHRBiz2nho8DCaOdG+r9o02kpV/Q6WT/c4yRdgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rk0LEn6v7VqF29OqxobqvwnmDupfO3tR8xG5tTbeQwms1j7rj4sKhE9lwzmG2D2Xt
         +5F0jMuTolx1gNosA/SSgSR13dOrR45H7uZMrG5kgbBdiKpC3mQxKV2kAXiPKURS77
         ncl7yRXIeK9DsB8sImWAU5RoJSn3EsrlBq2LFICI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/167] drm/i915: fix a possible refcount leak in intel_dp_add_mst_connector()
Date:   Tue, 19 Jul 2022 13:52:52 +0200
Message-Id: <20220719114700.557060581@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 85144df9ff4652816448369de76897c57cbb1b93 ]

If drm_connector_init fails, intel_connector_free will be called to take
care of proper free. So it is necessary to drop the refcount of port
before intel_connector_free.

Fixes: 091a4f91942a ("drm/i915: Handle drm-layer errors in intel_dp_add_mst_connector")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220624130406.17996-1-jose.souza@intel.com
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit cea9ed611e85d36a05db52b6457bf584b7d969e2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 8d13d7b26a25..2a20487effcc 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -817,6 +817,7 @@ static struct drm_connector *intel_dp_add_mst_connector(struct drm_dp_mst_topolo
 	ret = drm_connector_init(dev, connector, &intel_dp_mst_connector_funcs,
 				 DRM_MODE_CONNECTOR_DisplayPort);
 	if (ret) {
+		drm_dp_mst_put_port_malloc(port);
 		intel_connector_free(intel_connector);
 		return NULL;
 	}
-- 
2.35.1



