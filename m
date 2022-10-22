Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B38608716
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiJVH4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbiJVHyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D500DD6B92;
        Sat, 22 Oct 2022 00:48:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0716B60B88;
        Sat, 22 Oct 2022 07:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB8EC433D6;
        Sat, 22 Oct 2022 07:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424490;
        bh=H2f0utUE260eE+Vd88zICS6WI0lF7gGGbPGRjwWNoew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDDd90nnDTW3/93qJyiTSm7JiLWZPdxwBW3oiSSCLyAhMmEp7SmMS5CDidBRT7EJG
         jrXIVSqnwZVAba4PNSpORIoKdhav0mZS4ZvY6HxMD7JMseHys1icBoUbHxF9xjwDrQ
         I7/PXqQF0bnqshJAX9jmXq0a78+IGhnSw40xq7z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.19 135/717] ext4: fix potential memory leak in ext4_fc_record_regions()
Date:   Sat, 22 Oct 2022 09:20:14 +0200
Message-Id: <20221022072439.424419076@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 7069d105c1f15c442b68af43f7fde784f3126739 upstream.

As krealloc may return NULL, in this case 'state->fc_regions' may not be
freed by krealloc, but 'state->fc_regions' already set NULL. Then will
lead to 'state->fc_regions' memory leak.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220921064040.3693255-3-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1687,15 +1687,17 @@ int ext4_fc_record_regions(struct super_
 	if (replay && state->fc_regions_used != state->fc_regions_valid)
 		state->fc_regions_used = state->fc_regions_valid;
 	if (state->fc_regions_used == state->fc_regions_size) {
+		struct ext4_fc_alloc_region *fc_regions;
+
 		state->fc_regions_size +=
 			EXT4_FC_REPLAY_REALLOC_INCREMENT;
-		state->fc_regions = krealloc(
-					state->fc_regions,
-					state->fc_regions_size *
-					sizeof(struct ext4_fc_alloc_region),
-					GFP_KERNEL);
-		if (!state->fc_regions)
+		fc_regions = krealloc(state->fc_regions,
+				      state->fc_regions_size *
+				      sizeof(struct ext4_fc_alloc_region),
+				      GFP_KERNEL);
+		if (!fc_regions)
 			return -ENOMEM;
+		state->fc_regions = fc_regions;
 	}
 	region = &state->fc_regions[state->fc_regions_used++];
 	region->ino = ino;


