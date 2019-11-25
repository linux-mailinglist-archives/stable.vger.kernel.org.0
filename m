Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 180F8109395
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 19:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfKYSf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 13:35:58 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41647 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfKYSf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Nov 2019 13:35:58 -0500
Received: by mail-pg1-f194.google.com with SMTP id 207so7598151pge.8;
        Mon, 25 Nov 2019 10:35:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5wNA4KHBKZEp6N1N62CKTMhksw9S2p7XTOcetbk9WWE=;
        b=cWTRY6iNT8eJpcv5qV5pp1oNWqEIBPxjm4szDfklRuIbCpdZEpyegCb0Q3kTtl3YIs
         TRNdX1Hbgem4KRTyyYGMiBzuXN2cGUWZ+bmbsl3OlOZ1y8Z2R9zfj0YbSxp5s+ivIKoP
         nGdXeqVHKYktEow5m5Ys6a7iQiGxcOGGAcgp6uXLGgTmQkTg5tw6VduVIGLZDf6nw0br
         OfsDq4XVLT3BN2TN+n9Lmdo49uAhmBVHW75XDDDpqxESLjUX651Yg7Tsg+0AdoM6+O4S
         TSkxqpPA2Io3ZydG3F52CmPPwXItSSK8OdpZnjbPbALPbt2Dz1+t1+DyDJd33sTVhNx1
         Welg==
X-Gm-Message-State: APjAAAWHMmjQY2UL5XE1aZai50/y3dXvF9aglwCtzv53vcEGWU95rodc
        PHYHS1k+P9LAyWEczDRWq4Ote9Zg
X-Google-Smtp-Source: APXvYqzErU6dZ23s05ZiNGrtpG6AeWwc8RJzdWdziKcpVZeVa76TXRWv7WDf2HY1ETAGufIWNDQbhg==
X-Received: by 2002:a63:6c3:: with SMTP id 186mr33414159pgg.282.1574706956286;
        Mon, 25 Nov 2019 10:35:56 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id r5sm9373499pfh.179.2019.11.25.10.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Nov 2019 10:35:55 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] loop: avoid EAGAIN, if offset or block_size are
 changed
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
References: <20190518004751.18962-1-jaegeuk@kernel.org>
 <20190518005304.GA19446@jaegeuk-macbookpro.roam.corp.google.com>
 <1e1aae74-bd6b-dddb-0c88-660aac33872c@acm.org>
 <20191125175913.GC71634@jaegeuk-macbookpro.roam.corp.google.com>
Message-ID: <a4e5d6bd-3685-379a-c388-cd2871827b21@acm.org>
Date:   Mon, 25 Nov 2019 10:35:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125175913.GC71634@jaegeuk-macbookpro.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/19 9:59 AM, Jaegeuk Kim wrote:
> On 11/19, Bart Van Assche wrote:
>> On 5/17/19 5:53 PM, Jaegeuk Kim wrote:
>>> This patch tries to avoid EAGAIN due to nrpages!=0 that was originally trying
>>> to drop stale pages resulting in wrong data access.
>>>
>>> Report: https://bugs.chromium.org/p/chromium/issues/detail?id=938958#c38
>>
>> Please provide a more detailed commit description. What is wrong with the
>> current implementation and why is the new behavior considered the correct
>> behavior?
> 
> Some history would be:
> 
> Original bug fix is:
> commit 5db470e229e2 ("loop: drop caches if offset or block_size are changed"),
> which returns EAGAIN so that user land like Chrome would require enhancing their
> error handling routines.
> 
> So, this patch tries to avoid EAGAIN while addressing the original bug.
> 
>>
>> This patch moves draining code from before the following comment to after
>> that comment:
>>
>> /* I/O need to be drained during transfer transition */
>>
>> Is that comment still correct or should it perhaps be updated?
> 
> IMHO, it's still valid.

Hi Jaegeuk,

Thank you for the additional and very helpful clarification. Can you have a look at the (totally untested) patch below? I prefer that version because it prevents concurrent processing of requests and syncing/killing the bdev.

Thanks,

Bart.


Subject: [PATCH] loop: Avoid EAGAIN if offset or block_size are changed

After sync_blockdev() and kill_bdev() have been called, more requests
can be submitted to the loop device. These requests dirty additional
pages, causing loop_set_status() to return -EAGAIN. Not all user space
code that changes the offset and/or the block size handles -EAGAIN
correctly. Hence make sure that loop_set_status() does not return
-EAGAIN.

Fixes: 5db470e229e2 ("loop: drop caches if offset or block_size are changed")
Reported-by: Gwendal Grignou <gwendal@chromium.org>
Reported-by: grygorii tertychnyi <gtertych@cisco.com>
Reported-by: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/block/loop.c | 35 +++++++----------------------------
  1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 739b372a5112..48cfc8b9c247 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1264,15 +1264,15 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
  		goto out_unlock;
  	}

+	/* I/O need to be drained during transfer transition */
+	blk_mq_freeze_queue(lo->lo_queue);
+
  	if (lo->lo_offset != info->lo_offset ||
  	    lo->lo_sizelimit != info->lo_sizelimit) {
  		sync_blockdev(lo->lo_device);
  		kill_bdev(lo->lo_device);
  	}

-	/* I/O need to be drained during transfer transition */
-	blk_mq_freeze_queue(lo->lo_queue);
-
  	err = loop_release_xfer(lo);
  	if (err)
  		goto out_unfreeze;
@@ -1298,14 +1298,6 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)

  	if (lo->lo_offset != info->lo_offset ||
  	    lo->lo_sizelimit != info->lo_sizelimit) {
-		/* kill_bdev should have truncated all the pages */
-		if (lo->lo_device->bd_inode->i_mapping->nrpages) {
-			err = -EAGAIN;
-			pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
-				__func__, lo->lo_number, lo->lo_file_name,
-				lo->lo_device->bd_inode->i_mapping->nrpages);
-			goto out_unfreeze;
-		}
  		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit)) {
  			err = -EFBIG;
  			goto out_unfreeze;
@@ -1531,39 +1523,26 @@ static int loop_set_dio(struct loop_device *lo, unsigned long arg)

  static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
  {
-	int err = 0;
-
  	if (lo->lo_state != Lo_bound)
  		return -ENXIO;

  	if (arg < 512 || arg > PAGE_SIZE || !is_power_of_2(arg))
  		return -EINVAL;

+	blk_mq_freeze_queue(lo->lo_queue);
+
  	if (lo->lo_queue->limits.logical_block_size != arg) {
  		sync_blockdev(lo->lo_device);
  		kill_bdev(lo->lo_device);
  	}
-
-	blk_mq_freeze_queue(lo->lo_queue);
-
-	/* kill_bdev should have truncated all the pages */
-	if (lo->lo_queue->limits.logical_block_size != arg &&
-			lo->lo_device->bd_inode->i_mapping->nrpages) {
-		err = -EAGAIN;
-		pr_warn("%s: loop%d (%s) has still dirty pages (nrpages=%lu)\n",
-			__func__, lo->lo_number, lo->lo_file_name,
-			lo->lo_device->bd_inode->i_mapping->nrpages);
-		goto out_unfreeze;
-	}
-
  	blk_queue_logical_block_size(lo->lo_queue, arg);
  	blk_queue_physical_block_size(lo->lo_queue, arg);
  	blk_queue_io_min(lo->lo_queue, arg);
  	loop_update_dio(lo);
-out_unfreeze:
+
  	blk_mq_unfreeze_queue(lo->lo_queue);

-	return err;
+	return 0;
  }

  static int lo_simple_ioctl(struct loop_device *lo, unsigned int cmd,
