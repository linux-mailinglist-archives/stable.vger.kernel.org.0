Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5E338AB29
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbhETLVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240779AbhETLTW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:19:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64D9C61D65;
        Thu, 20 May 2021 10:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505432;
        bh=/ZW8JwvHwnl77jWCkthAo3Vaac0GolRsZMMhyixU/f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQx9Qe/QQkIW3cZ34XZiwQ+mSd7rFyVJ1DELwy3JjG9l7bbKeVrta2L2gw/SAuOTW
         eIp2Mmtc4K7u1lb3wXq6a1R1qAbdrG5vr7sLFQxTwNO35MBzK4D0/oPjcVhHP7wZOE
         SeVH69w/HBQQKurgFhOPMU1DYTe75L8iKIbrPAx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 132/190] kfifo: fix ternary sign extension bugs
Date:   Thu, 20 May 2021 11:23:16 +0200
Message-Id: <20210520092106.560858243@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 2fca916d9edf..a7f5ee8b6edc 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -124,8 +124,10 @@ static ssize_t fifo_write(struct file *file, const char __user *buf,
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -140,8 +142,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 	ret = kfifo_to_user(&test, buf, count, &copied);
 
 	mutex_unlock(&read_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static const struct file_operations fifo_fops = {
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index 8dc3c2e7105a..a326a37e9163 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -117,8 +117,10 @@ static ssize_t fifo_write(struct file *file, const char __user *buf,
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -133,8 +135,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
 	ret = kfifo_to_user(&test, buf, count, &copied);
 
 	mutex_unlock(&read_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static const struct file_operations fifo_fops = {
diff --git a/samples/kfifo/record-example.c b/samples/kfifo/record-example.c
index 2d7529eeb294..deb87a2e4e6b 100644
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -131,8 +131,10 @@ static ssize_t fifo_write(struct file *file, const char __user *buf,
 	ret = kfifo_from_user(&test, buf, count, &copied);
 
 	mutex_unlock(&write_lock);
+	if (ret)
+		return ret;
 
-	return ret ? ret : copied;
+	return copied;
 }
 
 static ssize_t fifo_read(struct file *file, char __user *buf,
@@ -147,8 +149,10 @@ static ssize_t fifo_read(struct file *file, char __user *buf,
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



