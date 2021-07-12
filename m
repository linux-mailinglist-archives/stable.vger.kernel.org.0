Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A563C4D08
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbhGLHLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243020AbhGLHHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0357260FF0;
        Mon, 12 Jul 2021 07:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073468;
        bh=ZmkX+OYTX8ndWco2Efv9dhKBErMVHquuUcJrOOdq8vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMu9j/oy9T/Mni1RvtpmL2iRdS/G6jCQbl9vihGeOXGTPuiOcjiXwH7xBc51LiTBn
         aawRamDKPkNygT1mYSrHLt4i7C3GFA/1rnhxtUwDrkNf4e/D0l/1mZa/1g/tTTSn6+
         tir4dBBXEoSIRZnMFMODX4Rkeoxrm49pbjRFtiB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 215/700] fs: dlm: fix memory leak when fenced
Date:   Mon, 12 Jul 2021 08:04:58 +0200
Message-Id: <20210712060957.272673807@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 88d95d96e36c..52bcda64172a 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -79,6 +79,9 @@ struct dlm_cluster {
 	unsigned int cl_new_rsb_count;
 	unsigned int cl_recover_callbacks;
 	char cl_cluster_name[DLM_LOCKSPACE_LEN];
+
+	struct dlm_spaces *sps;
+	struct dlm_comms *cms;
 };
 
 static struct dlm_cluster *config_item_to_cluster(struct config_item *i)
@@ -409,6 +412,9 @@ static struct config_group *make_cluster(struct config_group *g,
 	if (!cl || !sps || !cms)
 		goto fail;
 
+	cl->sps = sps;
+	cl->cms = cms;
+
 	config_group_init_type_name(&cl->group, name, &cluster_type);
 	config_group_init_type_name(&sps->ss_group, "spaces", &spaces_type);
 	config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
@@ -458,6 +464,9 @@ static void drop_cluster(struct config_group *g, struct config_item *i)
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



