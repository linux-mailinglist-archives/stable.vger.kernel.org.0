Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E997133312
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgAGVQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:16:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbgAGVH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:07:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FADD2077B;
        Tue,  7 Jan 2020 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431245;
        bh=X4Kz08PeDi2lyAuZNarTXBb78qVLzfibOtCxFYo5TjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aFMrgk/wB/mJsSBAFY31mIWxCpUO0d0JqOT2wBARb4TYXCfxDtDD8FChMZ1EjgKFZ
         nXCw0jlMohZLeVY6jxo31Zba5mx/jVR58oy8reAHXw0jRBLVB1EjoKXWjMoTIzpbXa
         BY93LWoRLh78unsX8I/uNh/89UjXc5qAkOl6rqF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH 4.19 094/115] tty: serial: msm_serial: Fix lockup for sysrq and oops
Date:   Tue,  7 Jan 2020 21:55:04 +0100
Message-Id: <20200107205307.042257446@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/msm_serial.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1580,6 +1580,7 @@ static void __msm_console_write(struct u
 	int num_newlines = 0;
 	bool replaced = false;
 	void __iomem *tf;
+	int locked = 1;
 
 	if (is_uartdm)
 		tf = port->membase + UARTDM_TF;
@@ -1592,7 +1593,13 @@ static void __msm_console_write(struct u
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
 	if (is_uartdm)
 		msm_reset_dm_count(port, count);
 
@@ -1628,7 +1635,9 @@ static void __msm_console_write(struct u
 		iowrite32_rep(tf, buf, 1);
 		i += num_chars;
 	}
-	spin_unlock(&port->lock);
+
+	if (locked)
+		spin_unlock(&port->lock);
 }
 
 static void msm_console_write(struct console *co, const char *s,


