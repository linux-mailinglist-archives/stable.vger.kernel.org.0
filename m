Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD039540BB8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344408AbiFGSbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351397AbiFGS32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC571760F7;
        Tue,  7 Jun 2022 10:55:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA3D1617A8;
        Tue,  7 Jun 2022 17:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC29C3411F;
        Tue,  7 Jun 2022 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624511;
        bh=jE3W0hdEMyYHxjf7LaaIstu20hqOtMFfzW4n4q0p/Ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2PlgfQzFg78AS9U9KfRknMHu5wihDXx/8EoPYfT7J+ySDfg8mdtNM3QJTLAgiZng
         LRSeQ1n2X9aQdr5eVZj9UWNBZCvEy5WDqyiwsFZOhWUAi+izK/xCecKGHjtxFHRNnP
         2p41mVna6IsaaTDw9uNSEH6S2RqYKZwkIKkLfEnS05YUl6iDEvlAHSOSM74HAOvAJk
         +BCvCOgZM2NxD2avcEZ3yp0tk0vkFhi0COuOB9OCLXFUinMtnGjeDzIj+V6n2kB0wT
         bnWpRqsaQZgn9SuvDyBWLuHA545nOJGIPdXtXZFnEaVYXWCRyRB5+LSn5Vd/EZ39KO
         Ynh3AChe3Ix8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, Jouni Malinen <j@w1.fi>,
        anton ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        siglesias@igalia.com, dsterba@suse.com, jcmvbkbc@gmail.com,
        jirislaby@kernel.org, gregkh@linuxfoundation.org,
        linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 45/60] um: line: Use separate IRQs per line
Date:   Tue,  7 Jun 2022 13:52:42 -0400
Message-Id: <20220607175259.478835-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d5a9597d6916a76663085db984cb8fe97f0a5c56 ]

Today, all possible serial lines (ssl*=) as well as all
possible consoles (con*=) each share a single interrupt
(with a fixed number) with others of the same type.

Now, if you have two lines, say ssl0 and ssl1, and one
of them is connected to an fd you cannot read (e.g. a
file), but the other gets a read interrupt, then both
of them get the interrupt since it's shared. Then, the
read() call will return EOF, since it's a file being
written and there's nothing to read (at least not at
the current offset, at the end).

Unfortunately, this is treated as a read error, and we
close this line, losing all the possible output.

It might be possible to work around this and make the
IRQ sharing work, however, now that we have dynamically
allocated IRQs that are easy to use, simply use that to
achieve separating between the events; then there's no
interrupt for that line and we never attempt the read
in the first place, thus not closing the line.

This manifested itself in the wifi hostap/hwsim tests
where the parallel script communicates via one serial
console and the kernel messages go to another (a file)
and sending data on the communication console caused
the kernel messages to stop flowing into the file.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-By: anton ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/chan_kern.c     | 10 +++++-----
 arch/um/drivers/line.c          | 22 +++++++++++++---------
 arch/um/drivers/line.h          |  4 ++--
 arch/um/drivers/ssl.c           |  2 --
 arch/um/drivers/stdio_console.c |  2 --
 arch/um/include/asm/irq.h       | 22 +++++++++-------------
 6 files changed, 29 insertions(+), 33 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 62997055c454..26a702a06515 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -133,7 +133,7 @@ static void line_timer_cb(struct work_struct *work)
 	struct line *line = container_of(work, struct line, task.work);
 
 	if (!line->throttled)
-		chan_interrupt(line, line->driver->read_irq);
+		chan_interrupt(line, line->read_irq);
 }
 
 int enable_chan(struct line *line)
@@ -195,9 +195,9 @@ void free_irqs(void)
 		chan = list_entry(ele, struct chan, free_list);
 
 		if (chan->input && chan->enabled)
-			um_free_irq(chan->line->driver->read_irq, chan);
+			um_free_irq(chan->line->read_irq, chan);
 		if (chan->output && chan->enabled)
-			um_free_irq(chan->line->driver->write_irq, chan);
+			um_free_irq(chan->line->write_irq, chan);
 		chan->enabled = 0;
 	}
 }
@@ -215,9 +215,9 @@ static void close_one_chan(struct chan *chan, int delay_free_irq)
 		spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 	} else {
 		if (chan->input && chan->enabled)
-			um_free_irq(chan->line->driver->read_irq, chan);
+			um_free_irq(chan->line->read_irq, chan);
 		if (chan->output && chan->enabled)
-			um_free_irq(chan->line->driver->write_irq, chan);
+			um_free_irq(chan->line->write_irq, chan);
 		chan->enabled = 0;
 	}
 	if (chan->ops->close != NULL)
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 8febf95da96e..02b0befd6763 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -139,7 +139,7 @@ static int flush_buffer(struct line *line)
 		count = line->buffer + LINE_BUFSIZE - line->head;
 
 		n = write_chan(line->chan_out, line->head, count,
-			       line->driver->write_irq);
+			       line->write_irq);
 		if (n < 0)
 			return n;
 		if (n == count) {
@@ -156,7 +156,7 @@ static int flush_buffer(struct line *line)
 
 	count = line->tail - line->head;
 	n = write_chan(line->chan_out, line->head, count,
-		       line->driver->write_irq);
+		       line->write_irq);
 
 	if (n < 0)
 		return n;
