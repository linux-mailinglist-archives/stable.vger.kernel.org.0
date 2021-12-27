Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6062D48007B
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbhL0Pqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44010 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238996AbhL0Pmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:42:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B5C5B810C3;
        Mon, 27 Dec 2021 15:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A084EC36AE7;
        Mon, 27 Dec 2021 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619765;
        bh=UXSAzmMYGQlIpw2x+mclLRj0aAcTHaXe2OLhCbvBWAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXAEhb/G2k1oNz0ilkbKZS1SbzXQALdK56xEgefaEhph7mCeHfQdVHZBLtXTsxIGd
         AKSxl6w55TP+lzt4E+MRINR2s5VLdWLq6F5TlDmKERV47nYjlhQ/gjjI7SSQCFfXJv
         1sHqZIY1eQhiM2zkGGCRDx8HaD33STglqVrxKzKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rudo <prudo@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 062/128] kernel/crash_core: suppress unknown crashkernel parameter warning
Date:   Mon, 27 Dec 2021 16:30:37 +0100
Message-Id: <20211227151333.571070318@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@redhat.com>

[ Upstream commit 71d2bcec2d4d69ff109c497e6611d6c53c8926d4 ]

When booting with crashkernel= on the kernel command line a warning
similar to

    Kernel command line: ro console=ttyS0 crashkernel=256M
    Unknown kernel command line parameters "crashkernel=256M", will be passed to user space.

is printed.

This comes from crashkernel= being parsed independent from the kernel
parameter handling mechanism.  So the code in init/main.c doesn't know
that crashkernel= is a valid kernel parameter and prints this incorrect
warning.

Suppress the warning by adding a dummy early_param handler for
crashkernel=.

Link: https://lkml.kernel.org/r/20211208133443.6867-1-prudo@redhat.com
Fixes: 86d1919a4fb0 ("init: print out unknown kernel parameters")
Signed-off-by: Philipp Rudo <prudo@redhat.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/crash_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index eb53f5ec62c90..256cf6db573cd 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -6,6 +6,7 @@
 
 #include <linux/buildid.h>
 #include <linux/crash_core.h>
+#include <linux/init.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
 
@@ -295,6 +296,16 @@ int __init parse_crashkernel_low(char *cmdline,
 				"crashkernel=", suffix_tbl[SUFFIX_LOW]);
 }
 
+/*
+ * Add a dummy early_param handler to mark crashkernel= as a known command line
+ * parameter and suppress incorrect warnings in init/main.c.
+ */
+static int __init parse_crashkernel_dummy(char *arg)
+{
+	return 0;
+}
+early_param("crashkernel", parse_crashkernel_dummy);
+
 Elf_Word *append_elf_note(Elf_Word *buf, char *name, unsigned int type,
 			  void *data, size_t data_len)
 {
-- 
2.34.1



