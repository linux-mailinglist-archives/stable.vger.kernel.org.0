Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65812E40D3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgL1O6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:58:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440535AbgL1OPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7B452063A;
        Mon, 28 Dec 2020 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164887;
        bh=3lwTBp/eJdjVyxptzJkV4TPmxFPT3vj9fTV7sJL9vVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veKwmwofYr4O2rywVltwqyCmrORa+jIv0sxK2NQavzEfrnLMBxwDMYk2dPjCb0l5a
         fgVYbrfNYm5OiKdGa2FUrWBTVs1mqutG/mICkwXtExhLkecdRp5i2st65VC3qv0C0w
         f2z8TFHL9uQ6OYTnvOKpvVqWnD48QXJr1INyV5YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Thompson <funaho@jurai.org>,
        Stan Johnson <userm57@yahoo.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/717] macintosh/adb-iop: Send correct poll command
Date:   Mon, 28 Dec 2020 13:45:32 +0100
Message-Id: <20201228125037.022143633@linuxfoundation.org>
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

[ Upstream commit 10199e90ee20e68859f8128331ec8d85b036d349 ]

The behaviour of the IOP firmware is not well documented but we do know
that IOP message reply data can be used to issue new ADB commands.
Use the message reply to better control autopoll behaviour by sending
a Talk Register 0 command after every ADB response, not unlike the
algorithm in the via-macii driver. This poll command is addressed to
that device which last received a Talk command (explicit or otherwise).

Cc: Joshua Thompson <funaho@jurai.org>
Fixes: 32226e817043 ("macintosh/adb-iop: Implement idle -> sending state transition")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Link: https://lore.kernel.org/r/58bba4310da4c29b068345a4b36af8a531397ff7.1605847196.git.fthain@telegraphics.com.au
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/adb-iop.c | 40 +++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/macintosh/adb-iop.c b/drivers/macintosh/adb-iop.c
index 422abd1d48e18..0ee3272491501 100644
--- a/drivers/macintosh/adb-iop.c
+++ b/drivers/macintosh/adb-iop.c
@@ -25,6 +25,7 @@
 static struct adb_request *current_req;
 static struct adb_request *last_req;
 static unsigned int autopoll_devs;
+static u8 autopoll_addr;
 
 static enum adb_iop_state {
 	idle,
@@ -41,6 +42,11 @@ static int adb_iop_autopoll(int);
 static void adb_iop_poll(void);
 static int adb_iop_reset_bus(void);
 
+/* ADB command byte structure */
+#define ADDR_MASK       0xF0
+#define OP_MASK         0x0C
+#define TALK            0x0C
+
 struct adb_driver adb_iop_driver = {
 	.name         = "ISM IOP",
 	.probe        = adb_iop_probe,
@@ -94,17 +100,24 @@ static void adb_iop_complete(struct iop_msg *msg)
 static void adb_iop_listen(struct iop_msg *msg)
 {
 	struct adb_iopmsg *amsg = (struct adb_iopmsg *)msg->message;
+	u8 addr = (amsg->cmd & ADDR_MASK) >> 4;
+	u8 op = amsg->cmd & OP_MASK;
 	unsigned long flags;
 	bool req_done = false;
 
 	local_irq_save(flags);
 
-	/* Handle a timeout. Timeout packets seem to occur even after
-	 * we've gotten a valid reply to a TALK, presumably because of
-	 * autopolling.
+	/* Responses to Talk commands may be unsolicited as they are
+	 * produced when the IOP polls devices. They are mostly timeouts.
 	 */
-
-	if (amsg->flags & ADB_IOP_EXPLICIT) {
+	if (op == TALK && ((1 << addr) & autopoll_devs))
+		autopoll_addr = addr;
+
+	switch (amsg->flags & (ADB_IOP_EXPLICIT |
+			       ADB_IOP_AUTOPOLL |
+			       ADB_IOP_TIMEOUT)) {
+	case ADB_IOP_EXPLICIT:
+	case ADB_IOP_EXPLICIT | ADB_IOP_TIMEOUT:
 		if (adb_iop_state == awaiting_reply) {
 			struct adb_request *req = current_req;
 
@@ -115,12 +128,16 @@ static void adb_iop_listen(struct iop_msg *msg)
 
 			req_done = true;
 		}
-	} else if (!(amsg->flags & ADB_IOP_TIMEOUT)) {
-		adb_input(&amsg->cmd, amsg->count + 1,
-			  amsg->flags & ADB_IOP_AUTOPOLL);
+		break;
+	case ADB_IOP_AUTOPOLL:
+		if (((1 << addr) & autopoll_devs) &&
+		    amsg->cmd == ADB_READREG(addr, 0))
+			adb_input(&amsg->cmd, amsg->count + 1, 1);
+		break;
 	}
-
-	msg->reply[0] = autopoll_devs ? ADB_IOP_AUTOPOLL : 0;
+	msg->reply[0] = autopoll_addr ? ADB_IOP_AUTOPOLL : 0;
+	msg->reply[1] = 0;
+	msg->reply[2] = autopoll_addr ? ADB_READREG(autopoll_addr, 0) : 0;
 	iop_complete_message(msg);
 
 	if (req_done)
@@ -233,6 +250,9 @@ static void adb_iop_set_ap_complete(struct iop_msg *msg)
 	struct adb_iopmsg *amsg = (struct adb_iopmsg *)msg->message;
 
 	autopoll_devs = (amsg->data[1] << 8) | amsg->data[0];
+	if (autopoll_devs & (1 << autopoll_addr))
+		return;
+	autopoll_addr = autopoll_devs ? (ffs(autopoll_devs) - 1) : 0;
 }
 
 static int adb_iop_autopoll(int devs)
-- 
2.27.0



