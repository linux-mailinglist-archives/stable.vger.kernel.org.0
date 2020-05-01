Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734651C13F5
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgEANeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730125AbgEANea (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:34:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB0D5216FD;
        Fri,  1 May 2020 13:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340070;
        bh=8/jvWTH7Ty71d4g0gKGv0ead6LT7K7fwbgRdZrWWT8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frDv065EG9lK2jKPUmn5cAbhAh28MaV48G5QUrXdAMZabNkbipeRG9xgDW/N6Fodi
         BMzwNiTZmWYOUXtC+EmZMbt0xoaw0ruD/Bzab4dVeEqOQW8sXuwTqWFP/5gyPGfCkq
         z+O4FbmzCKot9+ODZClsslw434cQ72Bxok+Fx4Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kazuhiro Fujita <kazuhiro.fujita.jg@renesas.com>,
        Hao Bui <hao.bui.yg@renesas.com>,
        KAZUMI HARADA <kazumi.harada.rh@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4.14 082/117] serial: sh-sci: Make sure status register SCxSR is read in correct sequence
Date:   Fri,  1 May 2020 15:21:58 +0200
Message-Id: <20200501131554.552812283@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kazuhiro Fujita <kazuhiro.fujita.jg@renesas.com>

commit 3dc4db3662366306e54ddcbda4804acb1258e4ba upstream.

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
 drivers/tty/serial/sh-sci.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -841,9 +841,16 @@ static void sci_receive_chars(struct uar
 				tty_insert_flip_char(tport, c, TTY_NORMAL);
 		} else {
 			for (i = 0; i < count; i++) {
-				char c = serial_port_in(port, SCxRDR);
+				char c;
 
-				status = serial_port_in(port, SCxSR);
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


