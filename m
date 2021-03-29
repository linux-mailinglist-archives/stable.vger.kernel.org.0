Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A039334C73F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhC2INf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbhC2IMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:12:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4530C61477;
        Mon, 29 Mar 2021 08:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005566;
        bh=sWzzsCkJggXUYwjaqk3ZNQKl7qOP3H5UYuNl4wv49dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivwH/R5AU5YsZ7hyMO+fX9yICon8Uk3fflFAHmkpf56uQKUm8VWP0pxSIldlAfOkY
         /NrK4hry7OWT8EPCRSpdXSf2yAT2soZnjx2nUCUxoVct6mYa9M0WZdCQ1mBj2Sa3r2
         ML1v/y8vPZGcbX2bbhjjpoxTrwReZTqoNw5y9Llc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>,
        Sean Nyekjaer <sean@geanix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 042/111] squashfs: fix xattr id and id lookup sanity checks
Date:   Mon, 29 Mar 2021 09:57:50 +0200
Message-Id: <20210329075616.575615175@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075615.186199980@linuxfoundation.org>
References: <20210329075615.186199980@linuxfoundation.org>
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
@@ -97,14 +97,16 @@ __le64 *squashfs_read_id_index_table(str
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
@@ -109,14 +109,16 @@ __le64 *squashfs_read_xattr_id_table(str
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


