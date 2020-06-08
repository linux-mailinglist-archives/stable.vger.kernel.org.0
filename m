Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC751F2D08
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgFHXPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729052AbgFHXPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D55612068D;
        Mon,  8 Jun 2020 23:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658148;
        bh=UC/hJa4X7QpfVijofanUa1kALbeXhRnw1dF4T3sBwyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDJ0ANxCBfx9sk1d3mSPj/eAFgpg/jj7QF+h0IaeL2aK3t3DYF9JTEy15q5w9tLks
         RPfVebBfMXwPzWCGH8O1zvbc3yfM0IXwEEIcenzGs2Ka9slI+xHBatVvg6Q1bH9l3m
         OQhAtwEvj4dQxZLsVYPL7zYh4xhV0QqG9sgXV7xc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 181/606] tty: serial: add missing spin_lock_init for SiFive serial console
Date:   Mon,  8 Jun 2020 19:05:06 -0400
Message-Id: <20200608231211.3363633-181-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/tty/serial/sifive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index d5f81b98e4d7..38133eba83a8 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -840,6 +840,7 @@ console_initcall(sifive_console_init);
 
 static void __ssp_add_console_port(struct sifive_serial_port *ssp)
 {
+	spin_lock_init(&ssp->port.lock);
 	sifive_serial_console_ports[ssp->port.line] = ssp;
 }
 
-- 
2.25.1

