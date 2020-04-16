Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F431AC576
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391426AbgDPOTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:19:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503234AbgDPOTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:19:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDE7920656;
        Thu, 16 Apr 2020 14:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587046779;
        bh=yDj1Ni7Xh+p76ZRfSpEELrlcBHy7dQcq97fdGI6M7R0=;
        h=Subject:To:From:Date:From;
        b=mmm/pt8RzkLG5ZGEFx+PUnBaarZXa3ohibjlu1ZUIIMg0TpHtGgarf4HkDNM/tPf5
         v6V7TpdJPpE+dwNl1eJHi/fJn0Auli0Z28r1vwJkkk6Kf3qATnnhwSybDmZgfbUwrE
         W8kyTkxdQBMdQZNi/HZX8OZWXm6oNDOluaYzrhp8=
Subject: patch "serial: sh-sci: Make sure status register SCxSR is read in correct" added to tty-linus
To:     kazuhiro.fujita.jg@renesas.com, geert+renesas@glider.be,
        gregkh@linuxfoundation.org, hao.bui.yg@renesas.com,
        kazumi.harada.rh@renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 16:19:29 +0200
Message-ID: <158704676914862@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: sh-sci: Make sure status register SCxSR is read in correct

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3dc4db3662366306e54ddcbda4804acb1258e4ba Mon Sep 17 00:00:00 2001
From: Kazuhiro Fujita <kazuhiro.fujita.jg@renesas.com>
Date: Fri, 27 Mar 2020 18:17:28 +0000
Subject: serial: sh-sci: Make sure status register SCxSR is read in correct
 sequence

For SCIF and HSCIF interfaces the SCxSR register holds the status of
data that is to be read next from SCxRDR register, But where as for
SCIFA and SCIFB interfaces SCxSR register holds status of data that is
previously read from SCxRDR register.

This patch makes sure the status register is read depending on the port
types so that errors are caught accordingly.

Cc: <stable@vger.kernel.org>
Signed-off-by: Kazuhiro Fujita <kazuhiro.fujita.jg@renesas.com>
Signed-off-by: Hao Bui <hao.bui.yg@renesas.com>
Signed-off-by: KAZUMI HARADA <kazumi.harada.rh@renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/1585333048-31828-1-git-send-email-kazuhiro.fujita.jg@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sh-sci.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index c073aa7001c4..e1179e74a2b8 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -870,9 +870,16 @@ static void sci_receive_chars(struct uart_port *port)
 				tty_insert_flip_char(tport, c, TTY_NORMAL);
 		} else {
 			for (i = 0; i < count; i++) {
-				char c = serial_port_in(port, SCxRDR);
-
-				status = serial_port_in(port, SCxSR);
+				char c;
+
+				if (port->type == PORT_SCIF ||
+				    port->type == PORT_HSCIF) {
+					status = serial_port_in(port, SCxSR);
+					c = serial_port_in(port, SCxRDR);
+				} else {
+					c = serial_port_in(port, SCxRDR);
+					status = serial_port_in(port, SCxSR);
+				}
 				if (uart_handle_sysrq_char(port, c)) {
 					count--; i--;
 					continue;
-- 
2.26.1


