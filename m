Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7D3505019
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiDRMVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238144AbiDRMVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:21:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C1A1AF24;
        Mon, 18 Apr 2022 05:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33A8860EF4;
        Mon, 18 Apr 2022 12:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D2CC385A7;
        Mon, 18 Apr 2022 12:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284229;
        bh=2eW/C51TwqfkdoErXQym1CHihSsTcqaYUfBGjlwTP8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgTfIbG+1ycxcdgQZWvskGHmqpjl0XsJeHqieyKXxRgNHioMQfhlJz0q8c7exc5tt
         AO4xozM/Ar6ml7Gf5h1ExW1kXtU8op9B4LaLF2qkRC/VAZJ9gWUjggKhAXLDB5iNMY
         Fm5Vc2bBYNfp2q22rjV9/WTkiZQhANS/PynbCJJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 015/219] btrfs: fix btrfs_submit_compressed_write cgroup attribution
Date:   Mon, 18 Apr 2022 14:09:44 +0200
Message-Id: <20220418121203.955676572@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Zhou <dennis@kernel.org>

commit acee08aaf6d158d03668dc82b0a0eef41100531b upstream.

This restores the logic from commit 46bcff2bfc5e ("btrfs: fix compressed
write bio blkcg attribution") which added cgroup attribution to btrfs
writeback. It also adds back the REQ_CGROUP_PUNT flag for these ios.

Fixes: 91507240482e ("btrfs: determine stripe boundary at bio allocation time in btrfs_submit_compressed_write")
CC: stable@vger.kernel.org # 5.16+
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/compression.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -534,6 +534,9 @@ blk_status_t btrfs_submit_compressed_wri
 	cb->orig_bio = NULL;
 	cb->nr_pages = nr_pages;
 
+	if (blkcg_css)
+		kthread_associate_blkcg(blkcg_css);
+
 	while (cur_disk_bytenr < disk_start + compressed_len) {
 		u64 offset = cur_disk_bytenr - disk_start;
 		unsigned int index = offset >> PAGE_SHIFT;
@@ -552,6 +555,8 @@ blk_status_t btrfs_submit_compressed_wri
 				bio = NULL;
 				goto finish_cb;
 			}
+			if (blkcg_css)
+				bio->bi_opf |= REQ_CGROUP_PUNT;
 		}
 		/*
 		 * We should never reach next_stripe_start start as we will
@@ -609,6 +614,9 @@ blk_status_t btrfs_submit_compressed_wri
 	return 0;
 
 finish_cb:
+	if (blkcg_css)
+		kthread_associate_blkcg(NULL);
+
 	if (bio) {
 		bio->bi_status = ret;
 		bio_endio(bio);


