Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C992633B95F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhCOOAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231796AbhCON7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1896064EF5;
        Mon, 15 Mar 2021 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816740;
        bh=lTQct9n1IkwzD/7CujligHvcwD0gKA2pSJrTsueh8M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmvlSqCtdPV4LJ+6aH/tU6R5CGmaJtkj1QMq8MeEhjGDPARWfssXO6Y/+/DZF3MkF
         UIi75g8PDBvT3Bek8Z8DHYF2koRGJqo9wbnr7cc03tuDf0vy0Cq/xU7wGaa3WsJyhS
         s8fwh5awhDv2YQvS7/wawjFUm47YOHMgKLvmVrCc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 086/290] drm/amdgpu/display: use GFP_ATOMIC in dcn21_validate_bandwidth_fp()
Date:   Mon, 15 Mar 2021 14:52:59 +0100
Message-Id: <20210315135544.825773941@linuxfoundation.org>
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

commit 680174cfd1e1cea70a8f30ccb44d8fbdf996018e upstream.

After fixing nested FPU contexts caused by 41401ac67791 we're still seeing
complaints about spurious kernel_fpu_end(). As it turns out this was
already fixed for dcn20 in commit f41ed88cbd ("drm/amdgpu/display:
use GFP_ATOMIC in dcn20_validate_bandwidth_internal") but never moved
forward to dcn21.

Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1183,7 +1183,7 @@ static noinline bool dcn21_validate_band
 	int vlevel = 0;
 	int pipe_split_from[MAX_PIPES];
 	int pipe_cnt = 0;
-	display_e2e_pipe_params_st *pipes = kzalloc(dc->res_pool->pipe_count * sizeof(display_e2e_pipe_params_st), GFP_KERNEL);
+	display_e2e_pipe_params_st *pipes = kzalloc(dc->res_pool->pipe_count * sizeof(display_e2e_pipe_params_st), GFP_ATOMIC);
 	DC_LOGGER_INIT(dc->ctx->logger);
 
 	BW_VAL_TRACE_COUNT();


