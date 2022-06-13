Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A4A5492AF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380386AbiFMN6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381158AbiFMN4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:56:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218C5880C9;
        Mon, 13 Jun 2022 04:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CE5DDCE1179;
        Mon, 13 Jun 2022 11:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6010C34114;
        Mon, 13 Jun 2022 11:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120199;
        bh=CFfPA94IscgZauYe5PcDNGb7kJxSY6aENgveDQCHbKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aq3BfLv+qIPNepMp4tvItdI3q6exlkQLvefO96/fHyAnCxZek4j+C6CrxYFsB6hNS
         z3gj405fAFF5bRsAPu3m7QbKf+z+RoM/p8oqFBHlLWHxy4dC7m5nh3FDZc6bgeXHLH
         UfoCe4r5fZmMrQDdg7Lrb6aek55YIAC6l1EUKjfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gong Yuanjun <ruc_gongyuanjun@163.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 266/339] drm/radeon: fix a possible null pointer dereference
Date:   Mon, 13 Jun 2022 12:11:31 +0200
Message-Id: <20220613094934.716171685@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gong Yuanjun <ruc_gongyuanjun@163.com>

[ Upstream commit a2b28708b645c5632dc93669ab06e97874c8244f ]

In radeon_fp_native_mode(), the return value of drm_mode_duplicate()
is assigned to mode, which will lead to a NULL pointer dereference
on failure of drm_mode_duplicate(). Add a check to avoid npd.

The failure status of drm_cvt_mode() on the other path is checked too.

Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_connectors.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 0cb1345c6ba4..fabe4f4ca124 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -473,6 +473,8 @@ static struct drm_display_mode *radeon_fp_native_mode(struct drm_encoder *encode
 	    native_mode->vdisplay != 0 &&
 	    native_mode->clock != 0) {
 		mode = drm_mode_duplicate(dev, native_mode);
+		if (!mode)
+			return NULL;
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		drm_mode_set_name(mode);
 
@@ -487,6 +489,8 @@ static struct drm_display_mode *radeon_fp_native_mode(struct drm_encoder *encode
 		 * simpler.
 		 */
 		mode = drm_cvt_mode(dev, native_mode->hdisplay, native_mode->vdisplay, 60, true, false, false);
+		if (!mode)
+			return NULL;
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		DRM_DEBUG_KMS("Adding cvt approximation of native panel mode %s\n", mode->name);
 	}
-- 
2.35.1



