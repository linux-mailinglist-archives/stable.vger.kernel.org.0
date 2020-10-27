Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B429729AF67
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754682AbgJ0OG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754676AbgJ0OG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:06:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30B382222C;
        Tue, 27 Oct 2020 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807588;
        bh=w08dWirnx9JqrKOIbZl+g/583fSfM3C3qY1xjnjCXs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loFTDgBN4v5V2dXNYc4XIrq9HeGuM87qbW5MMAo2kFSE8gNTfW8FIM/6XUfzfm+AL
         jFwSeUtnuGKxPrRRSCV08SPVKsgvYvTqhHJ5wqJlMNrgYsljM6WE8mOiEIwdjXCFSb
         zJyARqDh1dWTZoOFYs7D/zt73t4i2nn1C5ip065Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 108/139] fs: dlm: fix configfs memory leak
Date:   Tue, 27 Oct 2020 14:50:02 +0100
Message-Id: <20201027134907.266622914@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 3d2825c8c6105b0f36f3ff72760799fa2e71420e ]

This patch fixes the following memory detected by kmemleak and umount
gfs2 filesystem which removed the last lockspace:

unreferenced object 0xffff9264f482f600 (size 192):
  comm "dlm_controld", pid 325, jiffies 4294690276 (age 48.136s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 6e 6f 64 65 73 00 00 00  ........nodes...
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000060481d7>] make_space+0x41/0x130
    [<000000008d905d46>] configfs_mkdir+0x1a2/0x5f0
    [<00000000729502cf>] vfs_mkdir+0x155/0x210
    [<000000000369bcf1>] do_mkdirat+0x6d/0x110
    [<00000000cc478a33>] do_syscall_64+0x33/0x40
    [<00000000ce9ccf01>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

The patch just remembers the "nodes" entry pointer in space as I think
it's created as subdirectory when parent "spaces" is created. In
function drop_space() we will lost the pointer reference to nds because
configfs_remove_default_groups(). However as this subdirectory is always
available when "spaces" exists it will just be freed when "spaces" will be
freed.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index df955d2209ce9..6def89d2209d3 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -218,6 +218,7 @@ struct dlm_space {
 	struct list_head members;
 	struct mutex members_lock;
 	int members_count;
+	struct dlm_nodes *nds;
 };
 
 struct dlm_comms {
@@ -426,6 +427,7 @@ static struct config_group *make_space(struct config_group *g, const char *name)
 	INIT_LIST_HEAD(&sp->members);
 	mutex_init(&sp->members_lock);
 	sp->members_count = 0;
+	sp->nds = nds;
 	return &sp->group;
 
  fail:
@@ -447,6 +449,7 @@ static void drop_space(struct config_group *g, struct config_item *i)
 static void release_space(struct config_item *i)
 {
 	struct dlm_space *sp = config_item_to_space(i);
+	kfree(sp->nds);
 	kfree(sp);
 }
 
-- 
2.25.1



