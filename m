Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B2515EBAB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391412AbgBNQKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391409AbgBNQKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ECB924697;
        Fri, 14 Feb 2020 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696607;
        bh=NOc4DC9vNXQC8GD7WUYY8GdbGnW8gByx+18TxkurOPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpdC7br9DNN1lHquGGHYjZEp96SszzrUTE7+oRwMPMR2v/l5f1ClR3qC5nT2Z7oCE
         eCJu6Azmklq1DJcOHUkKCUTggIxSkoUUiwj4TQ74w+0jSq4OoWsauKe0A7rjGY6l9D
         r8sRzf4HxdNnvHHHtL38Gcc+s70TFVeMdQYUTbkk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 391/459] bcache: fix use-after-free in register_bcache()
Date:   Fri, 14 Feb 2020 11:00:41 -0500
Message-Id: <20200214160149.11681-391-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit ae3cd299919af6eb670d5af0bc9d7ba14086bd8e ]

The patch "bcache: rework error unwinding in register_bcache" introduces
a use-after-free regression in register_bcache(). Here are current code,
	2510 out_free_path:
	2511         kfree(path);
	2512 out_module_put:
	2513         module_put(THIS_MODULE);
	2514 out:
	2515         pr_info("error %s: %s", path, err);
	2516         return ret;
If some error happens and the above code path is executed, at line 2511
path is released, but referenced at line 2515. Then KASAN reports a use-
after-free error message.

This patch changes line 2515 in the following way to fix the problem,
	2515         pr_info("error %s: %s", path?path:"", err);

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 86f7e09d31516..485ebc2b2144c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2472,10 +2472,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	kfree(sb);
 out_free_path:
 	kfree(path);
+	path = NULL;
 out_module_put:
 	module_put(THIS_MODULE);
 out:
-	pr_info("error %s: %s", path, err);
+	pr_info("error %s: %s", path?path:"", err);
 	return ret;
 }
 
-- 
2.20.1

