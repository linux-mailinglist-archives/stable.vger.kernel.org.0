Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D9A329086
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbhCAUJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:09:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:33552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237836AbhCAUAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A53064E86;
        Mon,  1 Mar 2021 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621401;
        bh=H6av+iQTzNSikQ4gkRLO4bMdJSP1Dxb8H6HK4Oshcnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BywSGyRWNxHlddTLaEeVUu+5BbHi0Pveh90xm7Y2LxYik0OmLtweD0Lb831GLm+0A
         F/wTxKeKnTIplllR7scjPpPVf+L/TNu6u2oxfN4yVbRT27uiXMBeX11LrTwsoDuO8W
         NgPDd+MzFHH4b45kNJrrj6Wmk3h75zo3beo6J4NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 503/775] ext4: fix potential htree index checksum corruption
Date:   Mon,  1 Mar 2021 17:11:11 +0100
Message-Id: <20210301161226.371819385@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index cf652ba3e74d2..df0368d578b16 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2401,11 +2401,10 @@ again:
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



