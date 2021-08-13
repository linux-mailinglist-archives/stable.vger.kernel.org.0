Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD9A3EB89F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242240AbhHMPOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242153AbhHMPN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 754E5610F7;
        Fri, 13 Aug 2021 15:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867597;
        bh=Aq3qQPLK1+KYs6TmT8zf9w/xwiOpzhV+aU5ZgRtSj8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuF1tHBRuqkH1Wf6MXAV08Jzw4/0ZajqZaFwbN18Qk7CldePAptw0Ib8jvsFJ8OHh
         sscwKN/8LuFIRWRJ0e2/uLDAcwMUzAB1Q0Z5Zqcx0YsmJy4+9dbbT33z9iJ2o3vcT+
         3so5VosFrDHNj51vtsLmJfzQOl4QLJoT3ILzyhC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 17/27] btrfs: make qgroup_free_reserved_data take btrfs_inode
Date:   Fri, 13 Aug 2021 17:07:15 +0200
Message-Id: <20210813150523.927490745@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
References: <20210813150523.364549385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit df2cfd131fd33dbef1ce33be8b332b1f3d645f35 upstream

It only uses btrfs_inode so can just as easily take it as an argument.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3481,10 +3481,10 @@ cleanup:
 }
 
 /* Free ranges specified by @reserved, normally in error path */
-static int qgroup_free_reserved_data(struct inode *inode,
+static int qgroup_free_reserved_data(struct btrfs_inode *inode,
 			struct extent_changeset *reserved, u64 start, u64 len)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct extent_changeset changeset;
@@ -3520,8 +3520,8 @@ static int qgroup_free_reserved_data(str
 		 * EXTENT_QGROUP_RESERVED, we won't double free.
 		 * So not need to rush.
 		 */
-		ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree,
-				free_start, free_start + free_len - 1,
+		ret = clear_record_extent_bits(&inode->io_tree, free_start,
+				free_start + free_len - 1,
 				EXTENT_QGROUP_RESERVED, &changeset);
 		if (ret < 0)
 			goto out;
@@ -3550,7 +3550,8 @@ static int __btrfs_qgroup_release_data(s
 	/* In release case, we shouldn't have @reserved */
 	WARN_ON(!free && reserved);
 	if (free && reserved)
-		return qgroup_free_reserved_data(inode, reserved, start, len);
+		return qgroup_free_reserved_data(BTRFS_I(inode), reserved,
+						 start, len);
 	extent_changeset_init(&changeset);
 	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
 			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);


