Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9117611F266
	for <lists+stable@lfdr.de>; Sat, 14 Dec 2019 16:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfLNPYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Dec 2019 10:24:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfLNPYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 14 Dec 2019 10:24:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12B36214AF;
        Sat, 14 Dec 2019 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576337071;
        bh=mPEtg3qlGEo9qVh+VECPiFJeb6nNKGypnkG9/2qxp3M=;
        h=Subject:To:From:Date:From;
        b=rZYkEGQNUnYGxje96C1uiQv3+r89fWVHjD/EHTR1oqeKfPQUJae1yNlMSNsTPkEmn
         H7WrgVgbA38o/xk0aU2DCZGezPHiIWErej+VEjpSvri/a/8WisZvgeLBMya/2/hvo/
         jfWeCDMwjDI8TLjaEFPI+vAXBFjqWrYKVosWKCPk=
Subject: patch "serial: sprd: Add clearing break interrupt operation" added to tty-linus
To:     yonghan.ye@unisoc.com, baolin.wang7@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 14 Dec 2019 16:24:21 +0100
Message-ID: <157633706190104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: sprd: Add clearing break interrupt operation

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From abeb2e9414d7e3a0d8417bc3b13d7172513ea8a0 Mon Sep 17 00:00:00 2001
From: Yonghan Ye <yonghan.ye@unisoc.com>
Date: Wed, 4 Dec 2019 20:00:07 +0800
Subject: serial: sprd: Add clearing break interrupt operation

A break interrupt will be generated if the RX line was pulled low, which
means some abnomal behaviors occurred of the UART. In this case, we still
need to clear this break interrupt status, otherwise it will cause irq
storm to crash the whole system.

Fixes: b7396a38fb28 ("tty/serial: Add Spreadtrum sc9836-uart driver support")
Signed-off-by: Yonghan Ye <yonghan.ye@unisoc.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Baolin Wang <baolin.wang7@gmail.com>
Link: https://lore.kernel.org/r/925e51b73099c90158e080b8f5bed9b3b38c4548.1575460601.git.baolin.wang7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sprd_serial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 31df23502562..f60a59d9bf27 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -679,6 +679,9 @@ static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
 	if (ims & SPRD_IMSR_TIMEOUT)
 		serial_out(port, SPRD_ICLR, SPRD_ICLR_TIMEOUT);
 
+	if (ims & SPRD_IMSR_BREAK_DETECT)
+		serial_out(port, SPRD_ICLR, SPRD_IMSR_BREAK_DETECT);
+
 	if (ims & (SPRD_IMSR_RX_FIFO_FULL | SPRD_IMSR_BREAK_DETECT |
 		   SPRD_IMSR_TIMEOUT))
 		sprd_rx(port);
-- 
2.24.1


