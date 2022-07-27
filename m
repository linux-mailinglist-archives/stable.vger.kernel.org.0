Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B469582AC4
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235579AbiG0QXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbiG0QWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:22:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458A04D156;
        Wed, 27 Jul 2022 09:22:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1002B821BA;
        Wed, 27 Jul 2022 16:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AF5C433D6;
        Wed, 27 Jul 2022 16:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938959;
        bh=NOaMqmolZtU2KMqTQcqCC64uDINdooRxukQ0lehgjVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yM5p0c22micElTXuENHZZ9eg5F2njXHJmPRmlN6TH+TbE13xSR3JfFxa7b3huEQQ+
         8o7/oEg/nmofyOHoPkMmNfGTmm1FJ5x7Cv9NcnF+RuJ764f4exHn0Rpf5cshN4SWo/
         bhnpjg6UVni1U8bjytmXe/IPvSKWb+6e7HowGjhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Johan Hovold <johan@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 4.9 21/26] tty: drivers/tty/, stop using tty_schedule_flip()
Date:   Wed, 27 Jul 2022 18:10:50 +0200
Message-Id: <20220727160959.967594096@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
References: <20220727160959.122591422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 5f6a85158ccacc3f09744b3aafe8b11ab3b6c6f6 upstream.

Since commit a9c3f68f3cd8d (tty: Fix low_latency BUG) in 2014,
tty_flip_buffer_push() is only a wrapper to tty_schedule_flip(). We are
going to remove the latter (as it is used less), so call the former in
drivers/tty/.

Cc: Vladimir Zapolskiy <vz@mleia.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20211122111648.30379-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/cyclades.c          |    6 +++---
 drivers/tty/goldfish.c          |    2 +-
 drivers/tty/moxa.c              |    4 ++--
 drivers/tty/serial/lpc32xx_hs.c |    2 +-
 drivers/tty/vt/keyboard.c       |    6 +++---
 drivers/tty/vt/vt.c             |    2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -556,7 +556,7 @@ static void cyy_chip_rx(struct cyclades_
 		}
 		info->idle_stats.recv_idle = jiffies;
 	}
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 
 	/* end of service */
 	cyy_writeb(info, CyRIR, save_xir & 0x3f);
@@ -998,7 +998,7 @@ static void cyz_handle_rx(struct cyclade
 				jiffies + 1);
 #endif
 	info->idle_stats.recv_idle = jiffies;
-	tty_schedule_flip(&info->port);
+	tty_flip_buffer_push(&info->port);
 
 	/* Update rx_get */
 	cy_writel(&buf_ctrl->rx_get, new_rx_get);
@@ -1174,7 +1174,7 @@ static void cyz_handle_cmd(struct cyclad
 		if (delta_count)
 			wake_up_interruptible(&info->port.delta_msr_wait);
 		if (special_count)
-			tty_schedule_flip(&info->port);
+			tty_flip_buffer_push(&info->port);
 	}
 }
 
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -85,7 +85,7 @@ static irqreturn_t goldfish_tty_interrup
 	writel(count, base + GOLDFISH_TTY_DATA_LEN);
 	writel(GOLDFISH_TTY_CMD_READ_BUFFER, base + GOLDFISH_TTY_CMD);
 	spin_unlock_irqrestore(&qtty->lock, irq_flags);
-	tty_schedule_flip(&qtty->port);
+	tty_flip_buffer_push(&qtty->port);
 	return IRQ_HANDLED;
 }
 
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1397,7 +1397,7 @@ static int moxa_poll_port(struct moxa_po
 		if (inited && !tty_throttled(tty) &&
 				MoxaPortRxQueue(p) > 0) { /* RX */
 			MoxaPortReadData(p);
-			tty_schedule_flip(&p->port);
+			tty_flip_buffer_push(&p->port);
 		}
 	} else {
 		clear_bit(EMPTYWAIT, &p->statusflags);
@@ -1422,7 +1422,7 @@ static int moxa_poll_port(struct moxa_po
 
 	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
 		tty_insert_flip_char(&p->port, 0, TTY_BREAK);
-		tty_schedule_flip(&p->port);
+		tty_flip_buffer_push(&p->port);
 	}
 
 	if (intr & IntrLine)
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -350,7 +350,7 @@ static irqreturn_t serial_lpc32xx_interr
 		       LPC32XX_HSUART_IIR(port->membase));
 		port->icount.overrun++;
 		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
-		tty_schedule_flip(tport);
+		tty_flip_buffer_push(tport);
 	}
 
 	/* Data received? */
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -308,7 +308,7 @@ int kbd_rate(struct kbd_repeat *rpt)
 static void put_queue(struct vc_data *vc, int ch)
 {
 	tty_insert_flip_char(&vc->port, ch, 0);
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void puts_queue(struct vc_data *vc, char *cp)
@@ -317,7 +317,7 @@ static void puts_queue(struct vc_data *v
 		tty_insert_flip_char(&vc->port, *cp, 0);
 		cp++;
 	}
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -562,7 +562,7 @@ static void fn_inc_console(struct vc_dat
 static void fn_send_intr(struct vc_data *vc)
 {
 	tty_insert_flip_char(&vc->port, 0, TTY_BREAK);
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1484,7 +1484,7 @@ static void respond_string(const char *p
 		tty_insert_flip_char(port, *p, 0);
 		p++;
 	}
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static void cursor_report(struct vc_data *vc, struct tty_struct *tty)


