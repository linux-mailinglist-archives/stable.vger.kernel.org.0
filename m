Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6704063BA
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233188AbhIJAsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234889AbhIJAZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:25:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6F5760FC0;
        Fri, 10 Sep 2021 00:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233436;
        bh=B/gfCXziB9pEf3nb2sZ8lOxHyY1nlyIoomA72MHUC1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2NZcwqw+PpBzN7dLSf8lYhymsCUgS3W/6caIRWAcklAPSAU7TNxK6AW4mwZ4CIsC
         IMWuD9MQPbU0Y8f3BgBNEt6v6EsaW1xS25VZPnuAtvYkko0Mx/2PHRBBh6ydIfT99I
         eSuCDr1+0BSTmFFGeIO+mk9lEc7Yzy+hpT5fgeRrDTu0p3c/bVMBva4napFb2I/ntV
         1vWLj4TkPNbZwgmAHjosInbKyvChYPm62g+nX7K2ocvtC75i6JWhqRjnsjjcOKXZom
         FygsorjLQIFQEzvy9JZ3N6br62TR1mufC6lDAmG+3BVaK68IEoPcTV4Cq6LfPrajSF
         w6pEy4t/rkPcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, yangerkun <yangerkun@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/17] ext4: if zeroout fails fall back to splitting the extent node
Date:   Thu,  9 Sep 2021 20:23:34 -0400
Message-Id: <20210910002338.176677-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002338.176677-1-sashal@kernel.org>
References: <20210910002338.176677-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 308c57ccf4318236be75dfa251c84713e694457b ]

If the underlying storage device is using thin-provisioning, it's
possible for a zeroout operation to return ENOSPC.

Commit df22291ff0fd ("ext4: Retry block allocation if we have free blocks
left") added logic to retry block allocation since we might get free block
after we commit a transaction. But the ENOSPC from thin-provisioning
will confuse ext4, and lead to an infinite loop.

Since using zeroout instead of splitting the extent node is an
optimization, if it fails, we might as well fall back to splitting the
extent node.

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d195f41071d8..851ccbc01138 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3636,7 +3636,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				split_map.m_len - ee_block);
 			err = ext4_ext_zeroout(inode, &zero_ex1);
 			if (err)
-				goto out;
+				goto fallback;
 			split_map.m_len = allocated;
 		}
 		if (split_map.m_lblk - ee_block + split_map.m_len <
@@ -3650,7 +3650,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 						      ext4_ext_pblock(ex));
 				err = ext4_ext_zeroout(inode, &zero_ex2);
 				if (err)
-					goto out;
+					goto fallback;
 			}
 
 			split_map.m_len += split_map.m_lblk - ee_block;
@@ -3659,6 +3659,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		}
 	}
 
+fallback:
 	err = ext4_split_extent(handle, inode, ppath, &split_map, split_flag,
 				flags);
 	if (err > 0)
-- 
2.30.2

