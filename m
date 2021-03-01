Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A7C32872B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbhCARUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237767AbhCARNd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:13:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052B664E62;
        Mon,  1 Mar 2021 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617063;
        bh=ZSmE0n8hRNh6FVhBjLNnzUjkbzYPYZJpaWL/yhksAHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1knv80Ag/jb6ujFrYN5vrtoat6trfs9xO78dokF8cDmfBCa/jmO6Jjs4eIoypOPT
         qQVSEH8u3lz4j6INQIlFvZJXoetZ8hCF+kWjqzKpOVQZlk/P8Nfgqc6UYHG7Jcf2Rv
         88zIdcp2AsWQnbl84fbQyoWIYGeH3EX6d+UdTEZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/247] ext4: fix potential htree index checksum corruption
Date:   Mon,  1 Mar 2021 17:13:00 +0100
Message-Id: <20210301161039.507250416@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit b5776e7524afbd4569978ff790864755c438bba7 ]

In the case where we need to do an interior node split, and
immediately afterwards, we are unable to allocate a new directory leaf
block due to ENOSPC, the directory index checksum's will not be filled
in correctly (and indeed, will not be correctly journalled).

This looks like a bug that was introduced when we added largedir
support.  The original code doesn't make any sense (and should have
been caught in code review), but it was hidden because most of the
time, the index node checksum will be set by do_split().  But if
do_split bails out due to ENOSPC, then ext4_handle_dirty_dx_node()
won't get called, and so the directory index checksum field will not
get set, leading to:

EXT4-fs error (device sdb): dx_probe:858: inode #6635543: block 4022: comm nfsd: Directory index failed checksum

Google-Bug-Id: 176345532
Fixes: e08ac99fa2a2 ("ext4: add largedir feature")
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8f7e0ad5b5ef1..0dde6385a1258 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2315,11 +2315,10 @@ again:
 						   (frame - 1)->bh);
 			if (err)
 				goto journal_error;
-			if (restart) {
-				err = ext4_handle_dirty_dx_node(handle, dir,
-							   frame->bh);
+			err = ext4_handle_dirty_dx_node(handle, dir,
+							frame->bh);
+			if (err)
 				goto journal_error;
-			}
 		} else {
 			struct dx_root *dxroot;
 			memcpy((char *) entries2, (char *) entries,
-- 
2.27.0



