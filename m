Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6966F579C37
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbiGSMhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240674AbiGSMgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:36:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430AE7B349;
        Tue, 19 Jul 2022 05:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58C0FB81B08;
        Tue, 19 Jul 2022 12:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FDEC341C6;
        Tue, 19 Jul 2022 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232854;
        bh=4e+egwhf3Xe6mjeGGX+i1VOLzgqkAJAcedV9UkP5Svs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3c4hjgcZezgZklTnkPWmfTiahkfz6Cnd7+gIaCkiHWLArw44TrfcAkRHqzVwrbdX
         1plAwPfOjXgagJdJPOQa06J7n/bfVY5bZZk7ewiir+ygUDiiiz8tKSIMDW3hAKjDW0
         23cMRE60x7McYNUy8kpF6CYSGUu6adCIdgvPrzrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <andrzej.hajda@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/167] drm/i915/gvt: IS_ERR() vs NULL bug in intel_gvt_update_reg_whitelist()
Date:   Tue, 19 Jul 2022 13:53:21 +0200
Message-Id: <20220719114703.173075778@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e87197fbd137c888fd6c871c72fe7e89445dd015 ]

The shmem_pin_map() function returns NULL, it doesn't return error
pointers.

Fixes: 97ea656521c8 ("drm/i915/gvt: Parse default state to update reg whitelist")
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/Ysftoia2BPUyqVcD@kili
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/cmd_parser.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/cmd_parser.c b/drivers/gpu/drm/i915/gvt/cmd_parser.c
index c4118b808268..11971ee929f8 100644
--- a/drivers/gpu/drm/i915/gvt/cmd_parser.c
+++ b/drivers/gpu/drm/i915/gvt/cmd_parser.c
@@ -3115,9 +3115,9 @@ void intel_gvt_update_reg_whitelist(struct intel_vgpu *vgpu)
 			continue;
 
 		vaddr = shmem_pin_map(engine->default_state);
-		if (IS_ERR(vaddr)) {
-			gvt_err("failed to map %s->default state, err:%zd\n",
-				engine->name, PTR_ERR(vaddr));
+		if (!vaddr) {
+			gvt_err("failed to map %s->default state\n",
+				engine->name);
 			return;
 		}
 
-- 
2.35.1



