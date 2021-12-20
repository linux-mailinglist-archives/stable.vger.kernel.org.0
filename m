Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4604647AE62
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbhLTPBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239286AbhLTO6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580D0C06139B;
        Mon, 20 Dec 2021 06:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7DA061185;
        Mon, 20 Dec 2021 14:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F19C36AE8;
        Mon, 20 Dec 2021 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011814;
        bh=T0TxMKwaoVrOXXrVUWlYzijRlYnxq206fcvX1INbAco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQAiQCkoOlZBDDKuOuelAvV0x95FEfAYzu+3E2JCRiGS+lgVl2q4pobMQkmD1/F+s
         j3fXZp2zhynoIbr5uy6kLHr6NU6053Vvuggr89d2+vK/saTcidZeu1FfM5+YCA2RNn
         sB34gW5Z2ZQzKJD/JqVkzd9ydJfcfGQsdMsLq3nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Le Ma <le.ma@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 82/99] drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE
Date:   Mon, 20 Dec 2021 15:34:55 +0100
Message-Id: <20211220143032.160264814@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Le Ma <le.ma@amd.com>

commit f3a8076eb28cae1553958c629aecec479394bbe2 upstream.

should count on GC IP base address

Signed-off-by: Le Ma <le.ma@amd.com>
Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3002,8 +3002,8 @@ static void gfx_v9_0_init_pg(struct amdg
 			      AMD_PG_SUPPORT_CP |
 			      AMD_PG_SUPPORT_GDS |
 			      AMD_PG_SUPPORT_RLC_SMU_HS)) {
-		WREG32(mmRLC_JUMP_TABLE_RESTORE,
-		       adev->gfx.rlc.cp_table_gpu_addr >> 8);
+		WREG32_SOC15(GC, 0, mmRLC_JUMP_TABLE_RESTORE,
+			     adev->gfx.rlc.cp_table_gpu_addr >> 8);
 		gfx_v9_0_init_gfx_power_gating(adev);
 	}
 }


