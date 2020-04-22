Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084381B426A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgDVLBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbgDVKBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:01:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 310C32077D;
        Wed, 22 Apr 2020 10:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549691;
        bh=8H8u6hTqwGmn5z1Om6Z7kpMBmTSpROkiyjdq6uJkSnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+kh52VhBWLQSCNZ1mkJ0yuaELo6zxllUm66JFlGpsbBXUZLRUXacB06CdL8HtLAd
         QbFHN+X32hxIkqtqxA8KdGK4mE11qSCiX2xkeX/HnsLSWzcDmpHSmLQhdQGVC3esQl
         5ifP6hpNtz3OKEEAQmFCZANI8VXdK1mxpP0WBxpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.4 060/100] ext4: fix incorrect group count in ext4_fill_super error message
Date:   Wed, 22 Apr 2020 11:56:30 +0200
Message-Id: <20200422095033.905142426@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

commit df41460a21b06a76437af040d90ccee03888e8e5 upstream.

ext4_fill_super doublechecks the number of groups before mounting; if
that check fails, the resulting error message prints the group count
from the ext4_sb_info sbi, which hasn't been set yet. Print the freshly
computed group count instead (which at that point has just been computed
in "blocks_count").

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Fixes: 4ec1102813798 ("ext4: Add sanity checks for the superblock before mounting the filesystem")
Link: https://lore.kernel.org/r/8b957cd1513fcc4550fe675c10bcce2175c33a49.1585431964.git.josh@joshtriplett.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3791,9 +3791,9 @@ static int ext4_fill_super(struct super_
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
 	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
-		ext4_msg(sb, KERN_WARNING, "groups count too large: %u "
+		ext4_msg(sb, KERN_WARNING, "groups count too large: %llu "
 		       "(block count %llu, first data block %u, "
-		       "blocks per group %lu)", sbi->s_groups_count,
+		       "blocks per group %lu)", blocks_count,
 		       ext4_blocks_count(es),
 		       le32_to_cpu(es->s_first_data_block),
 		       EXT4_BLOCKS_PER_GROUP(sb));


