Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0470C2E40C9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440660AbgL1OP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440655AbgL1OPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F054520791;
        Mon, 28 Dec 2020 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164884;
        bh=IrbmXb/o4P1fVDB+f5BWqDuRb5dThD2u1inhrivjWuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntox8Gl4CJVt4mJ1T5jdheEMIhqQCO/ha2RkmOWKNahhGSHzVPJQ6+JFQPno5sjNu
         sd379n5mvFYg4rQWggnHdNwB8RP5eOcmsCX9cZ9y28cgcUdIlaEOrnE8RMHvzTkxSZ
         Dx7B5gicMMbmxES0Rd2CDeMb610YIdeZiUOQBf2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Thompson <funaho@jurai.org>,
        Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/717] macintosh/adb-iop: Always wait for reply message from IOP
Date:   Mon, 28 Dec 2020 13:45:31 +0100
Message-Id: <20201228125036.978731208@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 2c9cfbadfa234b03473f1ef54e6f4772cc07a371 ]

A recent patch incorrectly altered the adb-iop state machine behaviour
and introduced a regression that can appear intermittently as a
malfunctioning ADB input device. This seems to be caused when reply
packets from different ADB commands become mixed up, especially during
the adb bus scan. Fix this by unconditionally entering the awaiting_reply
state after sending an explicit command, even when the ADB command won't
generate a reply from the ADB device.

It turns out that the IOP always generates reply messages, even when the
ADB command does not produce a reply packet (e.g. ADB Listen command).
So it's not really the ADB reply packets that are being mixed up, it's the
IOP messages that enclose them. The bug goes like this:

  1. CPU sends a message to the IOP, expecting no response because this
     message contains an ADB Listen command. The ADB command is now
     considered complete.

  2. CPU sends a second message to the IOP, this time expecting a
     response because this message contains an ADB Talk command. This
     ADB command needs a reply before it can be completed.

  3. adb-iop driver receives an IOP message and assumes that it relates
     to the Talk command. It's actually an empty one (with flags ==
     ADB_IOP_EXPLICIT|ADB_IOP_TIMEOUT) for the previous command. The
     Talk command is now considered complete but it gets the wrong reply
     data.

  4. adb-iop driver gets another IOP response message, which contains
     the actual reply data for the Talk command, but this is dropped
     (the driver is no longer in awaiting_reply state).

Cc: Joshua Thompson <funaho@jurai.org>
Fixes: e2954e5f727f ("macintosh/adb-iop: Implement sending -> idle state transition")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Link: https://lore.kernel.org/r/0f0a25855391e7eaa53a50f651aea0124e8525dd.1605847196.git.fthain@telegraphics.com.au
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/adb-iop.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/macintosh/adb-iop.c b/drivers/macintosh/adb-iop.c
index f3d1a460fbce1..422abd1d48e18 100644
--- a/drivers/macintosh/adb-iop.c
+++ b/drivers/macintosh/adb-iop.c
@@ -78,10 +78,7 @@ static void adb_iop_complete(struct iop_msg *msg)
 
 	local_irq_save(flags);
 
-	if (current_req->reply_expected)
-		adb_iop_state = awaiting_reply;
-	else
-		adb_iop_done();
+	adb_iop_state = awaiting_reply;
 
 	local_irq_restore(flags);
 }
@@ -89,8 +86,9 @@ static void adb_iop_complete(struct iop_msg *msg)
 /*
  * Listen for ADB messages from the IOP.
  *
- * This will be called when unsolicited messages (usually replies to TALK
- * commands or autopoll packets) are received.
+ * This will be called when unsolicited IOP messages are received.
+ * These IOP messages can carry ADB autopoll responses and also occur
+ * after explicit ADB commands.
  */
 
 static void adb_iop_listen(struct iop_msg *msg)
@@ -110,8 +108,10 @@ static void adb_iop_listen(struct iop_msg *msg)
 		if (adb_iop_state == awaiting_reply) {
 			struct adb_request *req = current_req;
 
-			req->reply_len = amsg->count + 1;
-			memcpy(req->reply, &amsg->cmd, req->reply_len);
+			if (req->reply_expected) {
+				req->reply_len = amsg->count + 1;
+				memcpy(req->reply, &amsg->cmd, req->reply_len);
+			}
 
 			req_done = true;
 		}
-- 
2.27.0



