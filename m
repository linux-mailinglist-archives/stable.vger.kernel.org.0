Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D49608621
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiJVHpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiJVHoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:44:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D41DD886;
        Sat, 22 Oct 2022 00:42:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22CEEB82E07;
        Sat, 22 Oct 2022 07:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F789C433D7;
        Sat, 22 Oct 2022 07:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424487;
        bh=A/EfSodavLN3vkOq7yofx8nSRK5ew/SrXZ7YRPbEBvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSUy7VI6H0yeaa9ULhvNIvWPP6gman5pvBaKiOZwXVor+hQ6LCiO4f/65M6BT9Sk8
         EE48Ds1Y5yp+9kw2KiNvhHFpOw+W6WlvSwm2619mCJt2cOA1Rw3bY7W+1tjIqyPw3e
         5XEeyQl8/RP1sOFwFmx0lM6cArJ4SB0YJ7lmWGws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.19 134/717] ext4: fix potential memory leak in ext4_fc_record_modified_inode()
Date:   Sat, 22 Oct 2022 09:20:13 +0200
Message-Id: <20221022072439.237269256@linuxfoundation.org>
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

commit 9305721a309fa1bd7c194e0d4a2335bf3b29dca4 upstream.

As krealloc may return NULL, in this case 'state->fc_modified_inodes'
may not be freed by krealloc, but 'state->fc_modified_inodes' already
set NULL. Then will lead to 'state->fc_modified_inodes' memory leak.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220921064040.3693255-2-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1494,13 +1494,15 @@ static int ext4_fc_record_modified_inode
 		if (state->fc_modified_inodes[i] == ino)
 			return 0;
 	if (state->fc_modified_inodes_used == state->fc_modified_inodes_size) {
-		state->fc_modified_inodes = krealloc(
-				state->fc_modified_inodes,
+		int *fc_modified_inodes;
+
+		fc_modified_inodes = krealloc(state->fc_modified_inodes,
 				sizeof(int) * (state->fc_modified_inodes_size +
 				EXT4_FC_REPLAY_REALLOC_INCREMENT),
 				GFP_KERNEL);
-		if (!state->fc_modified_inodes)
+		if (!fc_modified_inodes)
 			return -ENOMEM;
+		state->fc_modified_inodes = fc_modified_inodes;
 		state->fc_modified_inodes_size +=
 			EXT4_FC_REPLAY_REALLOC_INCREMENT;
 	}


