Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9607E17FA96
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbgCJNGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729815AbgCJNGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:06:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E74B520409;
        Tue, 10 Mar 2020 13:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845589;
        bh=qMZfZjJAc3B4ljv/LTIW0NTDOBPIGSC4oCf4+Pk4Swc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9AoZX7XnkVlPExNCRVOgBTLzdm4CmJhYdMzqefScEWPwkvJ2qrdmAPlYc1jOd96z
         ZHF+5SxdpjWx11mb2Ie/yaInN/gVrR4JVyt3ppFEo0SDR4BySLdmdawtjC/XKR5haj
         GtADTYmtxBF3nU/wZ/A3C+AHAwwnfncUiG9tZRUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 029/126] sctp: move the format error check out of __sctp_sf_do_9_1_abort
Date:   Tue, 10 Mar 2020 13:40:50 +0100
Message-Id: <20200310124206.315875697@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 245709ec8be89af46ea7ef0444c9c80913999d99 ]

When T2 timer is to be stopped, the asoc should also be deleted,
otherwise, there will be no chance to call sctp_association_free
and the asoc could last in memory forever.

However, in sctp_sf_shutdown_sent_abort(), after adding the cmd
SCTP_CMD_TIMER_STOP for T2 timer, it may return error due to the
format error from __sctp_sf_do_9_1_abort() and miss adding
SCTP_CMD_ASSOC_FAILED where the asoc will be deleted.

This patch is to fix it by moving the format error check out of
__sctp_sf_do_9_1_abort(), and do it before adding the cmd
SCTP_CMD_TIMER_STOP for T2 timer.

Thanks Hangbin for reporting this issue by the fuzz testing.

v1->v2:
  - improve the comment in the code as Marcelo's suggestion.

Fixes: 96ca468b86b0 ("sctp: check invalid value of length parameter in error cause")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_statefuns.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -182,6 +182,16 @@ static inline bool sctp_chunk_length_val
 	return true;
 }
 
+/* Check for format error in an ABORT chunk */
+static inline bool sctp_err_chunk_valid(struct sctp_chunk *chunk)
+{
+	struct sctp_errhdr *err;
+
+	sctp_walk_errors(err, chunk->chunk_hdr);
+
+	return (void *)err == (void *)chunk->chunk_end;
+}
+
 /**********************************************************
  * These are the state functions for handling chunk events.
  **********************************************************/
@@ -2202,6 +2212,9 @@ enum sctp_disposition sctp_sf_shutdown_p
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	return __sctp_sf_do_9_1_abort(net, ep, asoc, type, arg, commands);
 }
 
@@ -2245,6 +2258,9 @@ enum sctp_disposition sctp_sf_shutdown_s
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Stop the T2-shutdown timer. */
 	sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
 			SCTP_TO(SCTP_EVENT_TIMEOUT_T2_SHUTDOWN));
@@ -2512,6 +2528,9 @@ enum sctp_disposition sctp_sf_do_9_1_abo
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	return __sctp_sf_do_9_1_abort(net, ep, asoc, type, arg, commands);
 }
 
@@ -2529,16 +2548,8 @@ static enum sctp_disposition __sctp_sf_d
 
 	/* See if we have an error cause code in the chunk.  */
 	len = ntohs(chunk->chunk_hdr->length);
-	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr)) {
-		struct sctp_errhdr *err;
-
-		sctp_walk_errors(err, chunk->chunk_hdr);
-		if ((void *)err != (void *)chunk->chunk_end)
-			return sctp_sf_pdiscard(net, ep, asoc, type, arg,
-						commands);
-
+	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr))
 		error = ((struct sctp_errhdr *)chunk->skb->data)->cause;
-	}
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNRESET));
 	/* ASSOC_FAILED will DELETE_TCB. */


