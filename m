Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C4042103B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbhJDNl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238338AbhJDNkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 485F663240;
        Mon,  4 Oct 2021 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353499;
        bh=az/puUVO3OQupAISPb3tFCwtI7VlAK23Sruq7XLmSIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYxsHM4ompIj8RHCz0WA2WONkRqQR8Ykfwq+WRfwMaKDyQkpUyztBZ5L5ZTOrdu1Y
         HeoIu2Ej2hszjiGWWLvGqUU1rXACeOw+XF7L6tNIUWJGFFomW51D2zqe0kSahaSNR9
         UisPHJIfq4nrPUH9VIMW+Oq8Ck9ws37jPO/3AR3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Federico Vaga <federico.vaga@cern.ch>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 152/172] ipack: ipoctal: fix module reference leak
Date:   Mon,  4 Oct 2021 14:53:22 +0200
Message-Id: <20211004125049.878965582@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit bb8a4fcb2136508224c596a7e665bdba1d7c3c27 upstream.

A reference to the carrier module was taken on every open but was only
released once when the final reference to the tty struct was dropped.

Fix this by taking the module reference and initialising the tty driver
data when installing the tty.

Fixes: 82a82340bab6 ("ipoctal: get carrier driver to avoid rmmod")
Cc: stable@vger.kernel.org      # 3.18
Cc: Federico Vaga <federico.vaga@cern.ch>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210917114622.5412-6-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ipack/devices/ipoctal.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -82,22 +82,34 @@ static int ipoctal_port_activate(struct
 	return 0;
 }
 
-static int ipoctal_open(struct tty_struct *tty, struct file *file)
+static int ipoctal_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct ipoctal_channel *channel = dev_get_drvdata(tty->dev);
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
-	int err;
-
-	tty->driver_data = channel;
+	int res;
 
 	if (!ipack_get_carrier(ipoctal->dev))
 		return -EBUSY;
 
-	err = tty_port_open(&channel->tty_port, tty, file);
-	if (err)
-		ipack_put_carrier(ipoctal->dev);
+	res = tty_standard_install(driver, tty);
+	if (res)
+		goto err_put_carrier;
+
+	tty->driver_data = channel;
+
+	return 0;
+
+err_put_carrier:
+	ipack_put_carrier(ipoctal->dev);
+
+	return res;
+}
+
+static int ipoctal_open(struct tty_struct *tty, struct file *file)
+{
+	struct ipoctal_channel *channel = tty->driver_data;
 
-	return err;
+	return tty_port_open(&channel->tty_port, tty, file);
 }
 
 static void ipoctal_reset_stats(struct ipoctal_stats *stats)
@@ -662,6 +674,7 @@ static void ipoctal_cleanup(struct tty_s
 
 static const struct tty_operations ipoctal_fops = {
 	.ioctl =		NULL,
+	.install =		ipoctal_install,
 	.open =			ipoctal_open,
 	.close =		ipoctal_close,
 	.write =		ipoctal_write_tty,


