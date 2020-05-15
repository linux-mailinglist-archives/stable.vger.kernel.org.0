Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89081D4E30
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 14:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgEOMzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 08:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgEOMzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 08:55:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95DF52074D;
        Fri, 15 May 2020 12:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589547316;
        bh=3nGwvqaj9JcrPGf5Dycp5cp1+h+oo0Xbpgp0Ec5D6/Y=;
        h=Subject:To:From:Date:From;
        b=taxt32OGlmWaf4B80tHHKwzyfhxluKcBVTWE3W5CE+4TMksZde8JTYsblUrbCxqFE
         fEp+JpZR17t20t52KTcN0RZWTKewJNlu9QE+mgrbaLsF9FGZjmIgiNTEOHwfeYFrBq
         o7x/yf99AZKyJN6p0iheKyOivP3+Gc2tT8qknqoA=
Subject: patch "tty: serial: add missing spin_lock_init for SiFive serial console" added to tty-linus
To:     sagar.kadam@sifive.com, Atish.Patra@wdc.com,
        gregkh@linuxfoundation.org, palmerdabbelt@google.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 May 2020 14:55:13 +0200
Message-ID: <1589547313226207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: add missing spin_lock_init for SiFive serial console

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 17b4efdf4e4867079012a48ca10d965fe9d68822 Mon Sep 17 00:00:00 2001
From: Sagar Shrikant Kadam <sagar.kadam@sifive.com>
Date: Sat, 9 May 2020 03:24:12 -0700
Subject: tty: serial: add missing spin_lock_init for SiFive serial console

An uninitialised spin lock for sifive serial console raises a bad
magic spin_lock error as reported and discussed here [1].
Initialising the spin lock resolves the issue.

The fix is tested on HiFive Unleashed A00 board with Linux 5.7-rc4
and OpenSBI v0.7

[1] https://lore.kernel.org/linux-riscv/b9fe49483a903f404e7acc15a6efbef756db28ae.camel@wdc.com

Fixes: 45c054d0815b ("tty: serial: add driver for the SiFive UART")
Reported-by: Atish Patra <Atish.Patra@wdc.com>
Signed-off-by: Sagar Shrikant Kadam <sagar.kadam@sifive.com>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1589019852-21505-2-git-send-email-sagar.kadam@sifive.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sifive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index 13eadcb8aec4..0b5110dad051 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -883,6 +883,7 @@ console_initcall(sifive_console_init);
 
 static void __ssp_add_console_port(struct sifive_serial_port *ssp)
 {
+	spin_lock_init(&ssp->port.lock);
 	sifive_serial_console_ports[ssp->port.line] = ssp;
 }
 
-- 
2.26.2


