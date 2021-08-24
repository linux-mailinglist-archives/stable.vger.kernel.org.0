Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C543F661A
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239837AbhHXRU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239327AbhHXRSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB73F617E2;
        Tue, 24 Aug 2021 17:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824576;
        bh=Yq3vQjf2fbzyVa/x3UAR0CRss6sZUC5xGFZPW0KPcb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiU9ZCuCOTVIA8ITFvh+rdPsb/SohOCs1iyf7wd5wSPPQmJhD92DrFX27h6m2GIoa
         k5BXWnO2FFVgmlx1Bm+gbNBbnBb5302fimpft1gMlG5PGMIt/K0gj4ZGiTP5frZmkg
         qt3Qvv2wCDibtowniD1kKbNN+vXZGOPXXHKigry1jVudld85t+5TxnsFIDk55muShw
         MyP4TvqAMmr0U0ihtbIO0OulDhfBBDGyg0mmNMIAeVyQ/42sskYlmFH65BDhw5EqM8
         LI8s1Gfl00ZM5rajTm7n0CixIQoMtnmWQtAMPDgpJ6XbEcm3sUOtm3lkc5G20qzqvu
         aMJBZdOzn7UOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.19 04/84] i2c: dev: zero out array used for i2c reads from userspace
Date:   Tue, 24 Aug 2021 13:01:30 -0400
Message-Id: <20210824170250.710392-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 86ff25ed6cd8240d18df58930bd8848b19fce308 upstream.

If an i2c driver happens to not provide the full amount of data that a
user asks for, it is possible that some uninitialized data could be sent
to userspace.  While all in-kernel drivers look to be safe, just be sure
by initializing the buffer to zero before it is passed to the i2c driver
so that any future drivers will not have this issue.

Also properly copy the amount of data recvieved to the userspace buffer,
as pointed out by Dan Carpenter.

Reported-by: Eric Dumazet <edumazet@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index 1d10ee86299d..57aece809841 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -149,7 +149,7 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
 	if (count > 8192)
 		count = 8192;
 
-	tmp = kmalloc(count, GFP_KERNEL);
+	tmp = kzalloc(count, GFP_KERNEL);
 	if (tmp == NULL)
 		return -ENOMEM;
 
@@ -158,7 +158,8 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
 
 	ret = i2c_master_recv(client, tmp, count);
 	if (ret >= 0)
-		ret = copy_to_user(buf, tmp, count) ? -EFAULT : ret;
+		if (copy_to_user(buf, tmp, ret))
+			ret = -EFAULT;
 	kfree(tmp);
 	return ret;
 }
-- 
2.30.2

