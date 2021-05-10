Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0991B37883C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbhEJLVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235039AbhEJLKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C501561076;
        Mon, 10 May 2021 11:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644717;
        bh=cm2ZjP+nxhlFxgOpMS2UzryGqdVadZ3ecCcGZd1vV4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BbXIjl8xW3zKPPr3CVRZiuar2lc1bZCcdZ5YEPkeMN/aQSNg3M+GhPSbS05gDbP3K
         WceL2UFpWsAkDkNMNZOfotMos5LXMTpfPmWm2ATV4y4KsbM43LWvu299Yq46L7kCbx
         Dv0pRvq44Qh+qXYLRjSU55qQSGvzBiFpSZ01W8z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Joshua Aberback <joshua.aberback@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 188/384] drm/amd/display: Align cursor cache address to 2KB
Date:   Mon, 10 May 2021 12:19:37 +0200
Message-Id: <20210510102021.082753619@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Aberback <joshua.aberback@amd.com>

[ Upstream commit 554ba183b135ef09250b61a202d88512b5bbd03a ]

[Why]
The registers for the address of the cursor are aligned to 2KB, so all
cursor surfaces also need to be aligned to 2KB. Currently, the
provided cursor cache surface is not aligned, so we need a workaround
until alignment is enforced by the surface provider.

[How]
 - round up surface address to nearest multiple of 2048
 - current policy is to provide a much bigger cache size than
   necessary,so this operation is safe

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Joshua Aberback <joshua.aberback@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
index 06dc1e2e8383..07c8d2e2c09c 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -848,7 +848,7 @@ bool dcn30_apply_idle_power_optimizations(struct dc *dc, bool enable)
 
 					cmd.mall.cursor_copy_src.quad_part = cursor_attr.address.quad_part;
 					cmd.mall.cursor_copy_dst.quad_part =
-							plane->address.grph.cursor_cache_addr.quad_part;
+							(plane->address.grph.cursor_cache_addr.quad_part + 2047) & ~2047;
 					cmd.mall.cursor_width = cursor_attr.width;
 					cmd.mall.cursor_height = cursor_attr.height;
 					cmd.mall.cursor_pitch = cursor_attr.pitch;
@@ -858,8 +858,7 @@ bool dcn30_apply_idle_power_optimizations(struct dc *dc, bool enable)
 					dc_dmub_srv_wait_idle(dc->ctx->dmub_srv);
 
 					/* Use copied cursor, and it's okay to not switch back */
-					cursor_attr.address.quad_part =
-							plane->address.grph.cursor_cache_addr.quad_part;
+					cursor_attr.address.quad_part = cmd.mall.cursor_copy_dst.quad_part;
 					dc_stream_set_cursor_attributes(stream, &cursor_attr);
 				}
 
-- 
2.30.2



