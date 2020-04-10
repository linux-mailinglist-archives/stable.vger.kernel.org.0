Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B888D1A4199
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgDJEDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 00:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgDJDqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:46:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7F1A20B1F;
        Fri, 10 Apr 2020 03:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490411;
        bh=GsCdRkH6Shz5a43jOx+xZYYuDbINTK0YiB1BnatUcgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTTerZNzfqNzGwJRya8BKevGwkatUyZ1HeZjCKD6o/D60Ijy7rms66btWPEo2xRNR
         K7+fnThKPiSpeeKjXKQY264ZdPVWdLcTlC15AiQYb72JhQ73lGWfpd+/atNq3+DoTq
         R0oW6uZrQfrjQoLSHg/Ig4BzsoGeEeOjhTVJSU0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 13/68] arm64/mm: Hold memory hotplug lock while walking for kernel page table dump
Date:   Thu,  9 Apr 2020 23:45:38 -0400
Message-Id: <20200410034634.7731-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit bf2b59f60ee1fefa768d62ec6e8f4b4d9e04c691 ]

The arm64 page table dump code can race with concurrent modification of the
kernel page tables. When a leaf entries are modified concurrently, the dump
code may log stale or inconsistent information for a VA range, but this is
otherwise not harmful.

When intermediate levels of table are freed, the dump code will continue to
use memory which has been freed and potentially reallocated for another
purpose. In such cases, the dump code may dereference bogus addresses,
leading to a number of potential problems.

Intermediate levels of table may by freed during memory hot-remove,
which will be enabled by a subsequent patch. To avoid racing with
this, take the memory hotplug lock when walking the kernel page table.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/ptdump_debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
index 1f2eae3e988b6..d29d722ec3ec6 100644
--- a/arch/arm64/mm/ptdump_debugfs.c
+++ b/arch/arm64/mm/ptdump_debugfs.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/debugfs.h>
+#include <linux/memory_hotplug.h>
 #include <linux/seq_file.h>
 
 #include <asm/ptdump.h>
@@ -7,7 +8,10 @@
 static int ptdump_show(struct seq_file *m, void *v)
 {
 	struct ptdump_info *info = m->private;
+
+	get_online_mems();
 	ptdump_walk(m, info);
+	put_online_mems();
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(ptdump);
-- 
2.20.1

