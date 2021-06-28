Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA28A3B61D0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbhF1Oix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234388AbhF1Ogt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:36:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D4161CB4;
        Mon, 28 Jun 2021 14:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890642;
        bh=clTVkMmwrb5NQUMWg6RiOe1jwPLP/wMZCAzvehsMco4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bN44A1Ucb9gYrMUqAb/rk8GQByxHMdgszKKlPhPkEsGRnjQbbQlKNhYdeP6vBzknk
         pfncTJgZY0GyfE4CylvKOlT0KH0bNAc36kvmObyaFaxVTVqio8NK7ia/75IbJfBPl2
         e7W6cjFRLhsdoBnMgWMLyXUhLNqCYNht994lkMFX1tUYThm6YKBqw52nh6MDx6t3Pp
         Fr2WE4J+nMMDTxYvdx36pqKwx7Shq+2RPfXEWGHh6n1uxtA/B5BqoqaJBAJKSkmSxW
         oE3k7/LxVZSFV08yvcPBu4g7OxTUDUwiULjnnb/S69whOQGAo/xqwOKTvGZCzjSY5L
         88ebuy/+lCwPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com,
        Wolfram Sang <wsa@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 42/71] i2c: robotfuzz-osif: fix control-request directions
Date:   Mon, 28 Jun 2021 10:29:35 -0400
Message-Id: <20210628143004.32596-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
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
index a39f7d092797..66dfa211e736 100644
--- a/drivers/i2c/busses/i2c-robotfuzz-osif.c
+++ b/drivers/i2c/busses/i2c-robotfuzz-osif.c
@@ -83,7 +83,7 @@ static int osif_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 			}
 		}
 
-		ret = osif_usb_read(adapter, OSIFI2C_STOP, 0, 0, NULL, 0);
+		ret = osif_usb_write(adapter, OSIFI2C_STOP, 0, 0, NULL, 0);
 		if (ret) {
 			dev_err(&adapter->dev, "failure sending STOP\n");
 			return -EREMOTEIO;
@@ -153,7 +153,7 @@ static int osif_probe(struct usb_interface *interface,
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

