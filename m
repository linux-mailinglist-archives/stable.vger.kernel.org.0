Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A93732B0BC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345400AbhCCAyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232253AbhCCAfw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 19:35:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B647B64FAB;
        Wed,  3 Mar 2021 00:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614731700;
        bh=VyPUZIRlU8BQtBEJ3Go96hPQSAggN1n5NlI3M2NLO/w=;
        h=Date:From:To:Subject:From;
        b=PeWnCAgmdl4MgAc9Ta3CakmKfSb0cuN4OjtUGr77D7U1v/ezZvBccywG2f+BEy6Qe
         VGRgAvH0/0imzeRLaeN1nBkI+LTzg3FYWkp9qQTJnfxluv5Ott0skDK8xE5ZmuKviF
         wScTYtQBKyjmnS9h3khBUmQYiTz996LEkRUWt1ks=
Date:   Tue, 02 Mar 2021 16:35:00 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        stable@vger.kernel.org
Subject:  + squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch
 added to -mm tree
Message-ID: <20210303003500.c6fdpj8ep%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: squashfs: fix xattr id and id lookup sanity checks
has been added to the -mm tree.  Its filename is
     squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: fix xattr id and id lookup sanity checks

The checks for maximum metadata block size is missing
SQUASHFS_BLOCK_OFFSET (the two byte length count).

Link: https://lkml.kernel.org/r/2069685113.2081245.1614583677427@webmail.123-reg.co.uk
Fixes: f37aa4c7366e23f ("squashfs: add more sanity checks in id lookup")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/id.c       |    6 ++++--
 fs/squashfs/xattr_id.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/fs/squashfs/id.c~squashfs-fix-xattr-id-and-id-lookup-sanity-checks
+++ a/fs/squashfs/id.c
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
--- a/fs/squashfs/xattr_id.c~squashfs-fix-xattr-id-and-id-lookup-sanity-checks
+++ a/fs/squashfs/xattr_id.c
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
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-xattr-id-and-id-lookup-sanity-checks.patch

