Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C27A1B6869
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgDWXOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:14:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49782 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728435AbgDWXGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-0004hJ-DJ; Fri, 24 Apr 2020 00:06:34 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvP-00E6nm-JO; Fri, 24 Apr 2020 00:06:31 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Leo Yan" <leo.yan@linaro.org>,
        "Jeffrey Hugo" <jeffrey.l.hugo@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 24 Apr 2020 00:05:36 +0100
Message-ID: <lsq.1587683028.125073704@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 109/245] tty: serial: msm_serial: Fix lockup for
 sysrq and oops
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@linaro.org>

commit 0e4f7f920a5c6bfe5e851e989f27b35a0cc7fb7e upstream.

As the commit 677fe555cbfb ("serial: imx: Fix recursive locking bug")
has mentioned the uart driver might cause recursive locking between
normal printing and the kernel debugging facilities (e.g. sysrq and
oops).  In the commit it gave out suggestion for fixing recursive
locking issue: "The solution is to avoid locking in the sysrq case
and trylock in the oops_in_progress case."

This patch follows the suggestion (also used the exactly same code with
other serial drivers, e.g. amba-pl011.c) to fix the recursive locking
issue, this can avoid stuck caused by deadlock and print out log for
sysrq and oops.

Fixes: 04896a77a97b ("msm_serial: serial driver for MSM7K onboard serial peripheral.")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Link: https://lore.kernel.org/r/20191127141544.4277-2-leo.yan@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/msm_serial.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -857,6 +857,7 @@ static void msm_console_write(struct con
 	struct msm_port *msm_port;
 	int num_newlines = 0;
 	bool replaced = false;
+	int locked = 1;
 
 	BUG_ON(co->index < 0 || co->index >= UART_NR);
 
@@ -869,7 +870,13 @@ static void msm_console_write(struct con
 			num_newlines++;
 	count += num_newlines;
 
-	spin_lock(&port->lock);
+	if (port->sysrq)
+		locked = 0;
+	else if (oops_in_progress)
+		locked = spin_trylock(&port->lock);
+	else
+		spin_lock(&port->lock);
+
 	if (msm_port->is_uartdm)
 		reset_dm_count(port, count);
 
@@ -906,7 +913,9 @@ static void msm_console_write(struct con
 		msm_write(port, *bf, msm_port->is_uartdm ? UARTDM_TF : UART_TF);
 		i += num_chars;
 	}
-	spin_unlock(&port->lock);
+
+	if (locked)
+		spin_unlock(&port->lock);
 }
 
 static int __init msm_console_setup(struct console *co, char *options)

