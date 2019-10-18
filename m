Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C863DD45E
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfJRWEq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728607AbfJRWEp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F2082245C;
        Fri, 18 Oct 2019 22:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436284;
        bh=M5sVEkLfwvxy3JlQ9ejc5M3w1uVEQ8hslW83InsFHO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QqwZ7+mVtVWGh9O/Lt/r0Hmt/0PeaWa+kkehKPS7wV1EN4z1/79fg6/8MgleNJulX
         U52SsFgl+3PJfTl5p3dVF3hFtSKsjyOmMVgINqWLBsMJTOAw4/UVSPW6ZyD4ABWq2r
         cLO3y8Qv63nMWcH+SWgrE+5bFQ4ZCuRJBBwSB9MQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Austin Kim <austindh.kim@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 60/89] btrfs: silence maybe-uninitialized warning in clone_range
Date:   Fri, 18 Oct 2019 18:02:55 -0400
Message-Id: <20191018220324.8165-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

