Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F67D1607
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731562AbfJIR0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732365AbfJIRYd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:33 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 760DC2196E;
        Wed,  9 Oct 2019 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641872;
        bh=dBNfFW1i5/r2BQivx+3IfLIDAajDegli6uzZBECGzUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBxJtDqPUFrIOjyUTnSnbe+cerkMyDgm/okbe+1bCy+RBkJnyA0gBxpNdj0XVqR/A
         YL0j6PkKuzOE9GBTSuuqT5g/0it9SfRWmdq4bjfyoG22HjfOmn1AoNz6XclKS90kd5
         WbPW6dCHlwG+zOoyX8U7ABoc0AOnaL/1ED+NgKGs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 18/21] vfs: Fix EOVERFLOW testing in put_compat_statfs64
Date:   Wed,  9 Oct 2019 13:06:11 -0400
Message-Id: <20191009170615.32750-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170615.32750-1-sashal@kernel.org>
References: <20191009170615.32750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

[ Upstream commit cc3a7bfe62b947b423fcb2cfe89fcba92bf48fa3 ]

Today, put_compat_statfs64() disallows nearly any field value over
2^32 if f_bsize is only 32 bits, but that makes no sense.
compat_statfs64 is there for the explicit purpose of providing 64-bit
fields for f_files, f_ffree, etc.  And f_bsize is always only 32 bits.

As a result, 32-bit userspace gets -EOVERFLOW for i.e.  large file
counts even with -D_FILE_OFFSET_BITS=64 set.

In reality, only f_bsize and f_frsize can legitimately overflow
(fields like f_type and f_namelen should never be large), so test
only those fields.

This bug was discussed at length some time ago, and this is the proposal
Al suggested at https://lkml.org/lkml/2018/8/6/640.  It seemed to get
dropped amid the discussion of other related changes, but this
part seems obviously correct on its own, so I've picked it up and
sent it, for expediency.

Fixes: 64d2ab32efe3 ("vfs: fix put_compat_statfs64() does not handle errors")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/statfs.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/statfs.c b/fs/statfs.c
index c25dd9a26cc1c..ca1084cbe03cf 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -304,19 +304,10 @@ COMPAT_SYSCALL_DEFINE2(fstatfs, unsigned int, fd, struct compat_statfs __user *,
 static int put_compat_statfs64(struct compat_statfs64 __user *ubuf, struct kstatfs *kbuf)
 {
 	struct compat_statfs64 buf;
-	if (sizeof(ubuf->f_bsize) == 4) {
-		if ((kbuf->f_type | kbuf->f_bsize | kbuf->f_namelen |
-		     kbuf->f_frsize | kbuf->f_flags) & 0xffffffff00000000ULL)
-			return -EOVERFLOW;
-		/* f_files and f_ffree may be -1; it's okay
-		 * to stuff that into 32 bits */
-		if (kbuf->f_files != 0xffffffffffffffffULL
-		 && (kbuf->f_files & 0xffffffff00000000ULL))
-			return -EOVERFLOW;
-		if (kbuf->f_ffree != 0xffffffffffffffffULL
-		 && (kbuf->f_ffree & 0xffffffff00000000ULL))
-			return -EOVERFLOW;
-	}
+
+	if ((kbuf->f_bsize | kbuf->f_frsize) & 0xffffffff00000000ULL)
+		return -EOVERFLOW;
+
 	memset(&buf, 0, sizeof(struct compat_statfs64));
 	buf.f_type = kbuf->f_type;
 	buf.f_bsize = kbuf->f_bsize;
-- 
2.20.1

