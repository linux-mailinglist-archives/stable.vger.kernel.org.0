Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869B1315A16
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 00:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhBIXco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 18:32:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233952AbhBIWR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 17:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 968F464EE2;
        Tue,  9 Feb 2021 21:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906956;
        bh=OW+Ju7E4y3ERDeDaWlFQpZDmetJfYur5KmZynBxTgtc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IQqJeE1Ah8Iz4iJffpBF7JFbANlmkj3/X7P+83X/EPxdIywlhzBFVV/zvA/GK1r1a
         1Po52uWrFqCHYAHgPuHkkc36fMkAxUa6MWb2iZaVuONcOJuk1QMvFa0vlT2i6+FOgf
         5BQgCHh233yFtOxVkDq7dsKn6p4odjLVUbVF7gK4=
Date:   Tue, 09 Feb 2021 13:42:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joachim.henke@t-systems.com,
        konishi.ryusuke@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 14/14] nilfs2: make splice write available again
Message-ID: <20210209214236.pDQfcjKyd%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joachim Henke <joachim.henke@t-systems.com>
Subject: nilfs2: make splice write available again

Since 5.10, splice() or sendfile() to NILFS2 return EINVAL.  This was
caused by commit 36e2c7421f02 ("fs: don't allow splice read/write without
explicit ops").

This patch initializes the splice_write field in file_operations, like
most file systems do, to restore the functionality.

Link: https://lkml.kernel.org/r/1612784101-14353-1-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Joachim Henke <joachim.henke@t-systems.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/file.c~nilfs2-make-splice-write-available-again
+++ a/fs/nilfs2/file.c
@@ -141,6 +141,7 @@ const struct file_operations nilfs_file_
 	/* .release	= nilfs_release_file, */
 	.fsync		= nilfs_sync_file,
 	.splice_read	= generic_file_splice_read,
+	.splice_write   = iter_file_splice_write,
 };
 
 const struct inode_operations nilfs_file_inode_operations = {
_
