Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD9F24FAB7
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgHXJ7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgHXIdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:33:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EEEE2074D;
        Mon, 24 Aug 2020 08:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258012;
        bh=axrNnX8tt3YCR1/f6ugFOlCWrbE2ylmJgM32F8pJ0so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wznB91/4kFrpN6fpXiVaz3yS7JQdReTEahRaLGQdV6MuguFtOY6XPpbup9ghuD3BW
         9ZaPJ/4tdzcMvP6MsQhrLkWLofnykqipWaPr79Wv3ywU4QCdcQTwR5BvTH6wnpi7nF
         S6dstRQq0pjHtzoAe6/bhY7DIi6Gbnm3qoXMjZBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Hsieh <paul.hsieh@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.8 041/148] drm/amd/display: Fix DFPstate hang due to view port changed
Date:   Mon, 24 Aug 2020 10:28:59 +0200
Message-Id: <20200824082416.020090440@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
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
 


