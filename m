Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6488DA038
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407115AbfJPWJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:50300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbfJPV5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:33 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EA3A21928;
        Wed, 16 Oct 2019 21:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263052;
        bh=lj5SyutIuB+v6o6QuSFGb7RdNjIqMBjSC10nXV1Da08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdfcH8k1Dz1ACwmdd9YGq117rl7eGwVC6eNv7swwF37vdsEGuiNXY6FnTTm1g5enc
         T0o1VfgtdIoJO6j5vdxClB5HYAoa1+CBxtWS6lDv6ZHssXki5MK1mu7QqwwlYgOZ0q
         VkfLl8HG21IXQna6oibL8BpBrU53zZSPxqg065q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 38/81] USB: legousbtower: fix open after failed reset request
Date:   Wed, 16 Oct 2019 14:50:49 -0700
Message-Id: <20191016214837.120886302@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
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
@@ -348,7 +348,6 @@ static int tower_open (struct inode *ino
 		retval = -EBUSY;
 		goto unlock_exit;
 	}
-	dev->open_count = 1;
 
 	/* reset the tower */
 	result = usb_control_msg (dev->udev,
@@ -388,13 +387,14 @@ static int tower_open (struct inode *ino
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
 


