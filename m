Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9664745BA26
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhKXMIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:08:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242322AbhKXMGx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:06:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76C1360F90;
        Wed, 24 Nov 2021 12:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755423;
        bh=TtnOT6SqyLZpNB90uBWqIEsCn9Yo+ZFjMmWllVTgTmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzP9vjTECNk6J2O5cTL6YOklxec0nr1fl1w7Vn3Sg88nUlHroCSPAUGIrW27ZD5Ej
         JQoALF9LEm8upWfvwXsMu/aXk3O2wmcL3ww51zaD5VLXSQzUQk/f7mBrvMTOd4y8sE
         Ar9ATFuEVXm1lY+ovhVhbDH9VGGGw5DZkNjYg9ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 057/162] tracefs: Have tracefs directories not set OTH permission bits by default
Date:   Wed, 24 Nov 2021 12:56:00 +0100
Message-Id: <20211124115700.187073302@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

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
index c66f2423e1f5c..6ccfd47157d37 100644
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



