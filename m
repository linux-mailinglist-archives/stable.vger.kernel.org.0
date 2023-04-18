Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BEA6E64C1
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjDRMwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjDRMv7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:51:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0D716DFD
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 234F86341D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3588EC4339C;
        Tue, 18 Apr 2023 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822296;
        bh=RvE78KytFAoRhZX6ykIgr1P/kHs/4e9J1365WZ43r7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RpEPh0g0pOFzAtj2He221/KychIDgDiA4SZDVkViHJ+9Ysw2hxykTh/N0PyPpDhJR
         Wt5uMuR40v2ipymkuzsKEtQjVH0bfDRcX2V/saAMlGNi9qwG/IyCnmp0kAoeHG+ATp
         QtpJKbKQfIEwSnAEkpWw9cOvmRPhZC0q+68yb/Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tong Liu01 <Tong.Liu01@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 096/139] drm/amdgpu: add mes resume when do gfx post soft reset
Date:   Tue, 18 Apr 2023 14:22:41 +0200
Message-Id: <20230418120317.392255519@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Liu01 <Tong.Liu01@amd.com>

[ Upstream commit 4eb0b49a0ad3e004a6a65b84efe37bc7e66d560f ]

[why]
when gfx do soft reset, mes will also do reset, if mes is not
resumed when do recover from soft reset, mes is unable to respond
in later sequence

[how]
resume mes when do gfx post soft reset

Signed-off-by: Tong Liu01 <Tong.Liu01@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 66eb102cd88fb..c748d92cec8e7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -4625,6 +4625,14 @@ static bool gfx_v11_0_check_soft_reset(void *handle)
 	return false;
 }
 
+static int gfx_v11_0_post_soft_reset(void *handle)
+{
+	/**
+	 * GFX soft reset will impact MES, need resume MES when do GFX soft reset
+	 */
+	return amdgpu_mes_resume((struct amdgpu_device *)handle);
+}
+
 static uint64_t gfx_v11_0_get_gpu_clock_counter(struct amdgpu_device *adev)
 {
 	uint64_t clock;
@@ -6096,6 +6104,7 @@ static const struct amd_ip_funcs gfx_v11_0_ip_funcs = {
 	.wait_for_idle = gfx_v11_0_wait_for_idle,
 	.soft_reset = gfx_v11_0_soft_reset,
 	.check_soft_reset = gfx_v11_0_check_soft_reset,
+	.post_soft_reset = gfx_v11_0_post_soft_reset,
 	.set_clockgating_state = gfx_v11_0_set_clockgating_state,
 	.set_powergating_state = gfx_v11_0_set_powergating_state,
 	.get_clockgating_state = gfx_v11_0_get_clockgating_state,
-- 
2.39.2



