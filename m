Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9447152B
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfGWJ3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:29:02 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:47655 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726930AbfGWJ3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:29:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2B45C580;
        Tue, 23 Jul 2019 05:29:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 05:29:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sdPu75
        NU/9EOxqpOjW4fsIfmmVoNCPAuPaFZf9iTDFM=; b=StuJxdVbbgthtLGAC1VkLe
        FwvFAo7qOqlQOLgKVbvA/NXqmHpsz7nv6QZW7yr/T0ht+VZg2KFqNQBdEANnZBxW
        M0CHP7nmRynRs6LtbcBfNrWcrtsOXt1XCp+OJZ80BV0CwelA3T4T6v2NDS4Mvnmn
        U4/a1HgvvmR/OoSDYUCSM4nSJKCrCGJy1c6FPylgXs/E3eYWu16S3Xv8skninKen
        /e1djUob6Q8E2LnMlZELfP/oUE7Wph7frgwS6oWgtPIBMESSAHmOen7DOS+0DQpE
        cP3Ld3luZtMVKJj2OIsx0+S63QJdEu1h4zUB0qP8/LB5ho1gLuZyWd8/il3noCIg
        ==
X-ME-Sender: <xms:XNM2XZe4S9CN8rMYtCJxf4XIweRA6dWSSefu_pH0T0vgrv2dXAvnfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:XNM2XXb5HnKw_Iq_OT_nCRkycjfkCsyCr4squVppN5xpW5lD18UF0A>
    <xmx:XNM2XYTpI0FR6zlxaK_CttkOSMr5CWAsbFYKGq1TRfXKLFKOoOTm9g>
    <xmx:XNM2XWx7f5eQ5_75o6PU7lcupKEjbueeNZbqwHXB_4ZsF1R9dSePKg>
    <xmx:XNM2XY16rdQL9tvvc73Odw6fxrD5GBG0N-eaYPi8aF9mnEqypsIDlA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 429B38005A;
        Tue, 23 Jul 2019 05:29:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bcache: destroy dc->writeback_write_wq if failed to create" failed to apply to 4.4-stable tree
To:     colyli@suse.de, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 11:28:51 +0200
Message-ID: <156387413194170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f54d801dda14942dbefa00541d10603015b7859c Mon Sep 17 00:00:00 2001
From: Coly Li <colyli@suse.de>
Date: Fri, 28 Jun 2019 19:59:44 +0800
Subject: [PATCH] bcache: destroy dc->writeback_write_wq if failed to create
 dc->writeback_thread

Commit 9baf30972b55 ("bcache: fix for gc and write-back race") added a
new work queue dc->writeback_write_wq, but forgot to destroy it in the
error condition when creating dc->writeback_thread failed.

This patch destroys dc->writeback_write_wq if kthread_create() returns
error pointer to dc->writeback_thread, then a memory leak is avoided.

Fixes: 9baf30972b55 ("bcache: fix for gc and write-back race")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 262f7ef20992..21081febcb59 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -833,6 +833,7 @@ int bch_cached_dev_writeback_start(struct cached_dev *dc)
 					      "bcache_writeback");
 	if (IS_ERR(dc->writeback_thread)) {
 		cached_dev_put(dc);
+		destroy_workqueue(dc->writeback_write_wq);
 		return PTR_ERR(dc->writeback_thread);
 	}
 	dc->writeback_running = true;

