Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AC0540EE9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352477AbiFGS6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353407AbiFGSx7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:53:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F5514ACB5;
        Tue,  7 Jun 2022 11:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 956E66171C;
        Tue,  7 Jun 2022 18:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E4BC36AFF;
        Tue,  7 Jun 2022 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654625029;
        bh=vdHmBAw1oESu3mBgdYJHfUNiSBmK3oQCUHtDEM6Fx5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8ueaBSdT9bbfvyBl6w0cUKikOjz8aomfpOUfWBZT5I4a4uHzb56K73H/AMseEeUS
         Y+Y4O8seQA0PemojvQcyR1PhABPRTdZwgH20ZhAZXgH1Fa5ED6S6skDfjgMYNcBebQ
         PtuV2hd4U9TALkI79Wa6T/6HYmUjxUfcOyPvjmbd4aSDe18pGrhMs9R9HCy+Wq4U9o
         sq1lapWPPDIKlIcukwCALJR+ukV685yqlK4nflNC9S3nPm+82P7JwZ+2mmPG5Ppqc4
         ULaKoO1leaLmSbuabDScO/DaecgLo0Zr9Lc7l8V01jIAqB02ZEhdolZ/AVdE0BDXTW
         6o9ypRCiaFb1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Ogness <john.ogness@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        bjorn.andersson@linaro.org, jirislaby@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 14/19] serial: msm_serial: disable interrupts in __msm_console_write()
Date:   Tue,  7 Jun 2022 14:03:09 -0400
Message-Id: <20220607180317.482354-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180317.482354-1-sashal@kernel.org>
References: <20220607180317.482354-1-sashal@kernel.org>
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit aabdbb1b7a5819e18c403334a31fb0cc2c06ad41 ]

__msm_console_write() assumes that interrupts are disabled, but
with threaded console printers it is possible that the write()
callback of the console is called with interrupts enabled.

Explicitly disable interrupts using local_irq_save() to preserve
the assumed context.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20220506213324.470461-1-john.ogness@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/msm_serial.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index c284e61ed4fc..33d035f9fded 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1578,6 +1578,7 @@ static inline struct uart_port *msm_get_port_from_line(unsigned int line)
 static void __msm_console_write(struct uart_port *port, const char *s,
 				unsigned int count, bool is_uartdm)
 {
+	unsigned long flags;
 	int i;
 	int num_newlines = 0;
 	bool replaced = false;
@@ -1595,6 +1596,8 @@ static void __msm_console_write(struct uart_port *port, const char *s,
 			num_newlines++;
 	count += num_newlines;
 
+	local_irq_save(flags);
+
 	if (port->sysrq)
 		locked = 0;
 	else if (oops_in_progress)
@@ -1640,6 +1643,8 @@ static void __msm_console_write(struct uart_port *port, const char *s,
 
 	if (locked)
 		spin_unlock(&port->lock);
+
+	local_irq_restore(flags);
 }
 
 static void msm_console_write(struct console *co, const char *s,
-- 
2.35.1

