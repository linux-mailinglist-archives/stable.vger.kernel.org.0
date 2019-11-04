Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998F0EED6E
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389983AbfKDWGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389978AbfKDWGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:06:35 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A21AB20650;
        Mon,  4 Nov 2019 22:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905195;
        bh=M5sVEkLfwvxy3JlQ9ejc5M3w1uVEQ8hslW83InsFHO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlDbbDwMHeWoyKEuCiK1M9yExZXDO1pf2N/+Q1KtYDhdk6sU3dg9XOyCPdkaowF+i
         EsRvxFQ4U6Cjw6pZ7FKVCgqk0FtBo07XjDchS/TJz3r4upNP4jZIaApZKz0rnvdNgL
         kUxIeXaGbKKfb9f7/06o3pgZwvxfU+J/aC+Jee1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austindh.kim@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 062/163] btrfs: silence maybe-uninitialized warning in clone_range
Date:   Mon,  4 Nov 2019 22:44:12 +0100
Message-Id: <20191104212144.521512803@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austindh.kim@gmail.com>

[ Upstream commit 431d39887d6273d6d84edf3c2eab09f4200e788a ]

GCC throws warning message as below:

‘clone_src_i_size’ may be used uninitialized in this function
[-Wmaybe-uninitialized]
 #define IS_ALIGNED(x, a)  (((x) & ((typeof(x))(a) - 1)) == 0)
                       ^
fs/btrfs/send.c:5088:6: note: ‘clone_src_i_size’ was declared here
 u64 clone_src_i_size;
   ^
The clone_src_i_size is only used as call-by-reference
in a call to get_inode_info().

Silence the warning by initializing clone_src_i_size to 0.

Note that the warning is a false positive and reported by older versions
of GCC (eg. 7.x) but not eg 9.x. As there have been numerous people, the
patch is applied. Setting clone_src_i_size to 0 does not otherwise make
sense and would not do any action in case the code changes in the future.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c3c0c064c25da..91c702b4cae9d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5070,7 +5070,7 @@ static int clone_range(struct send_ctx *sctx,
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	int ret;
-	u64 clone_src_i_size;
+	u64 clone_src_i_size = 0;
 
 	/*
 	 * Prevent cloning from a zero offset with a length matching the sector
-- 
2.20.1



