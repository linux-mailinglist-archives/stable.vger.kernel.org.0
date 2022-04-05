Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710DC4F3BD4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353448AbiDEMCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358034AbiDEK14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C0D6949F;
        Tue,  5 Apr 2022 03:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4373461562;
        Tue,  5 Apr 2022 10:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5713FC385A1;
        Tue,  5 Apr 2022 10:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153592;
        bh=B8v8pNfUZ+uRQm2T0PwBEj/KLWQ6Ebx8iIUP4hU0hd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsVN7j8VRsyw5oAjX0zr2oKXUyo0FZq3c+Yrfcgd5NpMfbP3befwrA1yXpRdKu5fA
         gLa6/xL3gxNGyFVDrI3YfWVi09ox0twth8Ueb501url/0DmGhCg1PP5ZBz0+iG7I7M
         4iwip9Bkx78lrL9QrG5skho4hr/05kvH0N7u9gug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/599] drm/amd/pm: return -ENOTSUPP if there is no get_dpm_ultimate_freq function
Date:   Tue,  5 Apr 2022 09:29:30 +0200
Message-Id: <20220405070307.050919719@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 430e6a0212b2a0eb1de5e9d47a016fa79edf3978 ]

clang static analysis reports this represenative problem
amdgpu_smu.c:144:18: warning: The left operand of '*' is a garbage value
        return clk_freq * 100;
               ~~~~~~~~ ^

If there is no get_dpm_ultimate_freq function,
smu_get_dpm_freq_range returns success without setting the
output min,max parameters.  So return an -ENOTSUPP error.

Fixes: e5ef784b1e17 ("drm/amd/powerplay: revise calling chain on retrieving frequency range")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index e5893218fa4b..ee27970cfff9 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -115,7 +115,7 @@ int smu_get_dpm_freq_range(struct smu_context *smu,
 			   uint32_t *min,
 			   uint32_t *max)
 {
-	int ret = 0;
+	int ret = -ENOTSUPP;
 
 	if (!min && !max)
 		return -EINVAL;
-- 
2.34.1



