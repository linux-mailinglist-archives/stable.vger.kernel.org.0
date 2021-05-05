Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FE9374521
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbhEEREA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237532AbhEERAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BD4F619D0;
        Wed,  5 May 2021 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232812;
        bh=khiZR3WpiPPiv2JrwnDHVhgiP3lU5CeCHaaScLhI3x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLME0CPHDbY5JKz85RZKjb5vrB+E46eyzEULWrVKHPCJISQp/vtfr4TUrj9zlV+Zk
         /7BxV7FaluI23thNNt39pilXoTvXbmoo523O9UcKEDHbFcxEdve8HUOSPJ9L/Ewjtj
         bp1IGeyXbqlRM5H57zO/70babY0lbiEJKmsuQnuo3fu9ckqXYZlfmEf8O16Glq8UC1
         IUYayL41nw1pAAzj/FQs+nvgONmZvE3Gf38+LshXum++imuTKuowTapCtxYKSBlTkR
         xmeBotNr6a3tQS0sNnQtvqQcvh0D4QuChe+aFWm6hSdvm2+98wIGgBgtdNUpE2bBR1
         6fMomMTw8jYMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        syzbot+ffb0b3ffa6cfbc7d7b3f@syzkaller.appspotmail.com,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/32] i2c: bail out early when RDWR parameters are wrong
Date:   Wed,  5 May 2021 12:39:37 -0400
Message-Id: <20210505164004.3463707-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index cbda91a0cb5f..1d10ee86299d 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -448,8 +448,13 @@ static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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

