Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DBE1A9EF8
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368339AbgDOMFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406273AbgDOLrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAF2521655;
        Wed, 15 Apr 2020 11:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951250;
        bh=HWzTKrebOBV1otFjWMBXGbtXfVe7Pq8ScR7pIMJg+JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onGtAGAxEgfGMJyJGTER/5/dtK1CkxX9Eq++JKOrsaPatfANRjWDzb/l3XwPLabSp
         hYRztfAPxRzlkzq57ia63pq6Z0wrsr4JriGq0MWpIoRjxgyp3e2AkHqYQJFOAq62o/
         i81UJ4ABaJVvRQ+POrx/pBHy36sUT588TYc4a/60=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steven Price <steven.price@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Williams <dan.j.williams@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 16/30] include/linux/swapops.h: correct guards for non_swap_entry()
Date:   Wed, 15 Apr 2020 07:46:57 -0400
Message-Id: <20200415114711.15381-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114711.15381-1-sashal@kernel.org>
References: <20200415114711.15381-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit 3f3673d7d324d872d9d8ddb73b3e5e47fbf12e0d ]

If CONFIG_DEVICE_PRIVATE is defined, but neither CONFIG_MEMORY_FAILURE nor
CONFIG_MIGRATION, then non_swap_entry() will return 0, meaning that the
condition (non_swap_entry(entry) && is_device_private_entry(entry)) in
zap_pte_range() will never be true even if the entry is a device private
one.

Equally any other code depending on non_swap_entry() will not function as
expected.

I originally spotted this just by looking at the code, I haven't actually
observed any problems.

Looking a bit more closely it appears that actually this situation
(currently at least) cannot occur:

DEVICE_PRIVATE depends on ZONE_DEVICE
ZONE_DEVICE depends on MEMORY_HOTREMOVE
MEMORY_HOTREMOVE depends on MIGRATION

Fixes: 5042db43cc26 ("mm/ZONE_DEVICE: new type of ZONE_DEVICE for unaddressable memory")
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Link: http://lkml.kernel.org/r/20200305130550.22693-1-steven.price@arm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swapops.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 1d3877c39a000..0b8c860967527 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -377,7 +377,8 @@ static inline void num_poisoned_pages_inc(void)
 }
 #endif
 
-#if defined(CONFIG_MEMORY_FAILURE) || defined(CONFIG_MIGRATION)
+#if defined(CONFIG_MEMORY_FAILURE) || defined(CONFIG_MIGRATION) || \
+    defined(CONFIG_DEVICE_PRIVATE)
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;
-- 
2.20.1