@@ -195,7 +195,7 @@ int line_write(struct tty_struct *tty, const unsigned char *buf, int len)
 		ret = buffer_data(line, buf, len);
 	else {
 		n = write_chan(line->chan_out, buf, len,
-			       line->driver->write_irq);
+			       line->write_irq);
 		if (n < 0) {
 			ret = n;
 			goto out_up;
@@ -215,7 +215,7 @@ void line_throttle(struct tty_struct *tty)
 {
 	struct line *line = tty->driver_data;
 
-	deactivate_chan(line->chan_in, line->driver->read_irq);
+	deactivate_chan(line->chan_in, line->read_irq);
 	line->throttled = 1;
 }
 
@@ -224,7 +224,7 @@ void line_unthrottle(struct tty_struct *tty)
 	struct line *line = tty->driver_data;
 
 	line->throttled = 0;
-	chan_interrupt(line, line->driver->read_irq);
+	chan_interrupt(line, line->read_irq);
 }
 
 static irqreturn_t line_write_interrupt(int irq, void *data)
@@ -260,19 +260,23 @@ int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
 	int err;
 
 	if (input) {
-		err = um_request_irq(driver->read_irq, fd, IRQ_READ,
-				     line_interrupt, IRQF_SHARED,
+		err = um_request_irq(UM_IRQ_ALLOC, fd, IRQ_READ,
+				     line_interrupt, 0,
 				     driver->read_irq_name, data);
 		if (err < 0)
 			return err;
+
+		line->read_irq = err;
 	}
 
 	if (output) {
-		err = um_request_irq(driver->write_irq, fd, IRQ_WRITE,
-				     line_write_interrupt, IRQF_SHARED,
+		err = um_request_irq(UM_IRQ_ALLOC, fd, IRQ_WRITE,
+				     line_write_interrupt, 0,
 				     driver->write_irq_name, data);
 		if (err < 0)
 			return err;
+
+		line->write_irq = err;
 	}
 
 	return 0;
diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
index bdb16b96e76f..f15be75a3bf3 100644
--- a/arch/um/drivers/line.h
+++ b/arch/um/drivers/line.h
@@ -23,9 +23,7 @@ struct line_driver {
 	const short minor_start;
 	const short type;
 	const short subtype;
-	const int read_irq;
 	const char *read_irq_name;
-	const int write_irq;
 	const char *write_irq_name;
 	struct mc_device mc;
 	struct tty_driver *driver;
@@ -35,6 +33,8 @@ struct line {
 	struct tty_port port;
 	int valid;
 
+	int read_irq, write_irq;
+
 	char *init_str;
 	struct list_head chan_list;
 	struct chan *chan_in, *chan_out;
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 41eae2e8fb65..8514966778d5 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -47,9 +47,7 @@ static struct line_driver driver = {
 	.minor_start 		= 64,
 	.type 		 	= TTY_DRIVER_TYPE_SERIAL,
 	.subtype 	 	= 0,
-	.read_irq 		= SSL_IRQ,
 	.read_irq_name 		= "ssl",
-	.write_irq 		= SSL_WRITE_IRQ,
 	.write_irq_name 	= "ssl-write",
 	.mc  = {
 		.list		= LIST_HEAD_INIT(driver.mc.list),
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index e8b762f4d8c2..489d5a746ed3 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -53,9 +53,7 @@ static struct line_driver driver = {
 	.minor_start 		= 0,
 	.type 		 	= TTY_DRIVER_TYPE_CONSOLE,
 	.subtype 	 	= SYSTEM_TYPE_CONSOLE,
-	.read_irq 		= CONSOLE_IRQ,
 	.read_irq_name 		= "console",
-	.write_irq 		= CONSOLE_WRITE_IRQ,
 	.write_irq_name 	= "console-write",
 	.mc  = {
 		.list		= LIST_HEAD_INIT(driver.mc.list),
diff --git a/arch/um/include/asm/irq.h b/arch/um/include/asm/irq.h
index e187c789369d..749dfe8512e8 100644
--- a/arch/um/include/asm/irq.h
+++ b/arch/um/include/asm/irq.h
@@ -4,19 +4,15 @@
 
 #define TIMER_IRQ		0
 #define UMN_IRQ			1
-#define CONSOLE_IRQ		2
-#define CONSOLE_WRITE_IRQ	3
-#define UBD_IRQ			4
-#define UM_ETH_IRQ		5
-#define SSL_IRQ			6
-#define SSL_WRITE_IRQ		7
-#define ACCEPT_IRQ		8
-#define MCONSOLE_IRQ		9
-#define WINCH_IRQ		10
-#define SIGIO_WRITE_IRQ 	11
-#define TELNETD_IRQ 		12
-#define XTERM_IRQ 		13
-#define RANDOM_IRQ 		14
+#define UBD_IRQ			2
+#define UM_ETH_IRQ		3
+#define ACCEPT_IRQ		4
+#define MCONSOLE_IRQ		5
+#define WINCH_IRQ		6
+#define SIGIO_WRITE_IRQ 	7
+#define TELNETD_IRQ 		8
+#define XTERM_IRQ 		9
+#define RANDOM_IRQ 		10
 
 #ifdef CONFIG_UML_NET_VECTOR
 
-- 
2.35.1

