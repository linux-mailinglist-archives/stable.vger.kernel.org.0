Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD22B37C487
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbhELPbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235352AbhELP1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:27:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A46F61413;
        Wed, 12 May 2021 15:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832356;
        bh=KjvSXbKE+Tcv28Igw/d10BjMYwCk97QP+GhpsOSAybQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdpD0BmdaaZp+LYjDzKpYeaVvMecuEzbZsv/dZTvXzYbRHe029LLCVHiHmqMheHS7
         4Zlou6gv8Jo8hTyHew2Hv6lUoT0H+CyFWXY2GCFjz1Boj3vBOC5cSusnqnf/5FJzCV
         9X5B/9IHdsldFk01qlAtjniXMDaHpYGoy39Ql65Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/530] tty: fix return value for unsupported ioctls
Date:   Wed, 12 May 2021 16:45:56 +0200
Message-Id: <20210512144827.920309110@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 146bd6711562..bc5314092aa4 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2492,14 +2492,14 @@ out:
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
@@ -2517,7 +2517,7 @@ static int tty_tiocmget(struct tty_struct *tty, int __user *p)
  *	@p: pointer to desired bits
  *
  *	Set the modem status bits from the tty driver if the feature
- *	is supported. Return -EINVAL if it is not available.
+ *	is supported. Return -ENOTTY if it is not available.
  *
  *	Locking: none (up to the driver)
  */
@@ -2529,7 +2529,7 @@ static int tty_tiocmset(struct tty_struct *tty, unsigned int cmd,
 	unsigned int set, clear, val;
 
 	if (tty->ops->tiocmset == NULL)
-		return -EINVAL;
+		return -ENOTTY;
 
 	retval = get_user(val, p);
 	if (retval)
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 358446247ccd..7186d77f431e 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -236,7 +236,7 @@
  *
  *	Called when the device receives a TIOCGICOUNT ioctl. Passed a kernel
  *	structure to complete. This method is optional and will only be called
- *	if provided (otherwise EINVAL will be returned).
+ *	if provided (otherwise ENOTTY will be returned).
  */
 
 #include <linux/export.h>
-- 
2.30.2



