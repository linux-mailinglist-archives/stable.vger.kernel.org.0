Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4C11A5AB9
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgDKXFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbgDKXFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:05:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E03EA21D7E;
        Sat, 11 Apr 2020 23:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646344;
        bh=DdOrStogyBn3qrKrdJtlOEpR6sizzEzYXH79mucax5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6oETVtUjsF3xFmdDMElHyJo+1toUzhMQw78TOIIJGJGjnq25Vob9Gz7o4jShWvu5
         71pnu5dwhLEuC7X66k8bDXfzoYKJUxJk9XZv0X4l/cHdz057uK58WuG4FhMc1D+qea
         xVM2PI4TwAyKyI1gaZqQiPg3wrUVrqhKqn2FWIk0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 093/149] xfs: fix an undefined behaviour in _da3_path_shift
Date:   Sat, 11 Apr 2020 19:02:50 -0400
Message-Id: <20200411230347.22371-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 4982bff1ace1196843f55536fcd4cc119738fe39 ]

In xfs_da3_path_shift() "blk" can be assigned to state->path.blk[-1] if
state->path.active is 1 (which is a valid state) when it tries to add an
entry to a single dir leaf block and then to shift forward to see if
there's a sibling block that would be a better place to put the new
entry. This causes a UBSAN warning given negative array indices are
undefined behavior in C. In practice the warning is entirely harmless
given that "blk" is never dereferenced in this case, but it is still
better to fix up the warning and slightly improve the code.

 UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_da_btree.c:1989:14
 index -1 is out of range for type 'xfs_da_state_blk_t [5]'
 Call trace:
  dump_backtrace+0x0/0x2c8
  show_stack+0x20/0x2c
  dump_stack+0xe8/0x150
  __ubsan_handle_out_of_bounds+0xe4/0xfc
  xfs_da3_path_shift+0x860/0x86c [xfs]
  xfs_da3_node_lookup_int+0x7c8/0x934 [xfs]
  xfs_dir2_node_addname+0x2c8/0xcd0 [xfs]
  xfs_dir_createname+0x348/0x38c [xfs]
  xfs_create+0x6b0/0x8b4 [xfs]
  xfs_generic_create+0x12c/0x1f8 [xfs]
  xfs_vn_mknod+0x3c/0x4c [xfs]
  xfs_vn_create+0x34/0x44 [xfs]
  do_last+0xd4c/0x10c8
  path_openat+0xbc/0x2f4
  do_filp_open+0x74/0xf4
  do_sys_openat2+0x98/0x180
  __arm64_sys_openat+0xf8/0x170
  do_el0_svc+0x170/0x240
  el0_sync_handler+0x150/0x250
  el0_sync+0x164/0x180

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 875e04f82541f..e864c3d47f60a 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1986,7 +1986,8 @@ xfs_da3_path_shift(
 	ASSERT(path != NULL);
 	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
 	level = (path->active-1) - 1;	/* skip bottom layer in path */
-	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
+	for (; level >= 0; level--) {
+		blk = &path->blk[level];
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
 					   blk->bp->b_addr);
 
-- 
2.20.1

