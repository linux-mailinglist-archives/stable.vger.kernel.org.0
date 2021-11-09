Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3D444A344
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242915AbhKIB0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:26:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243695AbhKIBV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8496261B1F;
        Tue,  9 Nov 2021 01:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420121;
        bh=knbKyYPzWpERuxn/g4jYedV5Giy13X4uvF70rD3eruU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5vuxQlnEqKcnWT7By1U43THpEz2X0OUl7ikNDyEPSQynJHEeWqTSkkKWmMoEKU2m
         XQzgRv0JvmQ/tI31Kgih6rog4XLiiDi2y6nnXRkYJo0U77GbV//hPqMypawjaj8ENh
         7V8b0ZVPVquseS4zZz5m0cUkh6Z54m9mRmkB/UJU9DlIfSkdUEBDBhpe4N5b2+DgGf
         cmHqh7474YJPxDwCcaH4oqO0IbOGG3foUXsa7mmoJWq9kFCEC1Y70au2uQxKb9obQU
         96eO+OXR82HSvMZKtcaHZ6Zn+4KvoZiyUUBE5q6EIvzL/lMfh+49j+ekseYPM7N9F1
         dMAwyHdd+Wm0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 4.9 18/33] tracefs: Have tracefs directories not set OTH permission bits by default
Date:   Mon,  8 Nov 2021 20:07:52 -0500
Message-Id: <20211109010807.1191567-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
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
index 21d36d2847356..985cccfcedad9 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -429,7 +429,8 @@ static struct dentry *__create_dir(const char *name, struct dentry *parent,
 	if (unlikely(!inode))
 		return failed_creating(dentry);
 
-	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO;
+	/* Do not set bits for OTH */
+	inode->i_mode = S_IFDIR | S_IRWXU | S_IRUSR| S_IRGRP | S_IXUSR | S_IXGRP;
 	inode->i_op = ops;
 	inode->i_fop = &simple_dir_operations;
 
-- 
2.33.0

