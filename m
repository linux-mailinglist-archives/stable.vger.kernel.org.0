Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB60615F015
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388640AbgBNP6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:58:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388631AbgBNP6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:58:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D1B224681;
        Fri, 14 Feb 2020 15:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695915;
        bh=nQGqDCqcJVkPhRBpzWZBxNC+kUUZhXKsUQZq4VoG+pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsAk9P+3COdKcmVGtLPYzusMBYoxRdVMc2B5AGpc1klYUsMMTe7uLfvxlkbTBP9FW
         v6M+znDHKSHfLSjwwf3QImvzEvXSjkSnRXch5B5tlg+zK8HPPgbO/ixazkolKVHAuU
         VjZMocJ+Ge8UaUDUf9Gnaj6qOC+j0F0vY+jAQRuk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 454/542] bcache: fix use-after-free in register_bcache()
Date:   Fri, 14 Feb 2020 10:47:26 -0500
Message-Id: <20200214154854.6746-454-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
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
index bd2ae1d78fe15..05cb94664efee 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2475,10 +2475,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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

