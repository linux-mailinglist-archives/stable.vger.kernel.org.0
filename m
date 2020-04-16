Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5471AC3FF
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441646AbgDPNwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440349AbgDPNwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6EAE2078B;
        Thu, 16 Apr 2020 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045156;
        bh=jDt6vkUMyGZfura59hrrftwobQmgudUKhDGGO98R2Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVFJceqITjpv/OnJnO8ZS6j1X5kfsslNweMVPBsIdfN5mOCU8mICaUmii8brz9sA5
         74yzfSb5oXl8f+SmoMl3IurzMFYpDvBDx7N68+/XWL8EB13baKVa0jkMcdKotPyc/v
         zfYvMarESzdwvF2LsxYo7jz3RlI03VAI9iI3fX64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 020/254] null_blk: Suppress an UBSAN complaint triggered when setting memory_backed
Date:   Thu, 16 Apr 2020 15:21:49 +0200
Message-Id: <20200416131328.342674812@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



