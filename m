Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F7ACA766
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391209AbfJCQxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393033AbfJCQxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:53:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7000220862;
        Thu,  3 Oct 2019 16:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121622;
        bh=q7eCzLPTDaIpBcf+WZvxds6txD0ESug7P0vRW/8KDuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQ0SHYiJA2E9YWKwSC7iWksueXfqjEeqMR4syTAGF1wr79VM5a/Y+8C66NItNw6jO
         e3Rxba7DadWxrU4HxMSZWzWCwU1mjM06T/rnY7mRKT7j0463V2Sl5DtSu1Z9GFVwkk
         lhjhIAkLUtmBkUQMt73m3c+mQBco3FVH09o0umsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 340/344] drm/amdgpu/display: fix 64 bit divide
Date:   Thu,  3 Oct 2019 17:55:05 +0200
Message-Id: <20191003154612.019908990@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit dd9212a885ca4a95443905c7c3781122a4d664e8 upstream.

Use proper helper for 32 bit.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dce110/dce110_clk_mgr.c
@@ -197,7 +197,9 @@ void dce11_pplib_apply_display_requireme
 	 */
 	if (ASICREV_IS_VEGA20_P(dc->ctx->asic_id.hw_internal_rev) && (context->stream_count >= 2)) {
 		pp_display_cfg->min_memory_clock_khz = max(pp_display_cfg->min_memory_clock_khz,
-			(uint32_t) (dc->bw_vbios->high_yclk.value / memory_type_multiplier / 10000));
+							   (uint32_t) div64_s64(
+								   div64_s64(dc->bw_vbios->high_yclk.value,
+									     memory_type_multiplier), 10000));
 	} else {
 		pp_display_cfg->min_memory_clock_khz = context->bw_ctx.bw.dce.yclk_khz
 			/ memory_type_multiplier;


