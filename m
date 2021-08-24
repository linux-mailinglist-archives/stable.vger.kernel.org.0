Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A33F64A9
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhHXRGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239459AbhHXREO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE8E6187D;
        Tue, 24 Aug 2021 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824365;
        bh=YdjrPX0dC2pAWZg7bMEfpM/Ww9iM33zjIjra4OHLvZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drkjckP9UuSvk/WBWn/MZRQz4DoXV83hElo3Mc6aO2cSwdW53heCdPeQb1ggO22GP
         xFknyLkqrMhKiTX+2tEk1vRiIXEB9wddajwam5QU80x9jBpiTNppvR19becS0itmfn
         hVn9EndWrk5gMdALE0bEK+9fNUph5qsHEsc3/e0uvPfAXX0BGiIyT6ytxD1dmlnckQ
         26OBLUgupLNnLUFaKy9SbAma3UDrMqaL0A+sn4paHCfewbR5Iqjcmjsda9jZIRIsVR
         I+PhAOMNeKSfo+78PFOtgRhXVoVPH7Z5u062Jr8R0421+Allkm+MaMU6I52bDzLd9W
         gJbDE4olJ/jgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Johan Hovold <johan@kernel.org>,
        syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/98] USB: core: Avoid WARNings for 0-length descriptor requests
Date:   Tue, 24 Aug 2021 12:57:44 -0400
Message-Id: <20210824165908.709932-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 60dfe484cef45293e631b3a6e8995f1689818172 ]

The USB core has utility routines to retrieve various types of
descriptors.  These routines will now provoke a WARN if they are asked
to retrieve 0 bytes (USB "receive" requests must not have zero
length), so avert this by checking the size argument at the start.

CC: Johan Hovold <johan@kernel.org>
Reported-and-tested-by: syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210607152307.GD1768031@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/message.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 19ebb542befc..dba2baca486e 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -785,6 +785,9 @@ int usb_get_descriptor(struct usb_device *dev, unsigned char type,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	memset(buf, 0, size);	/* Make sure we parse really received data */
 
 	for (i = 0; i < 3; ++i) {
@@ -833,6 +836,9 @@ static int usb_get_string(struct usb_device *dev, unsigned short langid,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	for (i = 0; i < 3; ++i) {
 		/* retry on length 0 or stall; some devices are flakey */
 		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
-- 
2.30.2

