Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81ABBFF113
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfKPPtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:57302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730376AbfKPPtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:49:41 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FCD22088F;
        Sat, 16 Nov 2019 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919381;
        bh=febHDCnmAbc7A9SiF0v4GbyjctYAv1LCzcdfJi+6TSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XFYv0gnCfioXCuTSzmEWBm5wAI1KczSjwTt5pbrbniaIkj+cwt8fNb4YAOs4mRiY
         KQO6rAZTB+14k3kLW+OPDxKLJMMBSH+/bsSc427kWK0pIwDBfY631P+lxChaGT50E7
         jR42AdCwWGaKmJLbcZvXDGpc5h+mUO9ASdv0Y7QA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ernesto=20A=2E=20Fern=C3=A1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 096/150] hfs: fix BUG on bnode parent update
Date:   Sat, 16 Nov 2019 10:46:34 -0500
Message-Id: <20191116154729.9573-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
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

[ Upstream commit ef75bcc5763d130451a99825f247d301088b790b ]

hfs_brec_update_parent() may hit BUG_ON() if the first record of both a
leaf node and its parent are changed, and if this forces the parent to
be split.  It is not possible for this to happen on a valid hfs
filesystem because the index nodes have fixed length keys.

For reasons I ignore, the hfs module does have support for a number of
hfsplus features.  A corrupt btree header may report variable length
keys and trigger this BUG, so it's better to fix it.

Link: http://lkml.kernel.org/r/cf9b02d57f806217a2b1bf5db8c3e39730d8f603.1535682463.git.ernesto.mnd.fernandez@gmail.com
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/brec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/hfs/brec.c b/fs/hfs/brec.c
index da25c49203cc5..896396554bcc1 100644
--- a/fs/hfs/brec.c
+++ b/fs/hfs/brec.c
@@ -445,6 +445,7 @@ static int hfs_brec_update_parent(struct hfs_find_data *fd)
 			/* restore search_key */
 			hfs_bnode_read_key(node, fd->search_key, 14);
 		}
+		new_node = NULL;
 	}
 
 	if (!rec && node->parent)
-- 
2.20.1

