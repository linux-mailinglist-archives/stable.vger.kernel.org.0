Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677EC1A40F2
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgDJDrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbgDJDrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:47:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6EDB20936;
        Fri, 10 Apr 2020 03:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490420;
        bh=jDt6vkUMyGZfura59hrrftwobQmgudUKhDGGO98R2Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnnGdIDtdH4Xhfu4si4FWKzZRUqPmiBSIXPZOSOyOdXi4fKxkD5LhwRLTSP+dHjGL
         4usWCNOOCLDTVGj6jGF5nLgrTfUmRCEByPcXdqAnocbBOoxE4ijoEz/zGEgH4NLQSU
         8+hDyIVWdRteI9gGW7QyiAFN05UKdgFJApGPGtVk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 20/68] null_blk: Suppress an UBSAN complaint triggered when setting 'memory_backed'
Date:   Thu,  9 Apr 2020 23:45:45 -0400
Message-Id: <20200410034634.7731-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit b9853b4d6fb403ccb1d4d82e2d39fc17fc07519c ]

Although it is not clear to me why UBSAN complains when 'memory_backed'
is set, this patch suppresses the UBSAN complaint that is triggered when
setting that configfs attribute.

UBSAN: Undefined behaviour in drivers/block/null_blk_main.c:327:1
load of value 16 is not a valid value for type '_Bool'
CPU: 2 PID: 8396 Comm: check Not tainted 5.6.0-rc1-dbg+ #14
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0xa5/0xe6
 ubsan_epilogue+0x9/0x26
 __ubsan_handle_load_invalid_value+0x6d/0x76
 nullb_device_memory_backed_store.cold+0x2c/0x38 [null_blk]
 configfs_write_file+0x1c4/0x250 [configfs]
 __vfs_write+0x4c/0x90
 vfs_write+0x145/0x2c0
 ksys_write+0xd7/0x180
 __x64_sys_write+0x47/0x50
 do_syscall_64+0x6f/0x2f0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index d5b4a92033d48..2b8b4cb447cfb 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -276,7 +276,7 @@ nullb_device_##NAME##_store(struct config_item *item, const char *page,	\
 {									\
 	int (*apply_fn)(struct nullb_device *dev, TYPE new_value) = APPLY;\
 	struct nullb_device *dev = to_nullb_device(item);		\
-	TYPE uninitialized_var(new_value);				\
+	TYPE new_value = 0;						\
 	int ret;							\
 									\
 	ret = nullb_device_##TYPE##_attr_store(&new_value, page, count);\
-- 
2.20.1

