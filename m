Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C740938AAD3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhETLRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240413AbhETLPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A626461D61;
        Thu, 20 May 2021 10:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505351;
        bh=lxGFtPBaiPfFOBd6ka0NMvca45bMyhFaOUkmSEoWGiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4yr/H0HyzVneek9+DRQeMh9bGNReL5GL6/IprQ8k1y9y+DK3XdbaYBlQL4/FM8tT
         soNihp7cJRxM0GlrtwAlzutDzueyMmIeQzfrjjden5DCBCqkipz3ODy7nmODJhvXa5
         rAxIXYDeBQF481iBVtxgctIquPhWbO9AiftzjN7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 095/190] tty: fix return value for unsupported ioctls
Date:   Thu, 20 May 2021 11:22:39 +0200
Message-Id: <20210520092105.341421997@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 1b8b20868a6d64cfe8174a21b25b74367bdf0560 ]

Drivers should return -ENOTTY ("Inappropriate I/O control operation")
when an ioctl isn't supported, while -EINVAL is used for invalid
arguments.

Fix up the TIOCMGET, TIOCMSET and TIOCGICOUNT helpers which returned
-EINVAL when a tty driver did not implement the corresponding
operations.

Note that the TIOCMGET and TIOCMSET helpers predate git and do not get a
corresponding Fixes tag below.

Fixes: d281da7ff6f7 ("tty: Make tiocgicount a handler")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407095208.31838-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c       | 8 ++++----
 include/linux/tty_driver.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index dff507cd0250..bdb25b23e8d3 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2762,14 +2762,14 @@ out:
  *	@p: pointer to result
  *
  *	Obtain the modem status bits from the tty driver if the feature
- *	is supported. Return -EINVAL if it is not available.
+ *	is supported. Return -ENOTTY if it is not available.
  *
  *	Locking: none (up to the driver)
  */
 
 static int tty_tiocmget(struct tty_struct *tty, int __user *p)
 {
-	int retval = -EINVAL;
+	int retval = -ENOTTY;
 
 	if (tty->ops->tiocmget) {
 		retval = tty->ops->tiocmget(tty);
@@ -2787,7 +2787,7 @@ static int tty_tiocmget(struct tty_struct *tty, int __user *p)
  *	@p: pointer to desired bits
  *
  *	Set the modem status bits from the tty driver if the feature
- *	is supported. Return -EINVAL if it is not available.
+ *	is supported. Return -ENOTTY if it is not available.
  *
  *	Locking: none (up to the driver)
  */
@@ -2799,7 +2799,7 @@ static int tty_tiocmset(struct tty_struct *tty, unsigned int cmd,
 	unsigned int set, clear, val;
 
 	if (tty->ops->tiocmset == NULL)
-		return -EINVAL;
+		return -ENOTTY;
 
 	retval = get_user(val, p);
 	if (retval)
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 161052477f77..6d8db1555260 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -235,7 +235,7 @@
  *
  *	Called when the device receives a TIOCGICOUNT ioctl. Passed a kernel
  *	structure to complete. This method is optional and will only be called
- *	if provided (otherwise EINVAL will be returned).
+ *	if provided (otherwise ENOTTY will be returned).
  */
 
 #include <linux/export.h>
-- 
2.30.2



