Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009084A44F6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376532AbiAaLfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378652AbiAaL2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:28:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1590FC06177F;
        Mon, 31 Jan 2022 03:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7B5860E76;
        Mon, 31 Jan 2022 11:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E4DC36AE9;
        Mon, 31 Jan 2022 11:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627855;
        bh=m+wYBcL87JmJfSf+hqGSIeT+s0MdI8nu9iVRXH/o+0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdbotNzpfOWahYO6Wp7VJIAjSHcy3X1o61cn+Oza3LZ6NlF78bSMaj/Y/b1wKpmDT
         pR/IEU011UFC+M/B8lvW/7NOd4pXmSc0RXsq5BvwiGUH7YTf73NH3ZXHVhSxoUCkSE
         MMSy7EqDeUw9Q1AAGXbJoJclIswnO0bNQdYsPVog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 046/200] drm/amd/display: Fix FP start/end for dcn30_internal_validate_bw.
Date:   Mon, 31 Jan 2022 11:55:09 +0100
Message-Id: <20220131105235.105650804@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 72a8d87b87270bff0c0b2fed4d59c48d0dd840d7 upstream.

It calls populate_dml_pipes which uses doubles to initialize the
scale_ratio_depth params. Mirrors the dcn20 logic.

Cc: stable@vger.kernel.org
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -1880,7 +1880,6 @@ noinline bool dcn30_internal_validate_bw
 	dc->res_pool->funcs->update_soc_for_wm_a(dc, context);
 	pipe_cnt = dc->res_pool->funcs->populate_dml_pipes(dc, context, pipes, fast_validate);
 
-	DC_FP_START();
 	if (!pipe_cnt) {
 		out = true;
 		goto validate_out;
@@ -2106,7 +2105,6 @@ validate_fail:
 	out = false;
 
 validate_out:
-	DC_FP_END();
 	return out;
 }
 
@@ -2308,7 +2306,9 @@ bool dcn30_validate_bandwidth(struct dc
 
 	BW_VAL_TRACE_COUNT();
 
+	DC_FP_START();
 	out = dcn30_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate);
+	DC_FP_END();
 
 	if (pipe_cnt == 0)
 		goto validate_out;


