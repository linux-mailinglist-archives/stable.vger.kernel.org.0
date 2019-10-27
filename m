Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0FBE660E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbfJ0VIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729313AbfJ0VID (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:03 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7364B2064A;
        Sun, 27 Oct 2019 21:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210483;
        bh=NmV6U+ZW2iYHDa8chiDrZg4AJ8VaQfyPNlEP5oIhy58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzL8BQiGIzGDb6HCDkyboQ9/zRVRhesRLZVryPWjaLUhBhFRKJCE1VrrnC3y6nIkZ
         bB91Grj5T52tj6LHeZ4Q6cy04p8mLQjsX99F3fmGMxtaybcHnEE1KK0hC3D/h8Maw8
         HzAbt7UOYRuKd9hrCL3c3y/lv+Spv3j23is9SP5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 030/119] USB: legousbtower: fix memleak on disconnect
Date:   Sun, 27 Oct 2019 22:00:07 +0100
Message-Id: <20191027203309.490183100@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b6c03e5f7b463efcafd1ce141bd5a8fc4e583ae2 upstream.

If disconnect() races with release() after a process has been
interrupted, release() could end up returning early and the driver would
fail to free its driver data.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191010125835.27031-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/legousbtower.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -423,10 +423,7 @@ static int tower_release (struct inode *
 		goto exit;
 	}
 
-	if (mutex_lock_interruptible(&dev->lock)) {
-	        retval = -ERESTARTSYS;
-		goto exit;
-	}
+	mutex_lock(&dev->lock);
 
 	if (dev->open_count != 1) {
 		dev_dbg(&dev->udev->dev, "%s: device not opened exactly once\n",


