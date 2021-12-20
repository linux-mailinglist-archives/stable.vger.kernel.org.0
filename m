Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566BD47AE73
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbhLTPBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36468 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238765AbhLTO6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1594B80EFA;
        Mon, 20 Dec 2021 14:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3539AC36AE7;
        Mon, 20 Dec 2021 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012287;
        bh=dsct2UcD4Uih0ZFD0rwU5T5uIxV9sZS3AZ8xswL17j8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLkHR4SLelKm/cXJZKjvotpSWmRptX6CmBHHapwKPSabXX5PYqE+SXseTu8ReaGDW
         4BFe5OHxEgLVwmZr2eWqWWv1tg6vd3Im5Dnuf92deX1rZJG6EnzNJ4OfQabCvxS37E
         QKD0nHuaz0piphGXKwAGz6Dy2Tk+v9TsUxbFOeI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Le Ma <le.ma@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 148/177] drm/amdgpu: correct register access for RLC_JUMP_TABLE_RESTORE
Date:   Mon, 20 Dec 2021 15:34:58 +0100
Message-Id: <20211220143045.063063817@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
@@ -3061,8 +3061,8 @@ static void gfx_v9_0_init_pg(struct amdg
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


