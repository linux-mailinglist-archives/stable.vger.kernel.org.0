Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0C037402D
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhEEQdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234239AbhEEQcq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E404061413;
        Wed,  5 May 2021 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232309;
        bh=fxnDPLlPWYLf9/KzTkxHvikDC9lWN6ga0dBvtKr5d2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGqpnvvo0iTE5zlqxjE556fUrlyvMpelaI/2VyCPqh2UAZpST/fI6JKhQTeU3TKHm
         aVMF1rLpzd5wcRpbkwwYrbbIZmzBnNzvrBap5oAxegmSS/M1Dzs5AcV8hBifEEkTcu
         JJ398WztdkxDsudacgb8i2Pv1ls6AwQS3qBh+6ROTuOTutjR6OWPciL42rZB1YLCUP
         IUWAKF1l111KcuvRbuOLEkrOT/2LQod6+/ojn/z5SHdmjN+dP8u9MGL1ZnY4Ujk36Y
         eJI6oUmYiq9L4klDKRBsRYE0oOk3sC/QnCw+ZQCoZ2L6cAkkkUHWgvDbogMpEZhLUT
         ut+RMTYHvScOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        syzbot+ffb0b3ffa6cfbc7d7b3f@syzkaller.appspotmail.com,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 018/116] i2c: bail out early when RDWR parameters are wrong
Date:   Wed,  5 May 2021 12:29:46 -0400
Message-Id: <20210505163125.3460440-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 6ceb11cc4be1..6ef38a8ee95c 100644
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

