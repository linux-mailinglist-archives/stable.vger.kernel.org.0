Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFE96A3675
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjB0CCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjB0CBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:01:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A913D12F17;
        Sun, 26 Feb 2023 18:01:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC37B60C47;
        Mon, 27 Feb 2023 02:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4010C433EF;
        Mon, 27 Feb 2023 02:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463298;
        bh=cxKiHHz+PL9jilHqQUdXCDX19Vv6GDNjP8Lw7k0QEBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S16LLh1oqHU+7UrPxAkcI2LPkdzVki4fmGgP2X1dbjbWxdzfvuD3QrpR2h8BVomdR
         bmtj7ZtP+I2azueRgnNF1oWL0cFsuAtddNPFZt2yKeWdQQDbdUiTqiI5Tc6kvc8k43
         omgXiDXx5e0KGyEfDXBhSng1AuNh+rtkGCqL3ATNEcQe8Dm33EmKjVgPG9iFp7zWPS
         Nqa6pfIkKUVEsYbV+atVAF4ro2UKB05YOt6Kl/oaolgm7E5Mlz27EXzI4hLOaenxD/
         1yPf//lYUeSyaTUFlttFAN8JsDK9OfNYvrPVKycATVjbxwvwWwVZLlBif5V/kCTJWO
         1vPuRz7bIxCrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, Likun.Gao@amd.com, guchun.chen@amd.com,
        candice.li@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 11/60] drm/amd: Avoid BUG() for case of SRIOV missing IP version
Date:   Sun, 26 Feb 2023 20:59:56 -0500
Message-Id: <20230227020045.1045105-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 93fec4f8c158584065134b4d45e875499bf517c8 ]

No need to crash the kernel.  AMDGPU will now fail to probe.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 7a2fc920739bb..ba092072308fa 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -380,7 +380,7 @@ static int psp_init_sriov_microcode(struct psp_context *psp)
 		adev->virt.autoload_ucode_id = AMDGPU_UCODE_ID_CP_MES1_DATA;
 		break;
 	default:
-		BUG();
+		ret = -EINVAL;
 		break;
 	}
 	return ret;
-- 
2.39.0

