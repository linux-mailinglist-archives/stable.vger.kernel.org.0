Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F9F1E2CB9
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392073AbgEZTRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392218AbgEZTO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:14:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4AC220776;
        Tue, 26 May 2020 19:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520498;
        bh=O9GuyrYBQ8P7jHWBTNTtQT6lMUojNgow4wxmzXQ9/G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYUpbj/WjZOBP6MVPnjqYQq7/wZ+xqytYaK9yjIcZrdJ5kMXZR/99I6MSYjcpylOu
         FsneB+8UHySN35bpBSFHWOm/4U2P//9AU1pG+xldz7CD/CalQlgCoe3Kooivw77PwR
         xHA2tiyyuT8Pk0yCggJ7I6oDWb1JTVjE8nDLClOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <Atish.Patra@wdc.com>,
        Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.6 102/126] tty: serial: add missing spin_lock_init for SiFive serial console
Date:   Tue, 26 May 2020 20:53:59 +0200
Message-Id: <20200526183946.284470957@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagar Shrikant Kadam <sagar.kadam@sifive.com>

commit 17b4efdf4e4867079012a48ca10d965fe9d68822 upstream.

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
 drivers/tty/serial/sifive.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -840,6 +840,7 @@ console_initcall(sifive_console_init);
 
 static void __ssp_add_console_port(struct sifive_serial_port *ssp)
 {
+	spin_lock_init(&ssp->port.lock);
 	sifive_serial_console_ports[ssp->port.line] = ssp;
 }
 


