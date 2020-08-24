Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EB224F4B5
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgHXIjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgHXIjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:39:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D946A22B49;
        Mon, 24 Aug 2020 08:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258378;
        bh=axrNnX8tt3YCR1/f6ugFOlCWrbE2ylmJgM32F8pJ0so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZAy1sheceBcStlEEkIT5Jd8wp0NbLs6H8lbglFxzbWzvjY82+zkeuJAFezR7sYva
         FiH/Yo0tgdHy+C3DRF3mq7uORpNuzmkH30TsOvEZaWS2uzliJL3cZD/0GkpsAWzIC0
         g766AZ8Blxc4BJhPcqilShad1LQjnZwGouw4AMxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Hsieh <paul.hsieh@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 026/124] drm/amd/display: Fix DFPstate hang due to view port changed
Date:   Mon, 24 Aug 2020 10:29:20 +0200
Message-Id: <20200824082410.708270050@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Hsieh <paul.hsieh@amd.com>

commit 8e80d482608a4e6a97c75272ef8b4bcfc5d0c490 upstream.

[Why]
Place the cursor in the center of screen between two pipes then
adjusting the viewport but cursour doesn't update cause DFPstate hang.

[How]
If viewport changed, update cursor as well.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1386,8 +1386,8 @@ static void dcn20_update_dchubp_dpp(
 
 	/* Any updates are handled in dc interface, just need to apply existing for plane enable */
 	if ((pipe_ctx->update_flags.bits.enable || pipe_ctx->update_flags.bits.opp_changed ||
-			pipe_ctx->update_flags.bits.scaler || pipe_ctx->update_flags.bits.viewport)
-			&& pipe_ctx->stream->cursor_attributes.address.quad_part != 0) {
+			pipe_ctx->update_flags.bits.scaler || viewport_changed == true) &&
+			pipe_ctx->stream->cursor_attributes.address.quad_part != 0) {
 		dc->hwss.set_cursor_position(pipe_ctx);
 		dc->hwss.set_cursor_attribute(pipe_ctx);
 


