Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E29D24A5
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388801AbfJJItE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388165AbfJJItA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E243F2064A;
        Thu, 10 Oct 2019 08:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697340;
        bh=AlzBdA8/4AmqnMFPRJWpA+uiooPBTPN0m2UkF6AWhYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HquXPDhJpjAPX2ik2T0iOCJInKwDu987PyCz2MnQ4viivlq8eEf2ailMvCB0WNszc
         yxnFwByQmcjdPGQUALF2njn0n1epup1+pajh+1yCQ9RWuseySItnPzdOV1YWDP3SwW
         j31UI5ea4LgWf/HTxqC6/xpCuaMvVPXr1BNY1+yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 106/114] vfs: Fix EOVERFLOW testing in put_compat_statfs64
Date:   Thu, 10 Oct 2019 10:36:53 +0200
Message-Id: <20191010083613.843593568@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit cc3a7bfe62b947b423fcb2cfe89fcba92bf48fa3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/statfs.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -304,19 +304,10 @@ COMPAT_SYSCALL_DEFINE2(fstatfs, unsigned
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


