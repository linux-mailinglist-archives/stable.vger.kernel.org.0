Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4EA5A062C
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiHYBjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbiHYBij (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:38:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6049A98C;
        Wed, 24 Aug 2022 18:37:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB5261AED;
        Thu, 25 Aug 2022 01:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6048FC433C1;
        Thu, 25 Aug 2022 01:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391407;
        bh=6y2CEd1u9Su1zaXFQgHgKgA4r6KSVGRWB5cN6xNdCrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgL+3avRMD+252eyhwzvEfcT1/J0wKtHdX4NVVumSyZXzgRVTfpIpUsm2MI4z2OvV
         p9NzNyhWA/PZdNULNf04pv8F+5Pn6M/bLZ6d2SjnVWmc2Z2io78sftmtLORWFTVrlJ
         0rrkklS9kmTO0zKe2U3lXHEwA5ojrHzrr0daUYQE2aVlHJYTDTPe4h7ImHlrrR9GoA
         FAKHmoJnYF0Wds0xBeMcS6T/HbXc+eC33JhqVrCab6ZoMvPSrG8nWK7gyly7doiqa4
         I63HYfGrUdqnm/fWFXMUfUx2davw82ysd+oeIxRsUhFl8S1RDWW1q1LEPOIR+CwuqA
         tHxcMQe0JtF7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shane Xiao <shane.xiao@amd.com>, Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        candice.li@amd.com, john.clements@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 29/38] drm/amdgpu: Add secure display TA load for Renoir
Date:   Wed, 24 Aug 2022 21:33:52 -0400
Message-Id: <20220825013401.22096-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Shane Xiao <shane.xiao@amd.com>

[ Upstream commit e42dfa66d59240afbdd8d4b47b87486db39504aa ]

Add secure display TA load for Renoir

Signed-off-by: Shane Xiao <shane.xiao@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/psp_v12_0.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
index a2588200ea58..0b2ac418e4ac 100644
--- a/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/psp_v12_0.c
@@ -101,6 +101,16 @@ static int psp_v12_0_init_microcode(struct psp_context *psp)
 		adev->psp.dtm_context.context.bin_desc.start_addr =
 			(uint8_t *)adev->psp.hdcp_context.context.bin_desc.start_addr +
 			le32_to_cpu(ta_hdr->dtm.offset_bytes);
+
+		if (adev->apu_flags & AMD_APU_IS_RENOIR) {
+			adev->psp.securedisplay_context.context.bin_desc.fw_version =
+				le32_to_cpu(ta_hdr->securedisplay.fw_version);
+			adev->psp.securedisplay_context.context.bin_desc.size_bytes =
+				le32_to_cpu(ta_hdr->securedisplay.size_bytes);
+			adev->psp.securedisplay_context.context.bin_desc.start_addr =
+				(uint8_t *)adev->psp.hdcp_context.context.bin_desc.start_addr +
+				le32_to_cpu(ta_hdr->securedisplay.offset_bytes);
+		}
 	}
 
 	return 0;
-- 
2.35.1

