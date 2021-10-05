Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D78422863
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhJENwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235325AbhJENwT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D33B61A05;
        Tue,  5 Oct 2021 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441829;
        bh=8nqKmcc4UXu2DsC/fRJhF9gsmsXaJgVNTi6OYaXcIhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJpQhkRAM45EuxHAVVpdrArKifUe8YD8Z/PQCEoS6sH0FlqYa/Ixka6CMU1ircD42
         kBATOWcj1wYCvRRK/MN9I6ElN90gKGAs02iR9dg2E+OG5C6P+qGxD/0WCiekz06bm/
         qeVIoWD4sMPDpq25+2oc69SvRL3gnqqVKjnaoW9uMXvdzgzjq5aJdqN8hzbgwCn7NG
         whQnvOfizHSvO4JmXvAdGIlGI8bb/qE3FbmBK8b0nK5q+b2ML28dScX8W6bPhXX3Nf
         MeHa5JLFGIECtKwGCpnYjAVvcmwLlE2u4CewUbietATWGk9F/QFM6HjRQ9+QsZ+w7I
         84jeBJJv2tuJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Whitney <enwlinux@gmail.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 04/40] ext4: enforce buffer head state assertion in ext4_da_map_blocks
Date:   Tue,  5 Oct 2021 09:49:43 -0400
Message-Id: <20211005135020.214291-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Whitney <enwlinux@gmail.com>

[ Upstream commit 948ca5f30e1df0c11eb5b0f410b9ceb97fa77ad9 ]

Remove the code that re-initializes a buffer head with an invalid block
number and BH_New and BH_Delay bits when a matching delayed and
unwritten block has been found in the extent status cache. Replace it
with assertions that verify the buffer head already has this state
correctly set.  The current code masked an inline data truncation bug
that left stale entries in the extent status cache.  With this change,
generic/130 can be used to reproduce and detect that bug.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210819144927.25163-3-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5bbf9f3b8b6f..4935b368ff1f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1721,13 +1721,16 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		}
 
 		/*
-		 * Delayed extent could be allocated by fallocate.
-		 * So we need to check it.
+		 * the buffer head associated with a delayed and not unwritten
+		 * block found in the extent status cache must contain an
+		 * invalid block number and have its BH_New and BH_Delay bits
+		 * set, reflecting the state assigned when the block was
+		 * initially delayed allocated
 		 */
-		if (ext4_es_is_delayed(&es) && !ext4_es_is_unwritten(&es)) {
-			map_bh(bh, inode->i_sb, invalid_block);
-			set_buffer_new(bh);
-			set_buffer_delay(bh);
+		if (ext4_es_is_delonly(&es)) {
+			BUG_ON(bh->b_blocknr != invalid_block);
+			BUG_ON(!buffer_new(bh));
+			BUG_ON(!buffer_delay(bh));
 			return 0;
 		}
 
-- 
2.33.0

