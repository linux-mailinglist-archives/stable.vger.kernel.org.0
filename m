Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 073B11671E0
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgBUH6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730036AbgBUH6D (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:58:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B63A820578;
        Fri, 21 Feb 2020 07:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271883;
        bh=7GTzFRjxuS1PYuCP5jZ9FakEZ80lREG4UThrnZSeHJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhRMmF4AkVtSmOuMKmvdxQyyq1gSrSwcXYcOr3ys+jXZAcEZcDfeG+whXKenGD1GW
         0JqiTidyEepDm2gFpXtnML+4fN3lRsqwfCSPK8Ts0/5aeAQjf/pkzbC51eiuqWSFjX
         3MTHxXIBNdAwvxOugfu6857TtX5l8Xg1z5tpVHB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 334/399] bcache: fix use-after-free in register_bcache()
Date:   Fri, 21 Feb 2020 08:40:59 +0100
Message-Id: <20200221072433.516792813@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -2475,10 +2475,11 @@ out_free_sb:
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



