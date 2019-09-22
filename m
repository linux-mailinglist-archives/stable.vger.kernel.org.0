Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53645BAA17
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfIVTWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394414AbfIVSxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:53:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A92921A4A;
        Sun, 22 Sep 2019 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178428;
        bh=/F0eqdyJKABuAv6cUV90z+rRaHqrSXh+R+pUYfvNIeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdOMukVO9CrfnKD2VIWdaoAh1+XmjEOamug5OWfHfTPp7HLS41ohCwLUdsC9ndFLJ
         sCS4FQ0KL6OiGzgn/OPcO+gwW/18w/C1MhbJMcS8H78wsukZ1E6OxrntVh1dyjXxvq
         0urTLmWMgMaZ9CjHC5p5PDfY48HK8gn1MKPkbwTM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miles Chen <miles.chen@mediatek.com>,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 164/185] sched/psi: Correct overly pessimistic size calculation
Date:   Sun, 22 Sep 2019 14:49:02 -0400
Message-Id: <20190922184924.32534-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>

[ Upstream commit 4adcdcea717cb2d8436bef00dd689aa5bc76f11b ]

When passing a equal or more then 32 bytes long string to psi_write(),
psi_write() copies 31 bytes to its buf and overwrites buf[30]
with '\0'. Which makes the input string 1 byte shorter than
it should be.

Fix it by copying sizeof(buf) bytes when nbytes >= sizeof(buf).

This does not cause problems in normal use case like:
"some 500000 10000000" or "full 500000 10000000" because they
are less than 32 bytes in length.

	/* assuming nbytes == 35 */
	char buf[32];

	buf_size = min(nbytes, (sizeof(buf) - 1)); /* buf_size = 31 */
	if (copy_from_user(buf, user_buf, buf_size))
		return -EFAULT;

	buf[buf_size - 1] = '\0'; /* buf[30] = '\0' */

Before:

 %cd /proc/pressure/
 %echo "123456789|123456789|123456789|1234" > memory
 [   22.473497] nbytes=35,buf_size=31
 [   22.473775] 123456789|123456789|123456789| (print 30 chars)
 %sh: write error: Invalid argument

 %echo "123456789|123456789|123456789|1" > memory
 [   64.916162] nbytes=32,buf_size=31
 [   64.916331] 123456789|123456789|123456789| (print 30 chars)
 %sh: write error: Invalid argument

After:

 %cd /proc/pressure/
 %echo "123456789|123456789|123456789|1234" > memory
 [  254.837863] nbytes=35,buf_size=32
 [  254.838541] 123456789|123456789|123456789|1 (print 31 chars)
 %sh: write error: Invalid argument

 %echo "123456789|123456789|123456789|1" > memory
 [ 9965.714935] nbytes=32,buf_size=32
 [ 9965.715096] 123456789|123456789|123456789|1 (print 31 chars)
 %sh: write error: Invalid argument

Also remove the superfluous parentheses.

Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Cc: <linux-mediatek@lists.infradead.org>
Cc: <wsd_upstream@mediatek.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190912103452.13281-1-miles.chen@mediatek.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 6e52b67b420e7..517e3719027e6 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1198,7 +1198,7 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	if (static_branch_likely(&psi_disabled))
 		return -EOPNOTSUPP;
 
-	buf_size = min(nbytes, (sizeof(buf) - 1));
+	buf_size = min(nbytes, sizeof(buf));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
-- 
2.20.1

