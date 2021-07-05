Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C283BC028
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhGEPeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:34:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232673AbhGEPdu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:33:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B637461995;
        Mon,  5 Jul 2021 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625499052;
        bh=GbL7MFSqlv376g2z4kHSDVV2whdrPQVE5GcGVl3q+Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpdIsQ2OO24cvCzb8eOOi9ZAA7CqDo4C4bFbGrvJSZR5510Zyi46Os40PdLzgQI33
         UirlVjlmHq35Ck4RrkfKQWkq1LQk0UFEcEz5Rg4rmkPseyHTk0G/rbQMR2ynusyYDZ
         GTITt/yZYdl0PTmyDFr2Kj+LnQ6e0knGixED6oK7SfD/hLvgVF88ajuOPt6aySI050
         kTzabLyNMs0iZrcXY6NvnvCcUmJGLWJ58YJtLx3k2i8P6axIL6uE2s1otaCjexqOv/
         6dH/ocEV3pRwTvntLgiC+JyvviVGR+TfOLlNkzcJPwaJb+RmQUJyx0Ar3ped1ZZfx0
         AUJfInalfkJPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 10/26] fs: dlm: fix memory leak when fenced
Date:   Mon,  5 Jul 2021 11:30:23 -0400
Message-Id: <20210705153039.1521781-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705153039.1521781-1-sashal@kernel.org>
References: <20210705153039.1521781-1-sashal@kernel.org>
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
index 3b1012a3c439..b7e288cf3f5f 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -78,6 +78,9 @@ struct dlm_cluster {
 	unsigned int cl_new_rsb_count;
 	unsigned int cl_recover_callbacks;
 	char cl_cluster_name[DLM_LOCKSPACE_LEN];
+
+	struct dlm_spaces *sps;
+	struct dlm_comms *cms;
 };
 
 static struct dlm_cluster *config_item_to_cluster(struct config_item *i)
@@ -354,6 +357,9 @@ static struct config_group *make_cluster(struct config_group *g,
 	if (!cl || !sps || !cms)
 		goto fail;
 
+	cl->sps = sps;
+	cl->cms = cms;
+
 	config_group_init_type_name(&cl->group, name, &cluster_type);
 	config_group_init_type_name(&sps->ss_group, "spaces", &spaces_type);
 	config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
@@ -403,6 +409,9 @@ static void drop_cluster(struct config_group *g, struct config_item *i)
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

