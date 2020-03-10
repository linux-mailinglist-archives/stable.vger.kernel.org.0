Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF4217FE74
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgCJMoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbgCJMoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:44:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FEC32469C;
        Tue, 10 Mar 2020 12:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844284;
        bh=0yC6sXkVWtqG7e+QMEiQvk1PLyTDCmV8uQD29gvoQ4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1Yo1pG+qFkG/Ne3vbMsFumhQqiedPTwDXhLKNQUPmSjOSR0ITzG8nL/WC41LhAN2
         /PkSnvauMONRqQtvmK5TZeqDSNpmVOVoLV8E35ji0bZZccXHNOAyIFcVCcOzr1YIHC
         JfBLHLOEMEJhJY6FJ3pyn1n9JIudSO8MBqCca80M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 25/88] sctp: move the format error check out of __sctp_sf_do_9_1_abort
Date:   Tue, 10 Mar 2020 13:38:33 +0100
Message-Id: <20200310123612.059104366@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
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
 net/sctp/sm_statefuns.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -177,6 +177,16 @@ sctp_chunk_length_valid(struct sctp_chun
 	return 1;
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
@@ -2159,6 +2169,9 @@ sctp_disposition_t sctp_sf_shutdown_pend
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	return __sctp_sf_do_9_1_abort(net, ep, asoc, type, arg, commands);
 }
 
@@ -2201,6 +2214,9 @@ sctp_disposition_t sctp_sf_shutdown_sent
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	/* Stop the T2-shutdown timer. */
 	sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
 			SCTP_TO(SCTP_EVENT_TIMEOUT_T2_SHUTDOWN));
@@ -2466,6 +2482,9 @@ sctp_disposition_t sctp_sf_do_9_1_abort(
 		    sctp_bind_addr_state(&asoc->base.bind_addr, &chunk->dest))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg, commands);
 
+	if (!sctp_err_chunk_valid(chunk))
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+
 	return __sctp_sf_do_9_1_abort(net, ep, asoc, type, arg, commands);
 }
 
@@ -2482,15 +2501,9 @@ static sctp_disposition_t __sctp_sf_do_9
 
 	/* See if we have an error cause code in the chunk.  */
 	len = ntohs(chunk->chunk_hdr->length);
-	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr)) {
-
-		sctp_errhdr_t *err;
-		sctp_walk_errors(err, chunk->chunk_hdr);
-		if ((void *)err != (void *)chunk->chunk_end)
-			return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
+	if (len >= sizeof(struct sctp_chunkhdr) + sizeof(struct sctp_errhdr))
 		error = ((sctp_errhdr_t *)chunk->skb->data)->cause;
-	}
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNRESET));
 	/* ASSOC_FAILED will DELETE_TCB. */


