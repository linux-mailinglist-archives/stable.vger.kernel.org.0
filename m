Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F6140F6D6
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242291AbhIQLv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 07:51:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242141AbhIQLv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Sep 2021 07:51:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12B0561216;
        Fri, 17 Sep 2021 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631879404;
        bh=TxgPXz4WXZuDpnJVd8ABFgDYlXPBManWmJ/lxQHqzUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxsBDQGjDK+BdHU9M2Lzgxi4CBS409EpWZTxNggxPhhot+mT1l98fTCeUmXzzPWZ5
         DRH8+8Zh0MgXkwttHvQpZa70Qr6Qyl7AyzXCA5l6yrNcQVzoVYajsNS3IGoeYwnqg8
         ADVdVYJ++IlOKy/ir3QiQkcR45g19qJhoBNmiRxtzjtIPchc7X9DvN/wHM6Kp0ZmZE
         IXEBRSg/DeD9bv8gn5VRMXstPB15Dgy6JLHiBXKjfKA1nuurFWtfXzAbNNcir489yX
         mcdeFnqSa+JRf4+gxIVjmSof8MPvAQTwke4lQ50jhpsdTlIiZCVMxBM6XueDLyd8NK
         6zmdU5sGw+cLg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mRCNZ-0001RZ-W2; Fri, 17 Sep 2021 13:50:06 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     industrypack-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org, Federico Vaga <federico.vaga@cern.ch>
Subject: [PATCH 5/6] ipack: ipoctal: fix module reference leak
Date:   Fri, 17 Sep 2021 13:46:21 +0200
Message-Id: <20210917114622.5412-6-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210917114622.5412-1-johan@kernel.org>
References: <20210917114622.5412-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A reference to the carrier module was taken on every open but was only
released once when the final reference to the tty struct was dropped.

Fix this by taking the module reference and initialising the tty driver
data when installing the tty.

Fixes: 82a82340bab6 ("ipoctal: get carrier driver to avoid rmmod")
Cc: stable@vger.kernel.org      # 3.18
Cc: Federico Vaga <federico.vaga@cern.ch>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/ipack/devices/ipoctal.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 61c41f535510..c709861198e5 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -82,22 +82,34 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
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
@@ -661,6 +673,7 @@ static void ipoctal_cleanup(struct tty_struct *tty)
 
 static const struct tty_operations ipoctal_fops = {
 	.ioctl =		NULL,
+	.install =		ipoctal_install,
 	.open =			ipoctal_open,
 	.close =		ipoctal_close,
 	.write =		ipoctal_write_tty,
-- 
2.32.0

