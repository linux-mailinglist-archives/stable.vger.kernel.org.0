Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0CE39615B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhEaOkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233060AbhEaOhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:37:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F12D616E8;
        Mon, 31 May 2021 13:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469086;
        bh=HEc68bgK13no4zXPtk4WED1UrAbOth3Jpk/lUOjy+XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0lTAwesIjQqpl84vrCx7xymqO/ogyNMJEHEeGATLOq8TjrN6Ody5BWNPVZ2ie1WH
         4zzidySYGADWLH3Aj79km4UGrb10t//yZqWd75mFFT3BHbrBZ43bs5Nc2pG1CseU0g
         X7QTH5+CyGWV5LbNpMJAtKg0kIwJrVokgW2K/5Ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 057/296] drm/amdkfd: correct sienna_cichlid SDMA RLC register offset error
Date:   Mon, 31 May 2021 15:11:52 +0200
Message-Id: <20210531130705.746967937@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Wang <kevin1.wang@amd.com>

commit ba515a5821dc0d101ded0379b14b1d1471ebfaba upstream.

1.correct KFD SDMA RLC queue register offset error.
(all sdma rlc register offset is base on SDMA0.RLC0_RLC0_RB_CNTL)
2.HQD_N_REGS (19+6+7+12)
  12: the 2 more resgisters than navi1x (SDMAx_RLCy_MIDCMD_DATA{9,10})

the patch also can be fixed NULL pointer issue when read
/sys/kernel/debug/kfd/hqds on sienna_cichlid chip.

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10_3.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10_3.c
@@ -156,16 +156,16 @@ static uint32_t get_sdma_rlc_reg_offset(
 				mmSDMA0_RLC0_RB_CNTL) - mmSDMA0_RLC0_RB_CNTL;
 		break;
 	case 1:
-		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA1, 0,
+		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA0, 0,
 				mmSDMA1_RLC0_RB_CNTL) - mmSDMA0_RLC0_RB_CNTL;
 		break;
 	case 2:
-		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA2, 0,
-				mmSDMA2_RLC0_RB_CNTL) - mmSDMA2_RLC0_RB_CNTL;
+		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA0, 0,
+				mmSDMA2_RLC0_RB_CNTL) - mmSDMA0_RLC0_RB_CNTL;
 		break;
 	case 3:
-		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA3, 0,
-				mmSDMA3_RLC0_RB_CNTL) - mmSDMA2_RLC0_RB_CNTL;
+		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA0, 0,
+				mmSDMA3_RLC0_RB_CNTL) - mmSDMA0_RLC0_RB_CNTL;
 		break;
 	}
 
@@ -450,7 +450,7 @@ static int hqd_sdma_dump_v10_3(struct kg
 			engine_id, queue_id);
 	uint32_t i = 0, reg;
 #undef HQD_N_REGS
-#define HQD_N_REGS (19+6+7+10)
+#define HQD_N_REGS (19+6+7+12)
 
 	*dump = kmalloc(HQD_N_REGS*2*sizeof(uint32_t), GFP_KERNEL);
 	if (*dump == NULL)


