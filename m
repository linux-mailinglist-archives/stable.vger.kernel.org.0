Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D6A3831EC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbhEQOmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241260AbhEQOkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30CE561944;
        Mon, 17 May 2021 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261128;
        bh=7VE5b9CxV3ASOEntwtlfqPzYNsu2TDCZyjS7kRMqH48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZRQPtKH//kjbvYinzHyrzoQg66wEL1lf9BJE7t4AgHPnIw5JEor1aUsw0rdKhNXq
         Bi7ssQIogxXQ3VLpiLhn8c4W2x/8ThkyOFWJPAoPAChujWCMKWSUPkgoAVFaDGXrEX
         9eS9q5o8AuNvZLlpdu51auorHY8XFoiZgDRWhS1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ffb0b3ffa6cfbc7d7b3f@syzkaller.appspotmail.com,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/141] i2c: bail out early when RDWR parameters are wrong
Date:   Mon, 17 May 2021 16:01:03 +0200
Message-Id: <20210517140243.137496780@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 71581562ee36032d2d574a9b23ad4af6d6a64cf7 ]

The buggy parameters currently get caught later, but emit a noisy WARN.
Userspace should not be able to trigger this, so add similar checks much
earlier. Also avoids some unneeded code paths, of course. Apply kernel
coding stlye to a comment while here.

Reported-by: syzbot+ffb0b3ffa6cfbc7d7b3f@syzkaller.appspotmail.com
Tested-by: syzbot+ffb0b3ffa6cfbc7d7b3f@syzkaller.appspotmail.com
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-dev.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 94beacc41302..a3fec3df11b6 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -440,8 +440,13 @@ static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				   sizeof(rdwr_arg)))
 			return -EFAULT;
 
-		/* Put an arbitrary limit on the number of messages that can
-		 * be sent at once */
+		if (!rdwr_arg.msgs || rdwr_arg.nmsgs == 0)
+			return -EINVAL;
+
+		/*
+		 * Put an arbitrary limit on the number of messages that can
+		 * be sent at once
+		 */
 		if (rdwr_arg.nmsgs > I2C_RDWR_IOCTL_MAX_MSGS)
 			return -EINVAL;
 
-- 
2.30.2



