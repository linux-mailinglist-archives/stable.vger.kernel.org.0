Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD03603F1A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiJSJ1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiJSJ0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:26:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C2AE4C20;
        Wed, 19 Oct 2022 02:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 738BE617D7;
        Wed, 19 Oct 2022 08:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F2FC433C1;
        Wed, 19 Oct 2022 08:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169063;
        bh=C620LoJ1iYClQH8UWros1PqqPG0tOj5qGlc2syb/41g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHIuVl85tP3VWCd4c1MuBl7GmOIOtcu05okyAiC913082K+ZVwT0Zi6/385PYAD43
         lgJMqLdVaPfqIxZJ0tWpe3vFu1jbsqOCU8Pn0nEnD20k0GEyZjnXN/RB7WyLqKrx5J
         VDwNQi+eHIGMkg9jzKsH3Lt0YCx78UXZGyCH2Zjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 145/862] ext4: fix miss release buffer head in ext4_fc_write_inode
Date:   Wed, 19 Oct 2022 10:23:52 +0200
Message-Id: <20221019083256.394645446@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit ccbf8eeb39f2ff00b54726a2b20b35d788c4ecb5 upstream.

In 'ext4_fc_write_inode' function first call 'ext4_get_inode_loc' get 'iloc',
after use it miss release 'iloc.bh'.
So just release 'iloc.bh' before 'ext4_fc_write_inode' return.

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220914100859.1415196-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -874,22 +874,25 @@ static int ext4_fc_write_inode(struct in
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_INODE);
 	tl.fc_len = cpu_to_le16(inode_len + sizeof(fc_inode.fc_ino));
 
+	ret = -ECANCELED;
 	dst = ext4_fc_reserve_space(inode->i_sb,
 			sizeof(tl) + inode_len + sizeof(fc_inode.fc_ino), crc);
 	if (!dst)
-		return -ECANCELED;
+		goto err;
 
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, sizeof(tl), crc))
-		return -ECANCELED;
+		goto err;
 	dst += sizeof(tl);
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &fc_inode, sizeof(fc_inode), crc))
-		return -ECANCELED;
+		goto err;
 	dst += sizeof(fc_inode);
 	if (!ext4_fc_memcpy(inode->i_sb, dst, (u8 *)ext4_raw_inode(&iloc),
 					inode_len, crc))
-		return -ECANCELED;
-
-	return 0;
+		goto err;
+	ret = 0;
+err:
+	brelse(iloc.bh);
+	return ret;
 }
 
 /*


