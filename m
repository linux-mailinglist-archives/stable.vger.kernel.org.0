Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE571B3F79
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbgDVKh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbgDVKWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00A6920882;
        Wed, 22 Apr 2020 10:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550933;
        bh=UoxmTXfy6bjZv9139OaXUfWx1bTquwXo0PhsUWbBzp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTN9k/6MfUj2VZ0AjFC2YDNg2FjUiKZ7R/JETGto3fgmKvvIG7thuH7fbqHQ6SlTw
         FaU7ojNBxogjkymg9x3BEg6XZvwc3lLrlHdTStx+B0PcHet7hfe6yBsP0BhPl2CXC+
         8LYWy1HrZRTaQ0iJm1AdW2ekl8ROnniDRxT9Cuqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.6 034/166] afs: Fix afs_d_validate() to set the right directory version
Date:   Wed, 22 Apr 2020 11:56:01 +0200
Message-Id: <20200422095052.471436236@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 40fc81027f892284ce31f8b6de1e497f5b47e71f upstream.

If a dentry's version is somewhere between invalid_before and the current
directory version, we should be setting it forward to the current version,
not backwards to the invalid_before version.  Note that we're only doing
this at all because dentry::d_fsdata isn't large enough on a 32-bit system.

Fix this by using a separate variable for invalid_before so that we don't
accidentally clobber the current dir version.

Fixes: a4ff7401fbfa ("afs: Keep track of invalid-before version for dentry coherency")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/dir.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1032,7 +1032,7 @@ static int afs_d_revalidate(struct dentr
 	struct dentry *parent;
 	struct inode *inode;
 	struct key *key;
-	afs_dataversion_t dir_version;
+	afs_dataversion_t dir_version, invalid_before;
 	long de_version;
 	int ret;
 
@@ -1084,8 +1084,8 @@ static int afs_d_revalidate(struct dentr
 	if (de_version == (long)dir_version)
 		goto out_valid_noupdate;
 
-	dir_version = dir->invalid_before;
-	if (de_version - (long)dir_version >= 0)
+	invalid_before = dir->invalid_before;
+	if (de_version - (long)invalid_before >= 0)
 		goto out_valid;
 
 	_debug("dir modified");


