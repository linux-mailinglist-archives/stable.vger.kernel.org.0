Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34201268BB9
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 15:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgINNGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 09:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbgINNFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:05:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBB8522248;
        Mon, 14 Sep 2020 13:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088695;
        bh=wIsC2FiMtRtuIqHfZo9twRs6zhKwC8APcRRjIUkOtXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTSjlh7DBJ2m8MaloV1GeQIbk+rlhoZ/c5TPMaIB4QGW6sCgIav9yGLZmuS3mPQVe
         WuT3PDfmiMLp39zU67qyWpv4okHjOVyZW+A4oHmXe0a3h3BpIByvJXZS7PY5VVGqNo
         m9U1kn3BNVAw7CARmGqBLWzbLrcZgEDj9LJ1E7DU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sahitya Tummala <stummala@codeaurora.org>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 17/22] f2fs: fix indefinite loop scanning for free nid
Date:   Mon, 14 Sep 2020 09:04:29 -0400
Message-Id: <20200914130434.1804478-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130434.1804478-1-sashal@kernel.org>
References: <20200914130434.1804478-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

[ Upstream commit e2cab031ba7b5003cd12185b3ef38f1a75e3dae8 ]

If the sbi->ckpt->next_free_nid is not NAT block aligned and if there
are free nids in that NAT block between the start of the block and
next_free_nid, then those free nids will not be scanned in scan_nat_page().
This results into mismatch between nm_i->available_nids and the sum of
nm_i->free_nid_count of all NAT blocks scanned. And nm_i->available_nids
will always be greater than the sum of free nids in all the blocks.
Under this condition, if we use all the currently scanned free nids,
then it will loop forever in f2fs_alloc_nid() as nm_i->available_nids
is still not zero but nm_i->free_nid_count of that partially scanned
NAT block is zero.

Fix this to align the nm_i->next_scan_nid to the first nid of the
corresponding NAT block.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index daeac4268c1ab..8a67b933ccd42 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2315,6 +2315,9 @@ static int __f2fs_build_free_nids(struct f2fs_sb_info *sbi,
 	if (unlikely(nid >= nm_i->max_nid))
 		nid = 0;
 
+	if (unlikely(nid % NAT_ENTRY_PER_BLOCK))
+		nid = NAT_BLOCK_OFFSET(nid) * NAT_ENTRY_PER_BLOCK;
+
 	/* Enough entries */
 	if (nm_i->nid_cnt[FREE_NID] >= NAT_ENTRY_PER_BLOCK)
 		return 0;
-- 
2.25.1

