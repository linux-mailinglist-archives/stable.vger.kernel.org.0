Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB2C283A8B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgJEPfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbgJEPec (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF50420637;
        Mon,  5 Oct 2020 15:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912072;
        bh=vGrRp707IYn1y6FOaOxl27kaR5Ll2vmZOnWqiLv/2Mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmGJwGYNE5FUrhqrmjg7CufYmnPisiOFPW8N5HvB9yc1ygEKDaFgDt4Un/x5h0kZv
         X31ST2qHK3DzwC20nUZKyua+HLBXjbQbQu64Uw9yhJgvVAk/hjru2wWoYvw13FIhW7
         4gCoeZPLfaLe56YV/MvWRJ/Ne89vFjRqnpNSct74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 78/85] gpiolib: Fix line event handling in syscall compatible mode
Date:   Mon,  5 Oct 2020 17:27:14 +0200
Message-Id: <20201005142118.483717978@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5ad284ab3a01e2d6a89be2a8663ae76f4e617549 ]

The introduced line event handling ABI in the commit

  61f922db7221 ("gpio: userspace ABI for reading GPIO line events")

missed the fact that 64-bit kernel may serve for 32-bit applications.
In such case the very first check in the lineevent_read() will fail
due to alignment differences.

To workaround this introduce lineevent_get_size() helper which returns actual
size of the structure in user space.

Fixes: 61f922db7221 ("gpio: userspace ABI for reading GPIO line events")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -836,6 +836,21 @@ static __poll_t lineevent_poll(struct fi
 	return events;
 }
 
+static ssize_t lineevent_get_size(void)
+{
+#ifdef __x86_64__
+	/* i386 has no padding after 'id' */
+	if (in_ia32_syscall()) {
+		struct compat_gpioeevent_data {
+			compat_u64	timestamp;
+			u32		id;
+		};
+
+		return sizeof(struct compat_gpioeevent_data);
+	}
+#endif
+	return sizeof(struct gpioevent_data);
+}
 
 static ssize_t lineevent_read(struct file *filep,
 			      char __user *buf,
@@ -845,9 +860,20 @@ static ssize_t lineevent_read(struct fil
 	struct lineevent_state *le = filep->private_data;
 	struct gpioevent_data ge;
 	ssize_t bytes_read = 0;
+	ssize_t ge_size;
 	int ret;
 
-	if (count < sizeof(ge))
+	/*
+	 * When compatible system call is being used the struct gpioevent_data,
+	 * in case of at least ia32, has different size due to the alignment
+	 * differences. Because we have first member 64 bits followed by one of
+	 * 32 bits there is no gap between them. The only difference is the
+	 * padding at the end of the data structure. Hence, we calculate the
+	 * actual sizeof() and pass this as an argument to copy_to_user() to
+	 * drop unneeded bytes from the output.
+	 */
+	ge_size = lineevent_get_size();
+	if (count < ge_size)
 		return -EINVAL;
 
 	do {
@@ -883,10 +909,10 @@ static ssize_t lineevent_read(struct fil
 			break;
 		}
 
-		if (copy_to_user(buf + bytes_read, &ge, sizeof(ge)))
+		if (copy_to_user(buf + bytes_read, &ge, ge_size))
 			return -EFAULT;
-		bytes_read += sizeof(ge);
-	} while (count >= bytes_read + sizeof(ge));
+		bytes_read += ge_size;
+	} while (count >= bytes_read + ge_size);
 
 	return bytes_read;
 }


