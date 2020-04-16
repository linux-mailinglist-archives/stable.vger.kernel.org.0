Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FA71AC416
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897450AbgDPNyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898638AbgDPNyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA3AA20732;
        Thu, 16 Apr 2020 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045244;
        bh=GsCdRkH6Shz5a43jOx+xZYYuDbINTK0YiB1BnatUcgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6VT7a4a36hodGbsP87ZRBAIozVBTPLw4GfDnfGXD/mdCECE7QOjBV+rx9sflJrpR
         8QDjxC0P6VCPt2DNtLfpyAoDJD2CzaUI8W/za+iNJEq7Yt/KG5Atyhl/8f+B5rELvW
         /gEU0aNqGgdpDck1Qu//S6HI6wtQ4IZhWq1HEOC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Steven Price <steven.price@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 014/254] arm64/mm: Hold memory hotplug lock while walking for kernel page table dump
Date:   Thu, 16 Apr 2020 15:21:43 +0200
Message-Id: <20200416131327.591440866@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



