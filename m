Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4617D30338F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbhAZE6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:58:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730861AbhAYSt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:49:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60F3A224BE;
        Mon, 25 Jan 2021 18:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600558;
        bh=RCdUoE/Y+glTIaYh+pI0sAgtfOnQltxunsLoTXBRKlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQXoyMM8M8jgKJSqY75QXONR6UxyT/R6MgtZ4GG4jJf1OLj/leZAkvq/P6rOKDDLn
         nxd0hsDOm/gv9AwxHS5TI3tlWAL42+sUain78hYCh11Mo61VYZgBR3izs2crN1ZsOU
         lkgytwofGgc5M6zATVWJpdHiNNyHgz9jlxZLgJG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Sung Lee <sung.lee@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Anson Jacob <anson.jacob@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 031/199] drm/amd/display: DCN2X Find Secondary Pipe properly in MPO + ODM Case
Date:   Mon, 25 Jan 2021 19:37:33 +0100
Message-Id: <20210125183217.566454461@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

commit 348fe1ca5ccdca0f8c285e2ab99004fdcd531430 upstream.

[WHY]
Previously as MPO + ODM Combine was not supported, finding secondary pipes
for each case was mutually exclusive. Now that both are supported at the same
time, both cases should be taken into account when finding a secondary pipe.

[HOW]
If a secondary pipe cannot be found based on previous bottom pipe,
search for a second pipe using next_odm_pipe instead.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Anson Jacob <anson.jacob@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.10.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2520,8 +2520,7 @@ struct pipe_ctx *dcn20_find_secondary_pi
 		 * if this primary pipe has a bottom pipe in prev. state
 		 * and if the bottom pipe is still available (which it should be),
 		 * pick that pipe as secondary
-		 * Same logic applies for ODM pipes. Since mpo is not allowed with odm
-		 * check in else case.
+		 * Same logic applies for ODM pipes
 		 */
 		if (dc->current_state->res_ctx.pipe_ctx[primary_pipe->pipe_idx].bottom_pipe) {
 			preferred_pipe_idx = dc->current_state->res_ctx.pipe_ctx[primary_pipe->pipe_idx].bottom_pipe->pipe_idx;
@@ -2529,7 +2528,9 @@ struct pipe_ctx *dcn20_find_secondary_pi
 				secondary_pipe = &res_ctx->pipe_ctx[preferred_pipe_idx];
 				secondary_pipe->pipe_idx = preferred_pipe_idx;
 			}
-		} else if (dc->current_state->res_ctx.pipe_ctx[primary_pipe->pipe_idx].next_odm_pipe) {
+		}
+		if (secondary_pipe == NULL &&
+				dc->current_state->res_ctx.pipe_ctx[primary_pipe->pipe_idx].next_odm_pipe) {
 			preferred_pipe_idx = dc->current_state->res_ctx.pipe_ctx[primary_pipe->pipe_idx].next_odm_pipe->pipe_idx;
 			if (res_ctx->pipe_ctx[preferred_pipe_idx].stream == NULL) {
 				secondary_pipe = &res_ctx->pipe_ctx[preferred_pipe_idx];


