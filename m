Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58BF15C5C9
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgBMPYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgBMPYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:54 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A37246A3;
        Thu, 13 Feb 2020 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607493;
        bh=tDIBEW+qhN6NjizLvnUmXcQjQff1bi95mps5Y2AQeLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwrSKWwUdG8QLkE/30FLruwDyp/quXQlGnjj3alZ8BKqwQ/IRcOPvO14LGogJXF89
         ped508jFGLe6bkNy8LAAW4y7/xTNRocyL2PELpai/qtwxJsQjyKbzW/kGMZdaqJFZH
         hJCsirSHRBSt1hGmglrJrVWIm8exBnGhzPxpMBLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 044/173] ubifs: dont trigger assertion on invalid no-key filename
Date:   Thu, 13 Feb 2020 07:19:07 -0800
Message-Id: <20200213151945.047297989@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit f0d07a98a070bb5e443df19c3aa55693cbca9341 ]

If userspace provides an invalid fscrypt no-key filename which encodes a
hash value with any of the UBIFS node type bits set (i.e. the high 3
bits), gracefully report ENOENT rather than triggering ubifs_assert().

Test case with kvm-xfstests shell:

    . fs/ubifs/config
    . ~/xfstests/common/encrypt
    dev=$(__blkdev_to_ubi_volume /dev/vdc)
    ubiupdatevol $dev -t
    mount $dev /mnt -t ubifs
    mkdir /mnt/edir
    xfs_io -c set_encpolicy /mnt/edir
    rm /mnt/edir/_,,,,,DAAAAAAAAAAAAAAAAAAAAAAAAAA

With the bug, the following assertion fails on the 'rm' command:

    [   19.066048] UBIFS error (ubi0:0 pid 379): ubifs_assert_failed: UBIFS assert failed: !(hash & ~UBIFS_S_KEY_HASH_MASK), in fs/ubifs/key.h:170

Fixes: f4f61d2cc6d8 ("ubifs: Implement encrypted filenames")
Cc: <stable@vger.kernel.org> # v4.10+
Link: https://lore.kernel.org/r/20200120223201.241390-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 4e6e32c0c08a4..358abc26dbc0b 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -253,6 +253,8 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
 	if (nm.hash) {
 		ubifs_assert(fname_len(&nm) == 0);
 		ubifs_assert(fname_name(&nm) == NULL);
+		if (nm.hash & ~UBIFS_S_KEY_HASH_MASK)
+			goto done; /* ENOENT */
 		dent_key_init_hash(c, &key, dir->i_ino, nm.hash);
 		err = ubifs_tnc_lookup_dh(c, &key, dent, nm.minor_hash);
 	} else {
-- 
2.20.1



