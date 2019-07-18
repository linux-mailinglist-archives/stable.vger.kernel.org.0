Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A956D70D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391573AbfGRXGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:23 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35141 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391508AbfGRXGX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:23 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so7247723pgr.2;
        Thu, 18 Jul 2019 16:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1uIbphx6NSKm0Sqq/tE2psnkMa07yggKxaPV7J4/nmM=;
        b=pZUYyVP18HN6Tp/0z3asMzgADr6p+YXin6cw6qW+CeL2PrIc0AZY4TgIGscdrbpBUD
         LR+uR/9EBpkUQp4spWy7keShFqz34aE7M21TYRG4ty+Y+4y837+79bDGHCftJv4yp4zU
         eXtYnL+pyLrk+NyBcrz23hEWbUU2r2YK1M1MEaQO8xNoWmHVRJRoMj/ZYAURnaplS00N
         PsL2PmiCzBuCzNvr+RdSer3vyuCldL+izxG4ASXs0OJjzA5ChVxLTj0pHR7UpTb+V15Z
         QFDcuEoxIvzzAsUP+2XrxGdYh4pYoEvM3EzzvTKd6fQoDHNLFthF2MikdNghX6VnwXwn
         202g==
X-Gm-Message-State: APjAAAU9PeF6Kp4kkGjeJyFIK65IHyfoGlYTuyszUD7PFgLmRWPoi0VO
        tPMkMraeMFMAum4mQg9nCrI=
X-Google-Smtp-Source: APXvYqxYHxyAmehpEkgAAftAxk3dLBv09TcDURVA27vrDPIxOHqs0p6fFHw0etFZYwKw/njFe9NKWg==
X-Received: by 2002:a17:90a:fa12:: with SMTP id cm18mr53756255pjb.137.1563491182300;
        Thu, 18 Jul 2019 16:06:22 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id n7sm34025966pff.59.2019.07.18.16.06.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:19 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 378A54075D; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 3/9] xfs: don't overflow xattr listent buffer
Date:   Thu, 18 Jul 2019 23:06:11 +0000
Message-Id: <20190718230617.7439-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 3b50086f0c0d78c144d9483fa292c1509c931b70 upstream.

For VFS listxattr calls, xfs_xattr_put_listent calls
__xfs_xattr_put_listent twice if it sees an attribute
"trusted.SGI_ACL_FILE": once for that name, and again for
"system.posix_acl_access".  Unfortunately, if we happen to run out of
buffer space while emitting the first name, we set count to -1 (so that
we can feed ERANGE to the caller).  The second invocation doesn't check that
the context parameters make sense and overwrites the byte before the
buffer, triggering a KASAN report:

==================================================================
BUG: KASAN: slab-out-of-bounds in strncpy+0xb3/0xd0
Write of size 1 at addr ffff88807fbd317f by task syz/1113

CPU: 3 PID: 1113 Comm: syz Not tainted 5.0.0-rc6-xfsx #rc6
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0xcc/0x180
 print_address_description+0x6c/0x23c
 kasan_report.cold.3+0x1c/0x35
 strncpy+0xb3/0xd0
 __xfs_xattr_put_listent+0x1a9/0x2c0 [xfs]
 xfs_attr_list_int_ilocked+0x11af/0x1800 [xfs]
 xfs_attr_list_int+0x20c/0x2e0 [xfs]
 xfs_vn_listxattr+0x225/0x320 [xfs]
 listxattr+0x11f/0x1b0
 path_listxattr+0xbd/0x130
 do_syscall_64+0x139/0x560

While we're at it we add an assert to the other put_listent to avoid
this sort of thing ever happening to the attrlist_by_handle code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_attr_list.c | 1 +
 fs/xfs/xfs_xattr.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a58034049995..3d213a7394c5 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -555,6 +555,7 @@ xfs_attr_put_listent(
 	attrlist_ent_t *aep;
 	int arraytop;
 
+	ASSERT(!context->seen_enough);
 	ASSERT(!(context->flags & ATTR_KERNOVAL));
 	ASSERT(context->count >= 0);
 	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 63ee1d5bf1d7..9a63016009a1 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -129,6 +129,9 @@ __xfs_xattr_put_listent(
 	char *offset;
 	int arraytop;
 
+	if (context->count < 0 || context->seen_enough)
+		return;
+
 	if (!context->alist)
 		goto compute_size;
 
-- 
2.20.1

