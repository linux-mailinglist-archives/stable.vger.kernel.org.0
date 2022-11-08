Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C9D62157E
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbiKHOMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiKHOMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92D4862FF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4533AB81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FB5C433C1;
        Tue,  8 Nov 2022 14:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916725;
        bh=w9L85S1lcdfzFHjL3MumCN30rn1zHq4pJdi4Vv5Wd00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0WItIvxM+E3KESySB6rA0FZzjjLl91s1QPLYLDqYfSFMS+MQ6Q01t8VJ2uJTNcq/
         eA5G9znnMrFRdXtGoPT/k7YB7a6sxdm9zFVBY79npKh1Q/Xjq7zFKRWiYKzsxPYzI9
         N3sfKEKiuPDjkkw1Xw2XfR1Bncwu3l1kfgGRQflo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 113/197] block: Fix possible memory leak for rq_wb on add_disk failure
Date:   Tue,  8 Nov 2022 14:39:11 +0100
Message-Id: <20221108133400.088924912@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit fa81cbafbf5764ad5053512152345fab37a1fe18 ]

kmemleak reported memory leaks in device_add_disk():

kmemleak: 3 new suspected memory leaks

unreferenced object 0xffff88800f420800 (size 512):
  comm "modprobe", pid 4275, jiffies 4295639067 (age 223.512s)
  hex dump (first 32 bytes):
    04 00 00 00 08 00 00 00 01 00 00 00 00 00 00 00  ................
    00 e1 f5 05 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d3662699>] kmalloc_trace+0x26/0x60
    [<00000000edc7aadc>] wbt_init+0x50/0x6f0
    [<0000000069601d16>] wbt_enable_default+0x157/0x1c0
    [<0000000028fc393f>] blk_register_queue+0x2a4/0x420
    [<000000007345a042>] device_add_disk+0x6fd/0xe40
    [<0000000060e6aab0>] nbd_dev_add+0x828/0xbf0 [nbd]
    ...

It is because the memory allocated in wbt_enable_default() is not
released in device_add_disk() error path.
Normally, these memory are freed in:

del_gendisk()
  rq_qos_exit()
    rqos->ops->exit(rqos);
      wbt_exit()

So rq_qos_exit() is called to free the rq_wb memory for wbt_init().
However in the error path of device_add_disk(), only
blk_unregister_queue() is called and make rq_wb memory leaked.

Add rq_qos_exit() to the error path to fix it.

Fixes: 83cbce957446 ("block: add error handling for device_add_disk / add_disk")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221029071355.35462-1-chenzhongjin@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/genhd.c b/block/genhd.c
index 988ba52fd331..044ff97381e3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -519,6 +519,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 		bdi_unregister(disk->bdi);
 out_unregister_queue:
 	blk_unregister_queue(disk);
+	rq_qos_exit(disk->queue);
 out_put_slave_dir:
 	kobject_put(disk->slave_dir);
 out_put_holder_dir:
-- 
2.35.1



