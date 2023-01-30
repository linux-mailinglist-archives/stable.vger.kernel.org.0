Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB53068131C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbjA3O20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237690AbjA3O2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864E436466
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:26:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C8D7B80CB4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A15C433EF;
        Mon, 30 Jan 2023 14:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088800;
        bh=UfTo3TH7ARMv7fj9ZQCPp+FXrygSu6ygwUZckk8v0M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYPe5siyd93Wjy+cSGCZQT0GC9YBessqxFczBt6ZEMkWXJMbAzTqa67z6x64EuuDA
         f/yB//heG/Af5941/eVriHzQ+ktDZUKwKBLpxXbcD/Oco4ebnvA5A9Dmxoet6TnLzx
         JXYzuvXCqdLCI3EbYKMwcyePQeiCE7lhXu+1NF3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 139/143] block: fix and cleanup bio_check_ro
Date:   Mon, 30 Jan 2023 14:53:16 +0100
Message-Id: <20230130134312.588559457@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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

commit 57e95e4670d1126c103305bcf34a9442f49f6d6a upstream.

Don't use a WARN_ON when printing a potentially user triggered
condition.  Also don't print the partno when the block device name
already includes it, and use the %pg specifier to simplify printing
the block device name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20220304180105.409765-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -700,9 +700,7 @@ static inline bool bio_check_ro(struct b
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return false;
-
-		WARN_ONCE(1,
-		       "Trying to write to read-only block-device %s (partno %d)\n",
+		pr_warn("Trying to write to read-only block-device %s (partno %d)\n",
 			bio_devname(bio, b), part->partno);
 		/* Older lvm-tools actually trigger this */
 		return false;


