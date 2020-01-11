Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C598137D61
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAKJ4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728808AbgAKJ4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:56:48 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628AF2082E;
        Sat, 11 Jan 2020 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736608;
        bh=xDOMMB9ystxw+a1rSxFAe89xjbK99JXyBZKfIo7oCG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUXbJcZxXWSRwlwvk4Opgy3WDTq7sPNrNsVwvyParAzq0jNpsMljgdDPzW/E3cWyu
         upWvhi/xOVn1sboLH2GVdqvvPuMtoysIVC2f6Bv/FNvrWxFu+J34eRE5Zuyb1ApEko
         VdQwClZwwQsv07JCFv3rtArkGnJtV7pMt9A3vpzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+107c4aff5f392bf1517f@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 52/59] sctp: free cmd->obj.chunk for the unprocessed SCTP_CMD_REPLY
Date:   Sat, 11 Jan 2020 10:50:01 +0100
Message-Id: <20200111094851.066800319@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit be7a7729207797476b6666f046d765bdf9630407 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1333,8 +1333,10 @@ static int sctp_cmd_interpreter(sctp_eve
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
@@ -1356,7 +1358,8 @@ static int sctp_cmd_interpreter(sctp_eve
 			if (!new_obj) {
 				if (cmd->obj.chunk)
 					sctp_chunk_free(cmd->obj.chunk);
-				goto nomem;
+				error = -ENOMEM;
+				break;
 			}
 			sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
 					SCTP_CHUNK(new_obj));
@@ -1403,8 +1406,10 @@ static int sctp_cmd_interpreter(sctp_eve
 
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
@@ -1733,11 +1738,17 @@ static int sctp_cmd_interpreter(sctp_eve
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
@@ -1748,8 +1759,5 @@ out:
 	} else if (local_cork)
 		error = sctp_outq_uncork(&asoc->outqueue);
 	return error;
-nomem:
-	error = -ENOMEM;
-	goto out;
 }
 


