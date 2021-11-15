Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA577451069
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242718AbhKOSr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238481AbhKOSof (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:44:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52CE963375;
        Mon, 15 Nov 2021 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999572;
        bh=g0jZ1736I1HJDbgU1isGNZGn+DfXrg5XbfELG7oGgGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCHx0vyF+WpQHQ/w6PBIIY7u67scBhV3TpwtY2JqpuFrXeijgIjTUj593JFdkYOTE
         8/fZVndV6qWfOcDruWTmDq8H5CpUvaqk3rtvqDPZUmX76Ndo/bi6ApEMWKCSBEmL8S
         A4YC5On7h2qaqtIIf9+nFKCSP1ZYBWv6Ww9FrPI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Sidong Yang <realwakka@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 319/849] btrfs: reflink: initialize return value to 0 in btrfs_extent_same()
Date:   Mon, 15 Nov 2021 17:56:42 +0100
Message-Id: <20211115165431.034853092@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sidong Yang <realwakka@gmail.com>

[ Upstream commit 44bee215f72f13874c0e734a0712c2e3264c0108 ]

Fix a warning reported by smatch that ret could be returned without
initialized.  The dedupe operations are supposed to to return 0 for a 0
length range but the caller does not pass olen == 0. To keep this
behaviour and also fix the warning initialize ret to 0.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Sidong Yang <realwakka@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/reflink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 9b0814318e726..c71e49782e86d 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -649,7 +649,7 @@ static int btrfs_extent_same_range(struct inode *src, u64 loff, u64 len,
 static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
 			     struct inode *dst, u64 dst_loff)
 {
-	int ret;
+	int ret = 0;
 	u64 i, tail_len, chunk_count;
 	struct btrfs_root *root_dst = BTRFS_I(dst)->root;
 
-- 
2.33.0



