Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66DA87BF5
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436595AbfHINrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406726AbfHINrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCB68218BE;
        Fri,  9 Aug 2019 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358443;
        bh=e2DIQVMMi3yR2vEVsSG5Vk16/gOOU9jsKQN4DNooXhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJF+SvxaisyqF05yMBVpcDEKNXaaolvVZBrLoILvetoqBiq9VF6XbB/swN6AL5X3A
         UWOXcX1A8RnA3oVaKXg8nKcd2z6N0RNpsJHqsV/3D4aW+CLeoPoi1prlLG10EMgUob
         mCy39thsx/cuJhAU/Ly+gXvGHF8idWEYk1K9Oa/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        xiao jin <jin.xiao@intel.com>, Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 4.9 26/32] block: blk_init_allocated_queue() set q->fq as NULL in the fail case
Date:   Fri,  9 Aug 2019 15:45:29 +0200
Message-Id: <20190809133923.771602436@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xiao jin <jin.xiao@intel.com>

commit 54648cf1ec2d7f4b6a71767799c45676a138ca24 upstream.

We find the memory use-after-free issue in __blk_drain_queue()
on the kernel 4.14. After read the latest kernel 4.18-rc6 we
think it has the same problem.

Memory is allocated for q->fq in the blk_init_allocated_queue().
If the elevator init function called with error return, it will
run into the fail case to free the q->fq.

Then the __blk_drain_queue() uses the same memory after the free
of the q->fq, it will lead to the unpredictable event.

The patch is to set q->fq as NULL in the fail case of
blk_init_allocated_queue().

Fixes: commit 7c94e1c157a2 ("block: introduce blk_flush_queue to drive flush machinery")
Cc: <stable@vger.kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: xiao jin <jin.xiao@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[groeck: backport to v4.4.y/v4.9.y (context change)]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -881,6 +881,7 @@ blk_init_allocated_queue(struct request_
 
 fail:
 	blk_free_flush_queue(q->fq);
+	q->fq = NULL;
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);


