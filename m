Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8229938A4DD
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhETKKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:10:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235681AbhETKHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C85086194C;
        Thu, 20 May 2021 09:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503714;
        bh=En/p87Lq9J4RRSEfrbAjHnVo0bJAAFv/8iGW/0QL9NY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzdFEq8EeIS/I8kQPnCz9W6EWLJP1A8vRkvXs/SqCuXv8+vf3DkGBaPouc7j+38z1
         zR0YVhgAOmmK+eBg6CCnR3Igb//grz3h9h9SpaX+uNQKEwPSjN1p8JFG605Y42rqKY
         0AENs+2YoyY32wQKX4qlR1X3eWl++BBr4QfNemEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        syzbot+bbe538efd1046586f587@syzkaller.appspotmail.com,
        Michal Tesar <mtesar@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 346/425] sctp: do asoc update earlier in sctp_sf_do_dupcook_a
Date:   Thu, 20 May 2021 11:21:55 +0200
Message-Id: <20210520092142.782462658@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 35b4f24415c854cd718ccdf38dbea6297f010aae ]

There's a panic that occurs in a few of envs, the call trace is as below:

  [] general protection fault, ... 0x29acd70f1000a: 0000 [#1] SMP PTI
  [] RIP: 0010:sctp_ulpevent_notify_peer_addr_change+0x4b/0x1fa [sctp]
  []  sctp_assoc_control_transport+0x1b9/0x210 [sctp]
  []  sctp_do_8_2_transport_strike.isra.16+0x15c/0x220 [sctp]
  []  sctp_cmd_interpreter.isra.21+0x1231/0x1a10 [sctp]
  []  sctp_do_sm+0xc3/0x2a0 [sctp]
  []  sctp_generate_timeout_event+0x81/0xf0 [sctp]

This is caused by a transport use-after-free issue. When processing a
duplicate COOKIE-ECHO chunk in sctp_sf_do_dupcook_a(), both COOKIE-ACK
and SHUTDOWN chunks are allocated with the transort from the new asoc.
However, later in the sideeffect machine, the old asoc is used to send
them out and old asoc's shutdown_last_sent_to is set to the transport
that SHUTDOWN chunk attached to in sctp_cmd_setup_t2(), which actually
belongs to the new asoc. After the new_asoc is freed and the old asoc
T2 timeout, the old asoc's shutdown_last_sent_to that is already freed
would be accessed in sctp_sf_t2_timer_expire().

Thanks Alexander and Jere for helping dig into this issue.

To fix it, this patch is to do the asoc update first, then allocate
the COOKIE-ACK and SHUTDOWN chunks with the 'updated' old asoc. This
would make more sense, as a chunk from an asoc shouldn't be sent out
with another asoc. We had fixed quite a few issues caused by this.

Fixes: 145cb2f7177d ("sctp: Fix bundling of SHUTDOWN with COOKIE-ACK")
Reported-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Reported-by: syzbot+bbe538efd1046586f587@syzkaller.appspotmail.com
Reported-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index a3033b74df54..882cd5f40a0a 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1856,20 +1856,35 @@ static enum sctp_disposition sctp_sf_do_dupcook_a(
 			SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 	sctp_add_cmd_sf(commands, SCTP_CMD_PURGE_ASCONF_QUEUE, SCTP_NULL());
 
-	repl = sctp_make_cookie_ack(new_asoc, chunk);
+	/* Update the content of current association. */
+	if (sctp_assoc_update((struct sctp_association *)asoc, new_asoc)) {
+		struct sctp_chunk *abort;
+
+		abort = sctp_make_abort(asoc, NULL, sizeof(struct sctp_errhdr));
+		if (abort) {
+			sctp_init_cause(abort, SCTP_ERROR_RSRC_LOW, 0);
+			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
+		}
+		sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR, SCTP_ERROR(ECONNABORTED));
+		sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
+				SCTP_PERR(SCTP_ERROR_RSRC_LOW));
+		SCTP_INC_STATS(net, SCTP_MIB_ABORTEDS);
+		SCTP_DEC_STATS(net, SCTP_MIB_CURRESTAB);
+		goto nomem;
+	}
+
+	repl = sctp_make_cookie_ack(asoc, chunk);
 	if (!repl)
 		goto nomem;
 
 	/* Report association restart to upper layer. */
 	ev = sctp_ulpevent_make_assoc_change(asoc, 0, SCTP_RESTART, 0,
-					     new_asoc->c.sinit_num_ostreams,
-					     new_asoc->c.sinit_max_instreams,
+					     asoc->c.sinit_num_ostreams,
+					     asoc->c.sinit_max_instreams,
 					     NULL, GFP_ATOMIC);
 	if (!ev)
 		goto nomem_ev;
 
-	/* Update the content of current association. */
-	sctp_add_cmd_sf(commands, SCTP_CMD_UPDATE_ASSOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_EVENT_ULP, SCTP_ULPEVENT(ev));
 	if ((sctp_state(asoc, SHUTDOWN_PENDING) ||
 	     sctp_state(asoc, SHUTDOWN_SENT)) &&
-- 
2.30.2



