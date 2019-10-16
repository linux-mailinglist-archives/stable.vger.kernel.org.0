Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F44DA089
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407337AbfJPWMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406609AbfJPV4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:16 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF56020872;
        Wed, 16 Oct 2019 21:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262976;
        bh=y6a9mo5QzwhJY0NnURx/fNH5O+FwHsdatWhcreRE3z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrRltczsQj62I/KujQaPlNYq+KYEnHn1x2oQ8OIgxikrYUOTW8SIJs7MFZtH5sA2K
         CrOeeP30o9p1+FIY02Qb5uC9MAwDddIzuGbRRYmpNYby67M1t5nOu/yoxW+dh8oC2o
         M+M6MmXq/QRPZFU0ptFTkfDx8hFmTy4Uic1qdOMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 37/65] USB: legousbtower: fix open after failed reset request
Date:   Wed, 16 Oct 2019 14:50:51 -0700
Message-Id: <20191016214828.512980269@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 0b074f6986751361ff442bc1127c1648567aa8d6 upstream.

The driver would return with a nonzero open count in case the reset
control request failed. This would prevent any further attempts to open
the char dev until the device was disconnected.

Fix this by incrementing the open count only on successful open.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190919083039.30898-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/legousbtower.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -352,7 +352,6 @@ static int tower_open (struct inode *ino
 		retval = -EBUSY;
 		goto unlock_exit;
 	}
-	dev->open_count = 1;
 
 	/* reset the tower */
 	result = usb_control_msg (dev->udev,
@@ -392,13 +391,14 @@ static int tower_open (struct inode *ino
 		dev_err(&dev->udev->dev,
 			"Couldn't submit interrupt_in_urb %d\n", retval);
 		dev->interrupt_in_running = 0;
-		dev->open_count = 0;
 		goto unlock_exit;
 	}
 
 	/* save device in the file's private structure */
 	file->private_data = dev;
 
+	dev->open_count = 1;
+
 unlock_exit:
 	mutex_unlock(&dev->lock);
 


