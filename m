Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F74039167
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbfFGP7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730334AbfFGPlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:41:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41D46212F5;
        Fri,  7 Jun 2019 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922094;
        bh=xFULexyD9/K5lBAkx3sJQH53ybfnXEHI3FhWIIrHfFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qy1zL8lQ9L7y85llGR65LzRwVFv/wL94eHUnOQ4aC9g6Npb7rmmx38jOrf6z2Fx8N
         oJ4VGT6BNBCzsuxiouV8tANYJPfvsB7jrVGflVuVkZgnys1Dn3EfIXu4WvMZgfu2bT
         kIqW7buDaZX/IQPTB5gLoJm1qLEx74KhzkmsP6Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 33/69] USB: rio500: fix memory leak in close after disconnect
Date:   Fri,  7 Jun 2019 17:39:14 +0200
Message-Id: <20190607153852.479966741@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit e0feb73428b69322dd5caae90b0207de369b5575 upstream.

If a disconnected device is closed, rio_close() must free
the buffers.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/rio500.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -99,9 +99,22 @@ static int close_rio(struct inode *inode
 {
 	struct rio_usb_data *rio = &rio_instance;
 
-	rio->isopen = 0;
+	/* against disconnect() */
+	mutex_lock(&rio500_mutex);
+	mutex_lock(&(rio->lock));
 
-	dev_info(&rio->rio_dev->dev, "Rio closed.\n");
+	rio->isopen = 0;
+	if (!rio->present) {
+		/* cleanup has been delayed */
+		kfree(rio->ibuf);
+		kfree(rio->obuf);
+		rio->ibuf = NULL;
+		rio->obuf = NULL;
+	} else {
+		dev_info(&rio->rio_dev->dev, "Rio closed.\n");
+	}
+	mutex_unlock(&(rio->lock));
+	mutex_unlock(&rio500_mutex);
 	return 0;
 }
 


