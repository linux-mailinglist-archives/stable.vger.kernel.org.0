Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BD833B78A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhCOOAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232645AbhCON7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F90A64F34;
        Mon, 15 Mar 2021 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816741;
        bh=nEhMUSXITP2LzNXPsSS6OHxbgy/5HGkC3u513vhGvvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yy/2G+rxGbvDZ7A7QsN2uJ2zvO+P/tKDDca6hlh13PoSz6ixuqi0v24dvuP4rQTsH
         XDaZNAzWTOXB55BhLx2UixANw1kLGrYzcpw3/ZnLEpX17oHahwXXYC9QWhwFZxgfHF
         g6JszdmDwexIONkRORatq5SXsqUVCTSgv6fBOLUw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 087/290] drm/amd/display: Fix nested FPU context in dcn21_validate_bandwidth()
Date:   Mon, 15 Mar 2021 14:53:00 +0100
Message-Id: <20210315135544.863621681@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Holger Hoffstätte <holger@applied-asynchrony.com>

commit 15e8b95d5f7509e0b09289be8c422c459c9f0412 upstream.

Commit 41401ac67791 added FPU wrappers to dcn21_validate_bandwidth(),
which was correct. Unfortunately a nested function alredy contained
DC_FP_START()/DC_FP_END() calls, which results in nested FPU context
enter/exit and complaints by kernel_fpu_begin_mask().
This can be observed e.g. with 5.10.20, which backported 41401ac67791
and now emits the following warning on boot:

WARNING: CPU: 6 PID: 858 at arch/x86/kernel/fpu/core.c:129 kernel_fpu_begin_mask+0xa5/0xc0
Call Trace:
 dcn21_calculate_wm+0x47/0xa90 [amdgpu]
 dcn21_validate_bandwidth_fp+0x15d/0x2b0 [amdgpu]
 dcn21_validate_bandwidth+0x29/0x40 [amdgpu]
 dc_validate_global_state+0x3c7/0x4c0 [amdgpu]

The warning is emitted due to the additional DC_FP_START/END calls in
patch_bounding_box(), which is inlined into dcn21_calculate_wm(),
its only caller. Removing the calls brings the code in line with
dcn20 and makes the warning disappear.

Fixes: 41401ac67791 ("drm/amd/display: Add FPU wrappers to dcn21_validate_bandwidth()")
Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1058,8 +1058,6 @@ static void patch_bounding_box(struct dc
 {
 	int i;
 
-	DC_FP_START();
-
 	if (dc->bb_overrides.sr_exit_time_ns) {
 		for (i = 0; i < WM_SET_COUNT; i++) {
 			  dc->clk_mgr->bw_params->wm_table.entries[i].sr_exit_time_us =
@@ -1084,8 +1082,6 @@ static void patch_bounding_box(struct dc
 				dc->bb_overrides.dram_clock_change_latency_ns / 1000.0;
 		}
 	}
-
-	DC_FP_END();
 }
 
 void dcn21_calculate_wm(


