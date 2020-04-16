Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAC51ACC99
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636629AbgDPQCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 12:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895255AbgDPN0R (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:26:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 142E121D7F;
        Thu, 16 Apr 2020 13:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043576;
        bh=NxJmxBFM/dLNxv4o9zmDD2dXHVxsxW8x7R2phYHfe1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fV8ukBByT0gZxeK4gIaLXCsXprcGFsv3BwPOXQ5PdhscsCIjmxLLXjT6GoDUFHpiN
         CtElQK4KKyH2+aMLfvcBHErgKa3tne+lbxsJR70nKmplkuDRFrLZE/t334yZRgUECB
         MLj78Fd/UkIAc+3JApzyoUGZ6bKxOk0bCOcO6MsM=
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
Subject: [PATCH 4.19 014/146] null_blk: Handle null_add_dev() failures properly
Date:   Thu, 16 Apr 2020 15:22:35 +0200
Message-Id: <20200416131244.463107215@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 9b03b713082a31a5b90e0a893c72aa620e255c26 ]

If null_add_dev() fails then null_del_dev() is called with a NULL argument.
Make null_del_dev() handle this scenario correctly. This patch fixes the
following KASAN complaint:

null-ptr-deref in null_del_dev+0x28/0x280 [null_blk]
Read of size 8 at addr 0000000000000000 by task find/1062

Call Trace:
 dump_stack+0xa5/0xe6
 __kasan_report.cold+0x65/0x99
 kasan_report+0x16/0x20
 __asan_load8+0x58/0x90
 null_del_dev+0x28/0x280 [null_blk]
 nullb_group_drop_item+0x7e/0xa0 [null_blk]
 client_drop_item+0x53/0x80 [configfs]
 configfs_rmdir+0x395/0x4e0 [configfs]
 vfs_rmdir+0xb6/0x220
 do_rmdir+0x238/0x2c0
 __x64_sys_unlinkat+0x75/0x90
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
 drivers/block/null_blk_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 002072429290e..78355a0e61db6 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1480,7 +1480,12 @@ static void cleanup_queues(struct nullb *nullb)
 
 static void null_del_dev(struct nullb *nullb)
 {
-	struct nullb_device *dev = nullb->dev;
+	struct nullb_device *dev;
+
+	if (!nullb)
+		return;
+
+	dev = nullb->dev;
 
 	ida_simple_remove(&nullb_indexes, nullb->index);
 
-- 
2.20.1



