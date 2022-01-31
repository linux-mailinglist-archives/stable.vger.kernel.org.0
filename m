Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B224A426C
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239463AbiAaLLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43040 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377155AbiAaLJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:09:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E678F60ECF;
        Mon, 31 Jan 2022 11:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF12EC340E8;
        Mon, 31 Jan 2022 11:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627384;
        bh=LK2UuLpJtYpIxmjyjas8oJvOtSJV5qT3NTNnNy9ERhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e28gjGUNlrr5Px5PR/DDVAhLcAmTO0rpWREfjxj0h0tJtG0bm0vHn01A28iZ9paXj
         +R40xGngWkCASuczyQg817+2MOvzAoIZX9H/b2oR76y/OBEvCRWwH6firnolOB2A4d
         mkWRthNULfM+HvM9tQwsZVNdnZn4oYuiLykupRLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 033/171] drm/amd/display: Fix FP start/end for dcn30_internal_validate_bw.
Date:   Mon, 31 Jan 2022 11:54:58 +0100
Message-Id: <20220131105231.139478639@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
@@ -1879,7 +1879,6 @@ static noinline bool dcn30_internal_vali
 	dc->res_pool->funcs->update_soc_for_wm_a(dc, context);
 	pipe_cnt = dc->res_pool->funcs->populate_dml_pipes(dc, context, pipes, fast_validate);
 
-	DC_FP_START();
 	if (!pipe_cnt) {
 		out = true;
 		goto validate_out;
@@ -2103,7 +2102,6 @@ validate_fail:
 	out = false;
 
 validate_out:
-	DC_FP_END();
 	return out;
 }
 
@@ -2304,7 +2302,9 @@ bool dcn30_validate_bandwidth(struct dc
 
 	BW_VAL_TRACE_COUNT();
 
+	DC_FP_START();
 	out = dcn30_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, fast_validate);
+	DC_FP_END();
 
 	if (pipe_cnt == 0)
 		goto validate_out;


