Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C16657D71
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbiL1PnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbiL1PnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA7717072
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1E136154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7244C433D2;
        Wed, 28 Dec 2022 15:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242196;
        bh=dphZquzQEN4X40CbJqYa9ytytPF4j34DwDcptIZW7/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJ/64E1n+c/1YrziGDFWSUweeLUBwmkhi5wm3oQwa8U4lqL8ddh/E/dbxdN/2Tj/I
         DmpMxHCBclJf1C5ofpm1kc/3WssZnV5aleLhEFmePnbM/KK0GnlPF7nO/0kcCRrKrR
         mdLi2ctxyNNMe/WqA0ZOSrwMGLIUjERGscz6R1ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0340/1146] block: clear ->slave_dir when dropping the main slave_dir reference
Date:   Wed, 28 Dec 2022 15:31:19 +0100
Message-Id: <20221228144339.392666871@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d90db3b1c8676bc88b4309c5a571333de2263b8e ]

Zero out the pointer to ->slave_dir so that the holder code doesn't
incorrectly treat the object as alive when add_disk failed or after
del_gendisk was called.

Fixes: 89f871af1b26 ("dm: delay registering the gendisk")
Reported-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221115141054.1051801-2-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 0f9769db2de8..647f7d8d8831 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -530,6 +530,7 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 	rq_qos_exit(disk->queue);
 out_put_slave_dir:
 	kobject_put(disk->slave_dir);
+	disk->slave_dir = NULL;
 out_put_holder_dir:
 	kobject_put(disk->part0->bd_holder_dir);
 out_del_integrity:
@@ -629,6 +630,7 @@ void del_gendisk(struct gendisk *disk)
 
 	kobject_put(disk->part0->bd_holder_dir);
 	kobject_put(disk->slave_dir);
+	disk->slave_dir = NULL;
 
 	part_stat_set_all(disk->part0, 0);
 	disk->part0->bd_stamp = 0;
-- 
2.35.1



