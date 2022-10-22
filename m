Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794856086FB
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiJVHzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbiJVHyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:54:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5583566F19;
        Sat, 22 Oct 2022 00:47:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EBF360B85;
        Sat, 22 Oct 2022 07:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B362CC433D6;
        Sat, 22 Oct 2022 07:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424493;
        bh=pEMmLSxLkhJ7Q0G0EGdPJvux2Lqx48XdeRTTspi2RpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUndkd4HcluQiG4mSMRcso4B3oAWkjuENJN1FUkp6dQH+kD6tRqUCCL/LXXDjyE8Y
         +cvySZfbHibLNKpZXTqMc97Nz6nTf5YfKUzjwaZIZCqcS0CoMbOODU0mbW5RSvkpYz
         aLyr9txU8gfXlsaO+baCd9Kz+hgo0sfFsxUZqo3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.19 136/717] ext4: update state->fc_regions_size after successful memory allocation
Date:   Sat, 22 Oct 2022 09:20:15 +0200
Message-Id: <20221022072439.601141995@linuxfoundation.org>
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

commit 27cd49780381c6ccbf248798e5e8fd076200ffba upstream.

To avoid to 'state->fc_regions_size' mismatch with 'state->fc_regions'
when fail to reallocate 'fc_reqions',only update 'state->fc_regions_size'
after 'state->fc_regions' is allocated successfully.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220921064040.3693255-4-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1689,14 +1689,15 @@ int ext4_fc_record_regions(struct super_
 	if (state->fc_regions_used == state->fc_regions_size) {
 		struct ext4_fc_alloc_region *fc_regions;
 
-		state->fc_regions_size +=
-			EXT4_FC_REPLAY_REALLOC_INCREMENT;
 		fc_regions = krealloc(state->fc_regions,
-				      state->fc_regions_size *
-				      sizeof(struct ext4_fc_alloc_region),
+				      sizeof(struct ext4_fc_alloc_region) *
+				      (state->fc_regions_size +
+				       EXT4_FC_REPLAY_REALLOC_INCREMENT),
 				      GFP_KERNEL);
 		if (!fc_regions)
 			return -ENOMEM;
+		state->fc_regions_size +=
+			EXT4_FC_REPLAY_REALLOC_INCREMENT;
 		state->fc_regions = fc_regions;
 	}
 	region = &state->fc_regions[state->fc_regions_used++];


