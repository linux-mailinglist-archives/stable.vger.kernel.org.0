Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84699201134
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391750AbgFSPiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391221AbgFSP3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:29:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9228021919;
        Fri, 19 Jun 2020 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580574;
        bh=fXYDe08gPePyr0SMZbdEYjIPKP0EsT4PCGDTcTXuRIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=svPOvsMv5S+1fE14hvdn/Ceka+cxVftmDlCM70regEUWsOkVFH1CSi2ab6h1zUPw5
         z5WaIQ3jg+sLvoU050lzg/yClaP1wCtn9UDsOJxT6mCMt1SnWdaa+LXWZEDadou/Pd
         hf3im5tvqg5M05ZQcb/18N4SFggIB6bfNSHtQwHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.7 301/376] serial: 8250: Avoid error message on reprobe
Date:   Fri, 19 Jun 2020 16:33:39 +0200
Message-Id: <20200619141724.588043068@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

---
 drivers/tty/serial/8250/8250_core.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1040,7 +1040,7 @@ int serial8250_register_8250_port(struct
 			gpios = mctrl_gpio_init(&uart->port, 0);
 			if (IS_ERR(gpios)) {
 				ret = PTR_ERR(gpios);
-				goto out_unlock;
+				goto err;
 			} else {
 				uart->gpios = gpios;
 			}
@@ -1089,8 +1089,10 @@ int serial8250_register_8250_port(struct
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
@@ -1112,10 +1114,14 @@ int serial8250_register_8250_port(struct
 		}
 	}
 
-out_unlock:
 	mutex_unlock(&serial_mutex);
 
 	return ret;
+
+err:
+	uart->port.dev = NULL;
+	mutex_unlock(&serial_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(serial8250_register_8250_port);
 


