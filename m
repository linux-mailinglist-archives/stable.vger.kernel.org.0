Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB53D3A939
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbfFIREn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388661AbfFIREj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:04:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9465620833;
        Sun,  9 Jun 2019 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099879;
        bh=89GpvrFgzcN4Wj9MAnyH0h18e4NiL3Ko+h4Lw6xvsNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNL0YeslhEmfNrffrxoiFbC0p+631X3DHahaTvpqPGwdFUl9JV9Hc+BqtcR4KdnDF
         H7BwnvlkeUhrSfP0vSiW+V8Xfa9p39XkmkDkIY3rvmA7qN9VWenCgTVGRaLZcUnOzu
         Si/1GpVHu9rWs6KJoluN9skseHvjW7B8AQDFbY9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.4 200/241] USB: rio500: fix memory leak in close after disconnect
Date:   Sun,  9 Jun 2019 18:42:22 +0200
Message-Id: <20190609164153.779532334@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
@@ -103,9 +103,22 @@ static int close_rio(struct inode *inode
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
 


