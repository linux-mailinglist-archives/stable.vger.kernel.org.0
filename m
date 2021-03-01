Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA5E3288F7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbhCARre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:47:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238364AbhCARmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:42:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35BCE650CF;
        Mon,  1 Mar 2021 16:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617830;
        bh=l7UsS6s+geSISZVWy4Wdx/lWP2smWsWtS3a0K5VpQ5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYt796bQ4bxDSIk6JqdMEWg+ASGf8vPevxqVY1Lqa1tSN4QMaSZKGKVxDeCdPxanR
         vAkOpVb58MSEnq5jAUsv43x1mLnD8hxN9+3IDRV+hfYpXanTfXmSS8sQwgv1kW/pTB
         jf2/nOpWShssjyAdZyIYRcG4QrZyjd09aKsa9QFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 212/340] ext4: fix potential htree index checksum corruption
Date:   Mon,  1 Mar 2021 17:12:36 +0100
Message-Id: <20210301161058.734542176@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index f05ec9bfbf4fd..7f22487d502b5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2405,11 +2405,10 @@ again:
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



