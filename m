Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B004A37C296
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbhELPMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:12:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233628AbhELPJ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:09:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E14A6142F;
        Wed, 12 May 2021 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831757;
        bh=4aPshFcRRpN8h7tjRvA2mKCEe9AApPILfvDmRUBjODc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FI2AWcMl0TaoKTukRtu1f3oIyoI70KvamsK4gDX0D034q3MRo4Q77jFeGj4N5o3jF
         777XiF829yRFg63MVwEiWZIr4qAFUZE6gFJF5qvc97QuC/zpyJxyyO3AOsuiGxvJuA
         4738iqvLeLnzVklneu2SAE6v6p8pgyWVlFR9cPC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 236/244] kfifo: fix ternary sign extension bugs
Date:   Wed, 12 May 2021 16:50:07 +0200
Message-Id: <20210512144750.555619324@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 926ee00ea24320052b46745ef4b00d91c05bd03d ]

The intent with this code was to return negative error codes but instead
it returns positives.

The problem is how type promotion works with ternary operations.  These
functions return long, "ret" is an int and "copied" is a u32.  The
negative error code is first cast to u32 so it becomes a high positive and
then cast to long where it's still a positive.

We could fix this by declaring "ret" as a ssize_t but let's just get rid
of the ternaries instead.

Link: https://lkml.kernel.org/r/YIE+/cK1tBzSuQPU@mwanda
Fixes: 5bf2b19320ec ("kfifo: add example files to the kernel sample directory")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/kfifo/bytestream-example.c | 8 ++++++--
 samples/kfifo/inttype-example.c    | 8 ++++++--
 samples/kfifo/record-example.c     | 8 ++++++--
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index 9ca3e4400c98..ecae2139274f 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -122,8 +122,10 @@ static ssize_t fifo_write(struct file *file, const char __user *buf,
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -138,8 +140,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 	ret = kfifo_to_user(&test, buf, count, &copied);
 
 	mutex_unlock(&read_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static const struct file_operations fifo_fops = {
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index 6cdeb72f83f1..7b4489e7a9a5 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -115,8 +115,10 @@ static ssize_t fifo_write(struct file *file, const char __user *buf,
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -131,8 +133,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 	ret = kfifo_to_user(&test, buf, count, &copied);
 
 	mutex_unlock(&read_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static const struct file_operations fifo_fops = {
diff --git a/samples/kfifo/record-example.c b/samples/kfifo/record-example.c
index 79ae8bb04120..eafe0838997d 100644
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -129,8 +129,10 @@ static ssize_t fifo_write(struct file *file, const char __user *buf,
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -145,8 +147,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 	ret = kfifo_to_user(&test, buf, count, &copied);
 
 	mutex_unlock(&read_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static const struct file_operations fifo_fops = {
-- 
2.30.2



