Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325073BC0B1
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhGEPhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhGEPgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36688619A2;
        Mon,  5 Jul 2021 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499107;
        bh=lbYxqRQqaL2rsRK7+nPGpfIHnAPhEYU8gnkgmXGuNmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EY7Jqj2wt/0bEC6aTLSOPeSYXdvJbqpz0r3VL55Tc3HwZN/bZYZstTrqjjM7azrVv
         zqkCVGCoK5ueyq4VbpoMz+3PwSJZczCdAA+p+3A6tz9ZV5ZJDmzY/m7vBkQWyqj2xt
         RLO9sYtjOT1pmy4nquAQR21I+aas6KOZPkA9aj3fyEqqXl+ORdJu3G6lWPzoBAZO+l
         kUKHpAaPc3A+1lOdXIXvaaoTNirRfo+TdeDcjHHJdmtdC5r0e8IiEY3UbejyM2Rz+I
         FSHTwczKB9M7CallSgHr3MyctrtEJpVWn/LMkJQ8t7UX2xNw48AfcgtnqrQQfJXktf
         Qx/d7BZCgesnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 09/15] fs: dlm: fix memory leak when fenced
Date:   Mon,  5 Jul 2021 11:31:30 -0400
Message-Id: <20210705153136.1522245-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153136.1522245-1-sashal@kernel.org>
References: <20210705153136.1522245-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 700ab1c363c7b54c9ea3222379b33fc00ab02f7b ]

I got some kmemleak report when a node was fenced. The user space tool
dlm_controld will therefore run some rmdir() in dlm configfs which was
triggering some memleaks. This patch stores the sps and cms attributes
which stores some handling for subdirectories of the configfs cluster
entry and free them if they get released as the parent directory gets
freed.

unreferenced object 0xffff88810d9e3e00 (size 192):
  comm "dlm_controld", pid 342, jiffies 4294698126 (age 55438.801s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 73 70 61 63 65 73 00 00  ........spaces..
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000db8b640b>] make_cluster+0x5d/0x360
    [<000000006a571db4>] configfs_mkdir+0x274/0x730
    [<00000000b094501c>] vfs_mkdir+0x27e/0x340
    [<0000000058b0adaf>] do_mkdirat+0xff/0x1b0
    [<00000000d1ffd156>] do_syscall_64+0x40/0x80
    [<00000000ab1408c8>] entry_SYSCALL_64_after_hwframe+0x44/0xae
unreferenced object 0xffff88810d9e3a00 (size 192):
  comm "dlm_controld", pid 342, jiffies 4294698126 (age 55438.801s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 63 6f 6d 6d 73 00 00 00  ........comms...
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a7ef6ad2>] make_cluster+0x82/0x360
    [<000000006a571db4>] configfs_mkdir+0x274/0x730
    [<00000000b094501c>] vfs_mkdir+0x27e/0x340
    [<0000000058b0adaf>] do_mkdirat+0xff/0x1b0
    [<00000000d1ffd156>] do_syscall_64+0x40/0x80
    [<00000000ab1408c8>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/config.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 472f4f835d3e..4fb070b7f00f 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -80,6 +80,9 @@ struct dlm_cluster {
 	unsigned int cl_new_rsb_count;
 	unsigned int cl_recover_callbacks;
 	char cl_cluster_name[DLM_LOCKSPACE_LEN];
+
+	struct dlm_spaces *sps;
+	struct dlm_comms *cms;
 };
 
 static struct dlm_cluster *config_item_to_cluster(struct config_item *i)
@@ -356,6 +359,9 @@ static struct config_group *make_cluster(struct config_group *g,
 	if (!cl || !sps || !cms)
 		goto fail;
 
+	cl->sps = sps;
+	cl->cms = cms;
+
 	config_group_init_type_name(&cl->group, name, &cluster_type);
 	config_group_init_type_name(&sps->ss_group, "spaces", &spaces_type);
 	config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
@@ -405,6 +411,9 @@ static void drop_cluster(struct config_group *g, struct config_item *i)
 static void release_cluster(struct config_item *i)
 {
 	struct dlm_cluster *cl = config_item_to_cluster(i);
+
+	kfree(cl->sps);
+	kfree(cl->cms);
 	kfree(cl);
 }
 
-- 
2.30.2

