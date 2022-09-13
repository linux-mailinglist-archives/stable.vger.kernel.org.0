Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5094F5B7373
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbiIMPJa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiIMPIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:08:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F01E760C1;
        Tue, 13 Sep 2022 07:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F398B80FAC;
        Tue, 13 Sep 2022 14:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1ACC433D7;
        Tue, 13 Sep 2022 14:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079290;
        bh=LhMRPfK7UasEqG4OE4oQclpIUn/hzO8YS1HbMLVxpfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkHnJAQz2gzCPN1iW/UD60hkb1f9ajajnyXXRg2YrhAr+fERu/fPvlGC0HVUywA9J
         kSZCeVlHPzrBCX5Z2Xtl4TgOdus8BVNZRJotAIpziqur1BRBfoeOgPvb3d+TARr/1f
         Iq5ZFIRNXicViMjoHStnWswMehFJeEo70zUEX62k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Huang <jinsdb@126.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/108] drm/amdgpu: mmVM_L2_CNTL3 register not initialized correctly
Date:   Tue, 13 Sep 2022 16:06:47 +0200
Message-Id: <20220913140356.900746983@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qu Huang <jinsdb@126.com>

[ Upstream commit b8983d42524f10ac6bf35bbce6a7cc8e45f61e04 ]

The mmVM_L2_CNTL3 register is not assigned an initial value

Signed-off-by: Qu Huang <jinsdb@126.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
index 641f1258f08dc..e60157fe7a7bf 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
@@ -182,6 +182,7 @@ static void mmhub_v1_0_init_cache_regs(struct amdgpu_device *adev)
 	tmp = REG_SET_FIELD(tmp, VM_L2_CNTL2, INVALIDATE_L2_CACHE, 1);
 	WREG32_SOC15(MMHUB, 0, mmVM_L2_CNTL2, tmp);
 
+	tmp = mmVM_L2_CNTL3_DEFAULT;
 	if (adev->gmc.translate_further) {
 		tmp = REG_SET_FIELD(tmp, VM_L2_CNTL3, BANK_SELECT, 12);
 		tmp = REG_SET_FIELD(tmp, VM_L2_CNTL3,
-- 
2.35.1



