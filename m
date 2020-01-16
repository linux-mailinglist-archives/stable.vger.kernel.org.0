Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485E313FF5E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbgAPXmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgAPX0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D0920684;
        Thu, 16 Jan 2020 23:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217200;
        bh=3gmjdTaVUXoSoGNgiGnKtLI5R2KJxvEfY/3ptwXubSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vd3/qxNo4DXqBp1N8odiO342AgKBy417suU9disaPqELo3bFWLyjdFn7w8aoyvCqD
         NeCf2qhjnp1Zcwz0KSdY8B/PFQYdyFnMqlYARmbdtYmOgAIdXgQHFeqCiJMfHdX2x5
         GAA5XvEdObOuj3k2oxU2oCX17HZvJyvdivrG6BuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        "zhangyi (F)" <yi.zhang@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 164/203] ubifs: do_kill_orphans: Fix a memory leak bug
Date:   Fri, 17 Jan 2020 00:18:01 +0100
Message-Id: <20200116231759.013280402@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 10256f000932f12596dc043cf880ecf488a32510 upstream.

If there are more than one valid snod on the sleb->nodes list,
do_kill_orphans will malloc ino more than once without releasing
previous ino's memory. Finally, it will trigger memory leak.

Fixes: ee1438ce5dc4 ("ubifs: Check link count of inodes when...")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/orphan.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -631,12 +631,17 @@ static int do_kill_orphans(struct ubifs_
 	ino_t inum;
 	int i, n, err, first = 1;
 
+	ino = kmalloc(UBIFS_MAX_INO_NODE_SZ, GFP_NOFS);
+	if (!ino)
+		return -ENOMEM;
+
 	list_for_each_entry(snod, &sleb->nodes, list) {
 		if (snod->type != UBIFS_ORPH_NODE) {
 			ubifs_err(c, "invalid node type %d in orphan area at %d:%d",
 				  snod->type, sleb->lnum, snod->offs);
 			ubifs_dump_node(c, snod->node);
-			return -EINVAL;
+			err = -EINVAL;
+			goto out_free;
 		}
 
 		orph = snod->node;
@@ -663,20 +668,18 @@ static int do_kill_orphans(struct ubifs_
 				ubifs_err(c, "out of order commit number %llu in orphan node at %d:%d",
 					  cmt_no, sleb->lnum, snod->offs);
 				ubifs_dump_node(c, snod->node);
-				return -EINVAL;
+				err = -EINVAL;
+				goto out_free;
 			}
 			dbg_rcvry("out of date LEB %d", sleb->lnum);
 			*outofdate = 1;
-			return 0;
+			err = 0;
+			goto out_free;
 		}
 
 		if (first)
 			first = 0;
 
-		ino = kmalloc(UBIFS_MAX_INO_NODE_SZ, GFP_NOFS);
-		if (!ino)
-			return -ENOMEM;
-
 		n = (le32_to_cpu(orph->ch.len) - UBIFS_ORPH_NODE_SZ) >> 3;
 		for (i = 0; i < n; i++) {
 			union ubifs_key key1, key2;


