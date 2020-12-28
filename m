Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097CA2E688E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgL1NBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:01:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729633AbgL1NBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:01:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFA8722573;
        Mon, 28 Dec 2020 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160424;
        bh=2qAZyJ0KhRZMRyr9LxKdCJ+yR8vg/BJqnkPg1iliz4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4vOIC83mfm5wUN9qarhQBZFlTXdAeF5ItM9L/nEYQFlyu8VjX5WtxDAmFKam+WYn
         EWOpqMelClI25pQYwpgO6oUlEAcfYX5voZVAOfKXwMQLk5P2Qj/IBNb89qC+LLGxf4
         RMG2fChxWemkmIUsmm4/O9BJGNYC8FGdqjiPsCMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 4.9 046/175] serial_core: Check for port state when tty is in error state
Date:   Mon, 28 Dec 2020 13:48:19 +0100
Message-Id: <20201228124855.485989423@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

commit 2f70e49ed860020f5abae4f7015018ebc10e1f0e upstream.

At the moment opening a serial device node (such as /dev/ttyS3)
succeeds even if there is no actual serial device behind it.
Reading/writing/ioctls fail as expected because the uart port is not
initialized (the type is PORT_UNKNOWN) and the TTY_IO_ERROR error state
bit is set fot the tty.

However setting line discipline does not have these checks
8250_port.c (8250 is the default choice made by univ8250_console_init()).
As the result of PORT_UNKNOWN, uart_port::iobase is NULL which
a platform translates onto some address accessing which produces a crash
like below.

This adds tty_port_initialized() to uart_set_ldisc() to prevent the crash.

Found by syzkaller.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Link: https://lore.kernel.org/r/20201203055834.45838-1-aik@ozlabs.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1415,6 +1415,10 @@ static void uart_set_ldisc(struct tty_st
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *uport;
+	struct tty_port *port = &state->port;
+
+	if (!tty_port_initialized(port))
+		return;
 
 	mutex_lock(&state->port.mutex);
 	uport = uart_port_check(state);


