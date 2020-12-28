Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4D32E3E59
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502189AbgL1O1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503935AbgL1O1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C5FE207B2;
        Mon, 28 Dec 2020 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165605;
        bh=XmOpnECry1YS+uxU0Q2msMB5AQI+nTVWso2eaeqKG6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Heer65OA4436+AFNa+cEy57XGQgN+36YqfWqPMG0zENZXZ7tX0hzNtffx9JxdQLPT
         m4WSVrdURN+mAkxqWfIRxoB8ZltPhaJ3oyy9mDmqQ8n/lo64nmuJEHeRibAeD1iohm
         wwYefeBBOjtI5RT7wlC/XG0CJ2afIFUOKXy+W74w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunguang Xu <brookxu@tencent.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 591/717] ext4: fix a memory leak of ext4_free_data
Date:   Mon, 28 Dec 2020 13:49:49 +0100
Message-Id: <20201228125049.226835526@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

commit cca415537244f6102cbb09b5b90db6ae2c953bdd upstream.

When freeing metadata, we will create an ext4_free_data and
insert it into the pending free list.  After the current
transaction is committed, the object will be freed.

ext4_mb_free_metadata() will check whether the area to be freed
overlaps with the pending free list. If true, return directly. At this
time, ext4_free_data is leaked.  Fortunately, the probability of this
problem is small, since it only occurs if the file system is corrupted
such that a block is claimed by more one inode and those inodes are
deleted within a single jbd2 transaction.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
Link: https://lore.kernel.org/r/1604764698-4269-8-git-send-email-brookxu@tencent.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mballoc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5126,6 +5126,7 @@ ext4_mb_free_metadata(handle_t *handle,
 				ext4_group_first_block_no(sb, group) +
 				EXT4_C2B(sbi, cluster),
 				"Block already on to-be-freed list");
+			kmem_cache_free(ext4_free_data_cachep, new_entry);
 			return 0;
 		}
 	}


