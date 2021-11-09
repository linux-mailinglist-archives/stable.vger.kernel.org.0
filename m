Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020CC44A316
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbhKIBZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243077AbhKIBTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:19:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A6FA61242;
        Tue,  9 Nov 2021 01:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420047;
        bh=N6RHizLkRzyosPRoypivdcy02Eaqpt0uBe+ImZ/eEl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpMsW7qaJAxX+q5RAyDrM7hrlnCnGe4zb/UeW/g3HPJr2IJwjlp0+QnKlXfOW/+t+
         bw7agY6aw3GM7ebnrFMdam2hB5HsO0Xfxxml2Qw/YkjrG3UO51Gdw76EKoW0F7Ks5B
         S9LPOXd8CN8X8yGptbgJMhKnGM5CUEuPJGut/dHxsJVhAgOY55/Zd8qVVFM+H7FW+t
         uw1Xw1G687PyTTVIrZN1Kacj7q6gVpMLHYSQhr/+SU4f644NXsnnxjgYf87wcvG0Ak
         6+Pn7oHTfJIXpCdG1epREHGHQR/WeuYpwcQ7sxD0XT1kpCtEuQkYOTlfeMJ+bZzwVC
         KsotE3hVaVJBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 4.14 21/39] tracefs: Have tracefs directories not set OTH permission bits by default
Date:   Mon,  8 Nov 2021 20:06:31 -0500
Message-Id: <20211109010649.1191041-21-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit 49d67e445742bbcb03106b735b2ab39f6e5c56bc ]

The tracefs file system is by default mounted such that only root user can
access it. But there are legitimate reasons to create a group and allow
those added to the group to have access to tracing. By changing the
permissions of the tracefs mount point to allow access, it will allow
group access to the tracefs directory.

There should not be any real reason to allow all access to the tracefs
directory as it contains sensitive information. Have the default
permission of directories being created not have any OTH (other) bits set,
such that an admin that wants to give permission to a group has to first
disable all OTH bits in the file system.

Link: https://lkml.kernel.org/r/20210818153038.664127804@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index bea8ad876bf9a..0c123c5e70e08 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -427,7 +427,8 @@ static struct dentry *__create_dir(const char *name, struct dentry *parent,
 	if (unlikely(!inode))
 		return failed_creating(dentry);
 
-	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
+	/* Do not set bits for OTH */
+	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUSR| S_IRGRP | S_IXUSR | S_IXGRP;
 	inode->i_op = ops;
 	inode->i_fop = &simple_dir_operations;
 
-- 
2.33.0

