Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E609C1B6849
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgDWXOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:14:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49908 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728465AbgDWXGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-0004i3-Tc; Fri, 24 Apr 2020 00:06:37 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvT-00E6sh-4Z; Fri, 24 Apr 2020 00:06:35 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com,
        "Xin Long" <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Fri, 24 Apr 2020 00:06:26 +0100
Message-ID: <lsq.1587683028.744084956@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 159/245] sctp: free cmd->obj.chunk for the
 unprocessed SCTP_CMD_REPLY
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

commit be7a7729207797476b6666f046d765bdf9630407 upstream.

This patch is to fix a memleak caused by no place to free cmd->obj.chunk
for the unprocessed SCTP_CMD_REPLY. This issue occurs when failing to
process a cmd while there're still SCTP_CMD_REPLY cmds on the cmd seq
with an allocated chunk in cmd->obj.chunk.

So fix it by freeing cmd->obj.chunk for each SCTP_CMD_REPLY cmd left on
the cmd seq when any cmd returns error. While at it, also remove 'nomem'
label.

Reported-by: syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/sm_sideeffect.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1327,8 +1327,10 @@ static int sctp_cmd_interpreter(sctp_eve
 			/* Generate an INIT ACK chunk.  */
 			new_obj = sctp_make_init_ack(asoc, chunk, GFP_ATOMIC,
 						     0);
-			if (!new_obj)
-				goto nomem;
+			if (!new_obj) {
+				error = -ENOMEM;
+				break;
+			}
 
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1350,7 +1352,8 @@ static int sctp_cmd_interpreter(sctp_eve
 			if (!new_obj) {
 				if (cmd->obj.chunk)
 					sctp_chunk_free(cmd->obj.chunk);
-				goto nomem;
+				error = -ENOMEM;
+				break;
 			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1397,8 +1400,10 @@ static int sctp_cmd_interpreter(sctp_eve
 
 			/* Generate a SHUTDOWN chunk.  */
 			new_obj = sctp_make_shutdown(asoc, chunk);
-			if (!new_obj)
-				goto nomem;
+			if (!new_obj) {
+				error = -ENOMEM;
+				break;
+			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
 			break;
@@ -1727,11 +1732,17 @@ static int sctp_cmd_interpreter(sctp_eve
 			break;
 		}
 
-		if (error)
+		if (error) {
+			cmd = sctp_next_cmd(commands);
+			while (cmd) {
+				if (cmd->verb == SCTP_CMD_REPLY)
+					sctp_chunk_free(cmd->obj.chunk);
+				cmd = sctp_next_cmd(commands);
+			}
 			break;
+		}
 	}
 
-out:
 	/* If this is in response to a received chunk, wait until
 	 * we are done with the packet to open the queue so that we don't
 	 * send multiple packets in response to a single request.
@@ -1742,8 +1753,5 @@ out:
 	} else if (local_cork)
 		error = sctp_outq_uncork(&asoc->outqueue);
 	return error;
-nomem:
-	error = -ENOMEM;
-	goto out;
 }
 

