Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035A7291BED
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgJRTZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731440AbgJRTZx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:25:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 044292231B;
        Sun, 18 Oct 2020 19:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049152;
        bh=8F3uUtHSi5y+880/nn5AXD4aT5Eiz5gbBtxIaXiatbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+Z4KgfRPXDs97ubEcw95+RmOHu07a8aLeOA7WFnEXqZnjpEsh6k8H+Me/0DxitYC
         RlHsOe9jefYzGGPoD+IUjsFWZ8mRpGBbNdoS9D/yULzIv7poWuTTKqkq6kRkiBPFqw
         dQZC4GE3NSOvg0u8PLQ8cSGA0Pz/j/UGNa+UJGAk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 18/52] fs: dlm: fix configfs memory leak
Date:   Sun, 18 Oct 2020 15:24:55 -0400
Message-Id: <20201018192530.4055730-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7211e826d90df..472f4f835d3e1 100644
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

