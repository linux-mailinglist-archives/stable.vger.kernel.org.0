Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9273B62E1
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbhF1OuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236286AbhF1OrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C26AD61C84;
        Mon, 28 Jun 2021 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890881;
        bh=3TTLbv0rosgLveSCwbYuiD36uJen/xBHAidbRr2fisQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/pTR8Uu9nyAO4waRIe1OYBe/vxa9hhbuHn5s0jR97e2y0XdPAcqiN7WtXXKdFzWd
         MhkGlY9/ZNznF3fWxIC6BcFsxCwUCOhkUGbYbF8wjCFzTj2G7fpgcvECPjLzXypgLE
         ONLLktG31Q4hqlvams/XLW+JTiYZq8tmCEgSOwRQpQCxnuHGOhygg4z5C/31Hrw3eu
         DaOVANDFbuD2hJeT6KSCiboMNef0tLTX9od07RKSUJ8BvhTTTKjn7f7aS88mHCGAHg
         8PBA7bgU0EeVkd3LDZ5yr1tmR80En1oTViApEfEzdrDdSrMofqEuCxlHZrAlbTz7ZO
         tQgxhovkseegA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com,
        Wolfram Sang <wsa@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 108/109] i2c: robotfuzz-osif: fix control-request directions
Date:   Mon, 28 Jun 2021 10:33:04 -0400
Message-Id: <20210628143305.32978-109-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 4ca070ef0dd885616ef294d269a9bf8e3b258e1a upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Control transfers without a data stage are treated as OUT requests by
the USB stack and should be using usb_sndctrlpipe(). Failing to do so
will now trigger a warning.

Fix the OSIFI2C_SET_BIT_RATE and OSIFI2C_STOP requests which erroneously
used the osif_usb_read() helper and set the IN direction bit.

Reported-by: syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com
Fixes: 83e53a8f120f ("i2c: Add bus driver for for OSIF USB i2c device.")
Cc: stable@vger.kernel.org      # 3.14
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-robotfuzz-osif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-robotfuzz-osif.c b/drivers/i2c/busses/i2c-robotfuzz-osif.c
index d848cf515234..3fe21397a4f6 100644
--- a/drivers/i2c/busses/i2c-robotfuzz-osif.c
+++ b/drivers/i2c/busses/i2c-robotfuzz-osif.c
@@ -86,7 +86,7 @@ static int osif_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 			}
 		}
 
-		ret = osif_usb_read(adapter, OSIFI2C_STOP, 0, 0, NULL, 0);
+		ret = osif_usb_write(adapter, OSIFI2C_STOP, 0, 0, NULL, 0);
 		if (ret) {
 			dev_err(&adapter->dev, "failure sending STOP\n");
 			return -EREMOTEIO;
@@ -156,7 +156,7 @@ static int osif_probe(struct usb_interface *interface,
 	 * Set bus frequency. The frequency is:
 	 * 120,000,000 / ( 16 + 2 * div * 4^prescale).
 	 * Using dev = 52, prescale = 0 give 100KHz */
-	ret = osif_usb_read(&priv->adapter, OSIFI2C_SET_BIT_RATE, 52, 0,
+	ret = osif_usb_write(&priv->adapter, OSIFI2C_SET_BIT_RATE, 52, 0,
 			    NULL, 0);
 	if (ret) {
 		dev_err(&interface->dev, "failure sending bit rate");
-- 
2.30.2

