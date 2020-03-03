Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFFE17816A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387601AbgCCSCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388177AbgCCSCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFD68206D5;
        Tue,  3 Mar 2020 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258538;
        bh=RdW95msYqZwPu5bl1s1ms5/qXiC27To1/xFmApXKYT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSYaawrfW/oYzFMBmBVBTslpXOEplln6Wcz0wlGKJYZHKia2oJFuuYGFCSmtdX8mf
         s1eKPCEYwVMf8lvOZB+YoznLFMAMFs840Cr47CppT3rv7ndWyaIlBk7w3mrp0UGOfA
         BeRZQj++LYNqK1Zu3S/gJ0KKpV3Z8wEeWes5AWE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 87/87] mm, thp: fix defrag setting if newline is not used
Date:   Tue,  3 Mar 2020 18:44:18 +0100
Message-Id: <20200303174358.147786617@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

commit f42f25526502d851d0e3ca1e46297da8aafce8a7 upstream.

If thp defrag setting "defer" is used and a newline is *not* used when
writing to the sysfs file, this is interpreted as the "defer+madvise"
option.

This is because we do prefix matching and if five characters are written
without a newline, the current code ends up comparing to the first five
bytes of the "defer+madvise" option and using that instead.

Use the more appropriate sysfs_streq() that handles the trailing newline
for us.  Since this doubles as a nice cleanup, do it in enabled_store()
as well.

The current implementation relies on prefix matching: the number of
bytes compared is either the number of bytes written or the length of
the option being compared.  With a newline, "defer\n" does not match
"defer+"madvise"; without a newline, however, "defer" is considered to
match "defer+madvise" (prefix matching is only comparing the first five
bytes).  End result is that writing "defer" is broken unless it has an
additional trailing character.

This means that writing "madv" in the past would match and set
"madvise".  With strict checking, that no longer is the case but it is
unlikely anybody is currently doing this.

Link: http://lkml.kernel.org/r/alpine.DEB.2.21.2001171411020.56385@chino.kir.corp.google.com
Fixes: 21440d7eb904 ("mm, thp: add new defer+madvise defrag option")
Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/huge_memory.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -173,16 +173,13 @@ static ssize_t enabled_store(struct kobj
 {
 	ssize_t ret = count;
 
-	if (!memcmp("always", buf,
-		    min(sizeof("always")-1, count))) {
+	if (sysfs_streq(buf, "always")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-	} else if (!memcmp("madvise", buf,
-			   min(sizeof("madvise")-1, count))) {
+	} else if (sysfs_streq(buf, "madvise")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (!memcmp("never", buf,
-			   min(sizeof("never")-1, count))) {
+	} else if (sysfs_streq(buf, "never")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
 	} else
@@ -246,32 +243,27 @@ static ssize_t defrag_store(struct kobje
 			    struct kobj_attribute *attr,
 			    const char *buf, size_t count)
 {
-	if (!memcmp("always", buf,
-		    min(sizeof("always")-1, count))) {
+	if (sysfs_streq(buf, "always")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
-	} else if (!memcmp("defer+madvise", buf,
-		    min(sizeof("defer+madvise")-1, count))) {
+	} else if (sysfs_streq(buf, "defer+madvise")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (!memcmp("defer", buf,
-		    min(sizeof("defer")-1, count))) {
+	} else if (sysfs_streq(buf, "defer")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
-	} else if (!memcmp("madvise", buf,
-			   min(sizeof("madvise")-1, count))) {
+	} else if (sysfs_streq(buf, "madvise")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);
 		set_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (!memcmp("never", buf,
-			   min(sizeof("never")-1, count))) {
+	} else if (sysfs_streq(buf, "never")) {
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG, &transparent_hugepage_flags);
 		clear_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG, &transparent_hugepage_flags);


