Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2DD5A4807
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiH2LEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiH2LEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:04:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BCE57279;
        Mon, 29 Aug 2022 04:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17C8561199;
        Mon, 29 Aug 2022 11:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD88C433D6;
        Mon, 29 Aug 2022 11:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661770961;
        bh=LoKVaDTiO+atdZPGh+vYxZbWC5VLTB8BJHlzDunbAh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfQlmaMrVa6mLa9NcEjwmGSdd+EgbXbxm4g3s9ASG9L0HBNVr0BUT2PMSDJRwq57j
         en/MwGy5oPkgRP9dnrUsEkEWxRR6XQP73JkunYxuR2n7yUW6z8O8hHNgLyG9iRpXt1
         iyccKcV3wNXloUYJE6brTGtCIy+eQ78saySo4hXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 010/136] block: add bdev_max_segments() helper
Date:   Mon, 29 Aug 2022 12:57:57 +0200
Message-Id: <20220829105805.071271109@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

commit 65ea1b66482f415d51cd46515b02477257330339 upstream

Add bdev_max_segments() like other queue parameters.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blkdev.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1393,6 +1393,11 @@ bdev_max_zone_append_sectors(struct bloc
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


