Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A93594999
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbiHOXWk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345768AbiHOXVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:21:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C675D7D790;
        Mon, 15 Aug 2022 13:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79153B80EAD;
        Mon, 15 Aug 2022 20:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17B1C433C1;
        Mon, 15 Aug 2022 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593868;
        bh=RhcSSngBtNJqlypII+iNFiSmycad2c4LfRwUEb29heI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OngrY+iYwanTr5cQLbCGZNvXM1+zZWU0nandkupwb8Lxf6nGcF7/SNx4nBwU75967
         nMoTd8CmXaLewa8DtGdnAcs/3x7o61Ohe9hAZE9D//ax1ZRNLuR5bQ4CbvXTCefwXX
         Wym1r4ilTx6/x0O3rDkEX2Ldr0tlK+ywSvZvGihY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1018/1095] block: add bdev_max_segments() helper
Date:   Mon, 15 Aug 2022 20:06:57 +0200
Message-Id: <20220815180511.200844214@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 65ea1b66482f415d51cd46515b02477257330339 ]

Add bdev_max_segments() like other queue parameters.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 34f2b88dfd6e..7927480b9cf7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1196,6 +1196,11 @@ bdev_max_zone_append_sectors(struct block_device *bdev)
 	return queue_max_zone_append_sectors(bdev_get_queue(bdev));
 }
 
+static inline unsigned int bdev_max_segments(struct block_device *bdev)
+{
+	return queue_max_segments(bdev_get_queue(bdev));
+}
+
 static inline unsigned queue_logical_block_size(const struct request_queue *q)
 {
 	int retval = 512;
-- 
2.35.1



