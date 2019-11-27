Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9565510BA5B
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbfK0VCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731031AbfK0VCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:02:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A90B21569;
        Wed, 27 Nov 2019 21:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888533;
        bh=febHDCnmAbc7A9SiF0v4GbyjctYAv1LCzcdfJi+6TSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ews0gNjW3Bj5dTdssvdhPSugT8r5SuamdysJFKt0MeBHUceLDawfb11l9YjnmGtuu
         w3AeRXp8k5heJZlFN4FgGX88xxXqnGsH9h7PG693aAqvNflRcGy+xwc+xhyls3fjUL
         uOoEh5eCEJkHL0CPL42MBBv80b7AuGqryZTKLKV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Ernesto=20A . =20Fern=C3=A1ndez?=" 
        <ernesto.mnd.fernandez@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 171/306] hfs: fix BUG on bnode parent update
Date:   Wed, 27 Nov 2019 21:30:21 +0100
Message-Id: <20191127203127.890727526@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



