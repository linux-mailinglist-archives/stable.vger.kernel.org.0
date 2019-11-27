Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4660A10BA88
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbfK0VED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731779AbfK0VEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4AF215E5;
        Wed, 27 Nov 2019 21:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888642;
        bh=dbwZ9WoF8rg/RelWJxEXUDmfrzz1lEIsxZkZhBEk6vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDR8bYGL+yWtvz+0VxB1vYN7kxRmR9ZgBVUdVNPdPyOj98aaZiIYzSrb0BEvWbF0r
         jwbxkhKPpa1/aNgbz5AmyW5eRB80RZbk0WXq/3uIYtdxDcSzWjVCUTL8+nvGsBpfHB
         2tYYxoFy3IaNsnUMSNZo00z87xlV8pNP+ef8bs10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Masri <amasri@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 213/306] wil6210: fix debugfs memory access alignment
Date:   Wed, 27 Nov 2019 21:31:03 +0100
Message-Id: <20191127203130.670982441@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

[ Upstream commit 84ec040d0fb25197584d28a0dedc355503cd19b9 ]

All wil6210 device memory access should be 4 bytes aligned. In io
blob wil6210 did not force alignment for read function, this caused
alignment fault on some platforms.
Fixing that by accessing all 4 lower bytes and return to host the
requested data.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index ceace95b1595c..44296c0159252 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -662,10 +662,10 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	enum { max_count = 4096 };
 	struct wil_blob_wrapper *wil_blob = file->private_data;
 	struct wil6210_priv *wil = wil_blob->wil;
-	loff_t pos = *ppos;
+	loff_t aligned_pos, pos = *ppos;
 	size_t available = wil_blob->blob.size;
 	void *buf;
-	size_t ret;
+	size_t unaligned_bytes, aligned_count, ret;
 	int rc;
 
 	if (test_bit(wil_status_suspending, wil_blob->wil->status) ||
@@ -683,7 +683,12 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	if (count > max_count)
 		count = max_count;
 
-	buf = kmalloc(count, GFP_KERNEL);
+	/* set pos to 4 bytes aligned */
+	unaligned_bytes = pos % 4;
+	aligned_pos = pos - unaligned_bytes;
+	aligned_count = count + unaligned_bytes;
+
+	buf = kmalloc(aligned_count, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -694,9 +699,9 @@ static ssize_t wil_read_file_ioblob(struct file *file, char __user *user_buf,
 	}
 
 	wil_memcpy_fromio_32(buf, (const void __iomem *)
-			     wil_blob->blob.data + pos, count);
+			     wil_blob->blob.data + aligned_pos, aligned_count);
 
-	ret = copy_to_user(user_buf, buf, count);
+	ret = copy_to_user(user_buf, buf + unaligned_bytes, count);
 
 	wil_pm_runtime_put(wil);
 
-- 
2.20.1



