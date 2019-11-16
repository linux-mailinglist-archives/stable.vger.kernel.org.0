Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2220FED84
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfKPPo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729100AbfKPPo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:44:58 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E38820815;
        Sat, 16 Nov 2019 15:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919098;
        bh=pzDYauFJ0kQK/ZeJvv8P41sxlFTiAZXH6gXqzETieCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjkatGxXDYscaqKJ6vv2zlj2xtfsEK6TKr1iVdqgfSgYD0TaZm+MH2xUoxVQnkedV
         skd/yVk1WQl6y9V4Npm64jqT5SAey2mousurP5D2ngFhqaNhS69KHS7zW4oH4Ogns3
         yeX8FXPVQD99xFOH3THIkVc1lWWRFgNO81kgYsN4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ernesto=20A=2E=20Fern=C3=A1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 153/237] hfsplus: fix BUG on bnode parent update
Date:   Sat, 16 Nov 2019 10:39:48 -0500
Message-Id: <20191116154113.7417-153-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

[ Upstream commit 19a9d0f1acf75e8be8cfba19c1a34e941846fa2b ]

Creating, renaming or deleting a file may hit BUG_ON() if the first
record of both a leaf node and its parent are changed, and if this
forces the parent to be split.  This bug is triggered by xfstests
generic/027, somewhat rarely; here is a more reliable reproducer:

  truncate -s 50M fs.iso
  mkfs.hfsplus fs.iso
  mount fs.iso /mnt
  i=1000
  while [ $i -le 2400 ]; do
    touch /mnt/$i &>/dev/null
    ((++i))
  done
  i=2400
  while [ $i -ge 1000 ]; do
    mv /mnt/$i /mnt/$(perl -e "print $i x61") &>/dev/null
    ((--i))
  done

The issue is that a newly created bnode is being put twice.  Reset
new_node to NULL in hfs_brec_update_parent() before reaching goto again.

Link: http://lkml.kernel.org/r/5ee1db09b60373a15890f6a7c835d00e76bf601d.1535682461.git.ernesto.mnd.fernandez@gmail.com
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/brec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfsplus/brec.c b/fs/hfsplus/brec.c
index aa17a392b4140..1918544a78716 100644
--- a/fs/hfsplus/brec.c
+++ b/fs/hfsplus/brec.c
@@ -449,6 +449,7 @@ static int hfs_brec_update_parent(struct hfs_find_data *fd)
 			/* restore search_key */
 			hfs_bnode_read_key(node, fd->search_key, 14);
 		}
+		new_node = NULL;
 	}
 
 	if (!rec && node->parent)
-- 
2.20.1

