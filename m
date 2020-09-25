Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC8627840B
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 11:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgIYJbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 05:31:23 -0400
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:48792 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbgIYJbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 05:31:22 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 08P9VFVn005012; Fri, 25 Sep 2020 18:31:15 +0900
X-Iguazu-Qid: 2wHHEK9NfrK4KFIh1u
X-Iguazu-QSIG: v=2; s=0; t=1601026275; q=2wHHEK9NfrK4KFIh1u; m=8MxwARmdmSbKFMWXz0K+HyBjKIp1c2FEiWULrABWm2A=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1113) id 08P9VEUJ006111;
        Fri, 25 Sep 2020 18:31:14 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 08P9VDdU003023;
        Fri, 25 Sep 2020 18:31:13 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 08P9VDd5026048;
        Fri, 25 Sep 2020 18:31:13 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.14, 4.19] serial: 8250: Avoid error message on reprobe
Date:   Fri, 25 Sep 2020 18:31:09 +0900
X-TSB-HOP: ON
Message-Id: <20200925093109.388661-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit e0a851fe6b9b619527bd928aa93caaddd003f70c upstream.

If the call to uart_add_one_port() in serial8250_register_8250_port()
fails, a half-initialized entry in the serial_8250ports[] array is left
behind.

A subsequent reprobe of the same serial port causes that entry to be
reused.  Because uart->port.dev is set, uart_remove_one_port() is called
for the half-initialized entry and bails out with an error message:

bcm2835-aux-uart 3f215040.serial: Removing wrong port: (null) != (ptrval)

The same happens on failure of mctrl_gpio_init() since commit
4a96895f74c9 ("tty/serial/8250: use mctrl_gpio helpers").

Fix by zeroing the uart->port.dev pointer in the probe error path.

The bug was introduced in v2.6.10 by historical commit befff6f5bf5f
("[SERIAL] Add new port registration/unregistration functions."):
https://git.kernel.org/tglx/history/c/befff6f5bf5f

The commit added an unconditional call to uart_remove_one_port() in
serial8250_register_port().  In v3.7, commit 835d844d1a28 ("8250_pnp:
do pnp probe before legacy probe") made that call conditional on
uart->port.dev which allows me to fix the issue by zeroing that pointer
in the error path.  Thus, the present commit will fix the problem as far
back as v3.7 whereas still older versions need to also cherry-pick
835d844d1a28.

Fixes: 835d844d1a28 ("8250_pnp: do pnp probe before legacy probe")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v2.6.10
Cc: stable@vger.kernel.org # v2.6.10: 835d844d1a28: 8250_pnp: do pnp probe before legacy
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/b4a072013ee1a1d13ee06b4325afb19bda57ca1b.1589285873.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[iwamatsu: Backported to 4.14, 4.19: adjust context]
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/tty/serial/8250/8250_core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index d6b790510c94..8d46bd612888 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1065,8 +1065,10 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 			serial8250_apply_quirks(uart);
 			ret = uart_add_one_port(&serial8250_reg,
 						&uart->port);
-			if (ret == 0)
-				ret = uart->port.line;
+			if (ret)
+				goto err;
+
+			ret = uart->port.line;
 		} else {
 			dev_info(uart->port.dev,
 				"skipping CIR port at 0x%lx / 0x%llx, IRQ %d\n",
@@ -1091,6 +1093,11 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 	mutex_unlock(&serial_mutex);
 
 	return ret;
+
+err:
+	uart->port.dev = NULL;
+	mutex_unlock(&serial_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(serial8250_register_8250_port);
 
-- 
2.27.0

