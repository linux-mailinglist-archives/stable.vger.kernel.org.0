Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E6234C697
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhC2II2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhC2IH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:07:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71F596196B;
        Mon, 29 Mar 2021 08:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005277;
        bh=EWcyRWDCzbio/IzJEMVtJOeSKiPOeEp8HG9IZTLd1No=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmyONQluTu8DUycoqxLmdFEAXMi4QlIrZvRNhrq6b3axZiU1AwS3qrxqxc4ZIW/DJ
         X1L2PF+D/O2+N9lgkImliybrV1MGyokCDfW9pazRMWhhJ1asKfcr/SspKEC9cF3Dly
         IJwAbRpXrwE/0AJo+UHCzLqnBURSNmqcp2Wc23cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>,
        Sean Nyekjaer <sean@geanix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 27/72] squashfs: fix xattr id and id lookup sanity checks
Date:   Mon, 29 Mar 2021 09:58:03 +0200
Message-Id: <20210329075611.160333176@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075610.300795746@linuxfoundation.org>
References: <20210329075610.300795746@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>

commit 8b44ca2b634527151af07447a8090a5f3a043321 upstream.

The checks for maximum metadata block size is missing
SQUASHFS_BLOCK_OFFSET (the two byte length count).

Link: https://lkml.kernel.org/r/2069685113.2081245.1614583677427@webmail.123-reg.co.uk
Fixes: f37aa4c7366e23f ("squashfs: add more sanity checks in id lookup")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Sean Nyekjaer <sean@geanix.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/id.c       |    6 ++++--
 fs/squashfs/xattr_id.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/fs/squashfs/id.c
+++ b/fs/squashfs/id.c
@@ -110,14 +110,16 @@ __le64 *squashfs_read_id_index_table(str
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end || (end - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
 	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= id_table_start || (id_table_start - start) > SQUASHFS_METADATA_SIZE) {
+	if (start >= id_table_start || (id_table_start - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -122,14 +122,16 @@ __le64 *squashfs_read_xattr_id_table(str
 		start = le64_to_cpu(table[n]);
 		end = le64_to_cpu(table[n + 1]);
 
-		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+		if (start >= end || (end - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 			kfree(table);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
 	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= table_start || (table_start - start) > SQUASHFS_METADATA_SIZE) {
+	if (start >= table_start || (table_start - start) >
+				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}


