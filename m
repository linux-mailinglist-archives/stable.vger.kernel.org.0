Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA3D548B18
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384872AbiFMOl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385768AbiFMOko (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:40:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AECB0A69;
        Mon, 13 Jun 2022 04:50:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF042B80ECD;
        Mon, 13 Jun 2022 11:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B77DC34114;
        Mon, 13 Jun 2022 11:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121028;
        bh=KgLkVpm/eCq7pTrqhy/1TWHRr1bnRifLYUD1rkYJal0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xS1dLV3sbAz8O+tiJMl0Wl4Ur+eXe22Z/fKf7qvMn1ZHdzE5fO/PVh6i3yw8uM3u3
         DQghM07KY+wvNy9Nn8tLCccOQe7BgNZcoz7OzB8u/YSjr/9f3Xytlr91X4aizoxUnK
         1Ap3pIa1RFd/qEuCJ5524FjSAN9d7KBM9+KdYmFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 222/298] serial: msm_serial: disable interrupts in __msm_console_write()
Date:   Mon, 13 Jun 2022 12:11:56 +0200
Message-Id: <20220613094931.833826222@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 23c94b927776..e676ec761f18 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1599,6 +1599,7 @@ static inline struct uart_port *msm_get_port_from_line(unsigned int line)
 static void __msm_console_write(struct uart_port *port, const char *s,
 				unsigned int count, bool is_uartdm)
 {
+	unsigned long flags;
 	int i;
 	int num_newlines = 0;
 	bool replaced = false;
@@ -1616,6 +1617,8 @@ static void __msm_console_write(struct uart_port *port, const char *s,
 			num_newlines++;
 	count += num_newlines;
 
+	local_irq_save(flags);
+
 	if (port->sysrq)
 		locked = 0;
 	else if (oops_in_progress)
@@ -1661,6 +1664,8 @@ static void __msm_console_write(struct uart_port *port, const char *s,
 
 	if (locked)
 		spin_unlock(&port->lock);
+
+	local_irq_restore(flags);
 }
 
 static void msm_console_write(struct console *co, const char *s,
-- 
2.35.1



