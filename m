Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5728F3F6385
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhHXQ5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233499AbhHXQ46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2141F61374;
        Tue, 24 Aug 2021 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824173;
        bh=udT0J8LbuFSyRMXl5YH7r4HlqXhQ2HNqHnm2/jMlvEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c049xdwJUsA+DqtRrGi/5VeIHQFb/goa53m8TuDTs80Wy0WtAXg2PFHoRcuk73fRK
         KUrsVzn6aqcenAdeMtS/9RTxqytBZuEdebW8kCzrx3Q02P6ji4zx210niOUQyr6tcL
         V9vCCrKk+QB2WZQkSGpVlMrv5Szou8AnkqtIPHD5/A9PmWc/bTg3o8/DUuRyLwc92w
         d14YCgrnsvh/9Ha0EOMhQR/IiDhgccWvfQ3jBVgvLzpoC4+pzLzU2cJUHAk0Xbuz+s
         NLBpUjrbxZ7BBaiLTb6GtBDZqPzUVypgJTvkIeLJHwZiiQ9fcxF2SW+ZuNvaTwXg60
         857AnF/ypiHQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        syzbot+72af3105289dcb4c055b@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 004/127] USB: core: Fix incorrect pipe calculation in do_proc_control()
Date:   Tue, 24 Aug 2021 12:54:04 -0400
Message-Id: <20210824165607.709387-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit b0863f1927323110e3d0d69f6adb6a91018a9a3c ]

When the user submits a control URB via usbfs, the user supplies the
bRequestType value and the kernel uses it to compute the pipe value.
However, do_proc_control() performs this computation incorrectly in
the case where the bRequestType direction bit is set to USB_DIR_IN and
the URB's transfer length is 0: The pipe's direction is also set to IN
but it should be OUT, which is the direction the actual transfer will
use regardless of bRequestType.

Commit 5cc59c418fde ("USB: core: WARN if pipe direction != setup
packet direction") added a check to compare the direction bit in the
pipe value to a control URB's actual direction and to WARN if they are
different.  This can be triggered by the incorrect computation
mentioned above, as found by syzbot.

This patch fixes the computation, thus avoiding the WARNing.

Reported-and-tested-by: syzbot+72af3105289dcb4c055b@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210712185436.GB326369@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/devio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 2218941d35a3..73b60f013b20 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1133,7 +1133,7 @@ static int do_proc_control(struct usb_dev_state *ps,
 		"wIndex=%04x wLength=%04x\n",
 		ctrl->bRequestType, ctrl->bRequest, ctrl->wValue,
 		ctrl->wIndex, ctrl->wLength);
-	if (ctrl->bRequestType & 0x80) {
+	if ((ctrl->bRequestType & USB_DIR_IN) && ctrl->wLength) {
 		pipe = usb_rcvctrlpipe(dev, 0);
 		snoop_urb(dev, NULL, pipe, ctrl->wLength, tmo, SUBMIT, NULL, 0);
 
-- 
2.30.2

