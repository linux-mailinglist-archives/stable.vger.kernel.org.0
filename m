Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8301D4ED772
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 12:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiCaKCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 06:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiCaKCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 06:02:01 -0400
Received: from iris.vrvis.at (iris.vrvis.at [92.60.8.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FD4338A7;
        Thu, 31 Mar 2022 03:00:12 -0700 (PDT)
Received: from [10.43.0.42]
        by iris.vrvis.at with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <valentin@vrvis.at>)
        id 1nZrb7-0006OG-6E; Thu, 31 Mar 2022 12:00:09 +0200
Message-ID: <ab7167b6-8ea5-fd4a-66ea-b8aa93f68ee2@vrvis.at>
Date:   Thu, 31 Mar 2022 12:00:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>, linux-block@vger.kernel.org
Content-Language: en-US
From:   Valentin Kleibel <valentin@vrvis.at>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <c274db07-9c7d-d857-33ad-4a762819bcdd@vrvis.at>
 <YinpIKY0HVlJ+TLR@kroah.com> <50ddedf1-5ac3-91c3-0b50-645ceb541071@vrvis.at>
 <YinufgnQtSeTA18w@kroah.com> <9dd4a25a-7deb-fcdf-0c05-d37d4c894d86@vrvis.at>
 <Yi8jO3Q+xbPx0JwF@kroah.com> <b19953f8-2097-6962-eceb-5d41f4639ce4@vrvis.at>
In-Reply-To: <b19953f8-2097-6962-eceb-5d41f4639ce4@vrvis.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
Subject: [PATCH v2 1/2] block: add blk_alloc_disk and blk_cleanup_disk APIs
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add two new APIs to allocate and free a gendisk including the
request_queue for use with BIO based drivers.  This is to avoid
boilerplate code in drivers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20210521055116.1053587-6-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit f525464a8000f092c20b00eead3eaa9d849c599e)
Fixes: 3582dd291788 (aoe: convert aoeblk to blk-mq)
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215647
Signed-off-by: Valentin Kleibel <valentin@vrvis.at>
---
  block/genhd.c         | 15 +++++++++++++++
  include/linux/genhd.h |  1 +
  2 files changed, 16 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 796baf761202..421cad085502 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1836,6 +1836,21 @@ void put_disk_and_module(struct gendisk *disk)
         }
  }
  EXPORT_SYMBOL(put_disk_and_module);
+/**
+ * blk_cleanup_disk - shutdown a gendisk allocated by blk_alloc_disk
+ * @disk: gendisk to shutdown
+ *
+ * Mark the queue hanging off @disk DYING, drain all pending requests, 
then mark
+ * the queue DEAD, destroy and put it and the gendisk structure.
+ *
+ * Context: can sleep
+ */
+void blk_cleanup_disk(struct gendisk *disk)
+{
+       blk_cleanup_queue(disk->queue);
+       put_disk(disk);
+}
+EXPORT_SYMBOL(blk_cleanup_disk);

  static void set_disk_ro_uevent(struct gendisk *gd, int ro)
  {
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 03da3f603d30..b7b180d3734a 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -369,6 +369,7 @@ extern void blk_unregister_region(dev_t devt, 
unsigned long range);
  #define alloc_disk(minors) alloc_disk_node(minors, NUMA_NO_NODE)

  int register_blkdev(unsigned int major, const char *name);
+void blk_cleanup_disk(struct gendisk *disk);
  void unregister_blkdev(unsigned int major, const char *name);

  void revalidate_disk_size(struct gendisk *disk, bool verbose);
