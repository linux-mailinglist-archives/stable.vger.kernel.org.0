Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B526B3D7613
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhG0NXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236861AbhG0NUR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99F0C61AD2;
        Tue, 27 Jul 2021 13:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391985;
        bh=udT0J8LbuFSyRMXl5YH7r4HlqXhQ2HNqHnm2/jMlvEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvPK4ushF6pesV/Dbu8J2/5f6wau2pDQnxMIa7M1usMHxujLIkv9fm5hSfZM+BJTW
         AnnFQtdG6exaGRLXUAy/yEn7N+XztkngSRhi1ElEhLk9zJX3Qcp3DWrcxLFtIEYVCo
         IPjdFvIQjdpts7RB853kRZEfpxhBhjwRieT2l/6uEf9KZfwUSib+BgTN+UzHLNWEvW
         PxPqDEUWVDLHovo+p2CcdkQkJQDXZHRqLHCmy+zU0Lc4bIxc5wA2awEEfyfET+ZwS0
         gA4W8VJisyods/RLw0SnMUjWlUYg04WhvQte4fFyjJGaHR5CwS9MD92DJpkBsa0lVd
         InWchdv79blwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        syzbot+72af3105289dcb4c055b@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/17] USB: core: Fix incorrect pipe calculation in do_proc_control()
Date:   Tue, 27 Jul 2021 09:19:26 -0400
Message-Id: <20210727131938.834920-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131938.834920-1-sashal@kernel.org>
References: <20210727131938.834920-1-sashal@kernel.org>
MIME-Version: 1.0
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

