Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7977246A4F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgHQPd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgHQPdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30F4C22B49;
        Mon, 17 Aug 2020 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678403;
        bh=2HnaoUpQU7Dicbmj+xnwySE5pVovhZ3kXMTyQSvzi1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwYEERRn6eqMPP9a8/iiVmnJYUuSJW70DmGhNfTG634n0iEaFeU+mvgkgaCjnoyAO
         BmYqEloCrzp39TZ967nr7NOpNPekOKcWhJbqlR8aL43PQU4xDZp2OpwAjbj/ARUqmd
         0B5O2/BRo8zhTsG12OTd4XZBGe8reGS2mSMPk5uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 292/464] bpf: Fix pos computation for bpf_iter seq_ops->start()
Date:   Mon, 17 Aug 2020 17:14:05 +0200
Message-Id: <20200817143847.742429900@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 3f9969f2c040ba2ba635b6b5a7051f404bcc634d ]

Currently, the pos pointer in bpf iterator map/task/task_file
seq_ops->start() is always incremented.
This is incorrect. It should be increased only if
*pos is 0 (for SEQ_START_TOKEN) since these start()
function actually returns the first real object.
If *pos is not 0, it merely found the object
based on the state in seq->private, and not really
advancing the *pos. This patch fixed this issue
by only incrementing *pos if it is 0.

Note that the old *pos calculation, although not
correct, does not affect correctness of bpf_iter
as bpf_iter seq_file->read() does not support llseek.

This patch also renamed "mid" in bpf_map iterator
seq_file private data to "map_id" for better clarity.

Fixes: 6086d29def80 ("bpf: Add bpf_map iterator")
Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200722195156.4029817-1-yhs@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/map_iter.c  | 16 ++++++----------
 kernel/bpf/task_iter.c |  6 ++++--
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/map_iter.c b/kernel/bpf/map_iter.c
index c69071e334bf6..1a04c168563d3 100644
--- a/kernel/bpf/map_iter.c
+++ b/kernel/bpf/map_iter.c
@@ -6,7 +6,7 @@
 #include <linux/kernel.h>
 
 struct bpf_iter_seq_map_info {
-	u32 mid;
+	u32 map_id;
 };
 
 static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
@@ -14,27 +14,23 @@ static void *bpf_map_seq_start(struct seq_file *seq, loff_t *pos)
 	struct bpf_iter_seq_map_info *info = seq->private;
 	struct bpf_map *map;
 
-	map = bpf_map_get_curr_or_next(&info->mid);
+	map = bpf_map_get_curr_or_next(&info->map_id);
 	if (!map)
 		return NULL;
 
-	++*pos;
+	if (*pos == 0)
+		++*pos;
 	return map;
 }
 
 static void *bpf_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct bpf_iter_seq_map_info *info = seq->private;
-	struct bpf_map *map;
 
 	++*pos;
-	++info->mid;
+	++info->map_id;
 	bpf_map_put((struct bpf_map *)v);
-	map = bpf_map_get_curr_or_next(&info->mid);
-	if (!map)
-		return NULL;
-
-	return map;
+	return bpf_map_get_curr_or_next(&info->map_id);
 }
 
 struct bpf_iter__bpf_map {
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 4dbf2b6035f87..ac7869a389990 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -50,7 +50,8 @@ static void *task_seq_start(struct seq_file *seq, loff_t *pos)
 	if (!task)
 		return NULL;
 
-	++*pos;
+	if (*pos == 0)
+		++*pos;
 	return task;
 }
 
@@ -209,7 +210,8 @@ static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
 		return NULL;
 	}
 
-	++*pos;
+	if (*pos == 0)
+		++*pos;
 	info->task = task;
 	info->files = files;
 
-- 
2.25.1



