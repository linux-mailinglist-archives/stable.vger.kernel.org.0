Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F5D3F67F6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbhHXRix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240222AbhHXRgj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:36:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D83A619E0;
        Tue, 24 Aug 2021 17:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824867;
        bh=zXlsPMnq+NU0Y43seg9d4vsor4xa0cnDW9c461nWsvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOq2GduK2ORJ7S0sSJIOmdMlzRLOzOdFyJq7QtoLSbfH2Znh0fZqP3Qo9ljoB7c//
         pHPSeqyBDfS+BJZQCzX4Z292DErZIoQNoXeunecztTMu05FZLMZrF88ZJOnTY0sjLV
         8Jc4B0MtTXfseq677q7E/ZF6fpB9tp2p4kSXUPKiKT+uegZ1xqQefSiVZVI9im9foL
         gu9K2xvurfwFlpVtK4dLd8/ZUfZ0ziE8qVjnJUyGD5cMrelRzhoe9svoxOQ2/5p/B6
         BZ46CNo9dm+sBgGR7h0p5F8Wr8jqP8ROzfvT1eRAlyuYKaJ17yBltJ5fRv+T8lDxSK
         7v5bbQFkiurlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.4 02/31] i2c: dev: zero out array used for i2c reads from userspace
Date:   Tue, 24 Aug 2021 13:07:14 -0400
Message-Id: <20210824170743.710957-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index 7584f292e2fd..d0340b134e72 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -148,7 +148,7 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
 	if (count > 8192)
 		count = 8192;
 
-	tmp = kmalloc(count, GFP_KERNEL);
+	tmp = kzalloc(count, GFP_KERNEL);
 	if (tmp == NULL)
 		return -ENOMEM;
 
@@ -157,7 +157,8 @@ static ssize_t i2cdev_read(struct file *file, char __user *buf, size_t count,
 
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

