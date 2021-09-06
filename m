Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BA8401BC4
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242679AbhIFM7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:59:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242971AbhIFM7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C483960238;
        Mon,  6 Sep 2021 12:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933075;
        bh=PccPhp9/jPxlR4OvAeMVMDKSr0uu4kaq5JhbYerJlf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPxeXRUiaFhK+kchdaV1PhEKbxmEw0/g16jXTdHpuFG378X3kLctojvm5Rpcib6Pr
         KkDCbqv6yoS0Iu/2GxaBIVr9Ww8ClY3oQflbYNO3dEBAnXMQQh1YW74QtrppYVr/kq
         +Zp51Cd5z5K4ZF2AmsbCOtw0ZHf2Pf0J7W62xUTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Boyang Xue <bxue@redhat.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.13 02/24] ext4: fix e2fsprogs checksum failure for mounted filesystem
Date:   Mon,  6 Sep 2021 14:55:31 +0200
Message-Id: <20210906125449.193516869@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit b2bbb92f7042e8075fb036bf97043339576330c3 upstream.

Commit 81414b4dd48 ("ext4: remove redundant sb checksum
recomputation") removed checksum recalculation after updating
superblock free space / inode counters in ext4_fill_super() based on
the fact that we will recalculate the checksum on superblock
writeout.

That is correct assumption but until the writeout happens (which can
take a long time) the checksum is incorrect in the buffer cache and if
programs such as tune2fs or resize2fs is called shortly after a file
system is mounted can fail.  So return back the checksum recalculation
and add a comment explaining why.

Fixes: 81414b4dd48f ("ext4: remove redundant sb checksum recomputation")
Cc: stable@kernel.org
Reported-by: Boyang Xue <bxue@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210812124737.21981-1-jack@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5051,6 +5051,14 @@ no_journal:
 		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
 					  GFP_KERNEL);
 	}
+	/*
+	 * Update the checksum after updating free space/inode
+	 * counters.  Otherwise the superblock can have an incorrect
+	 * checksum in the buffer cache until it is written out and
+	 * e2fsprogs programs trying to open a file system immediately
+	 * after it is mounted can fail.
+	 */
+	ext4_superblock_csum_set(sb);
 	if (!err)
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 					  ext4_count_dirs(sb), GFP_KERNEL);


