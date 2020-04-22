Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4AA1B40CC
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgDVKsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729599AbgDVKOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:14:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3299920575;
        Wed, 22 Apr 2020 10:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550494;
        bh=NwE/eePGRE2epUa7HeUfEFC+VuWkfx6PsFIOES8/qPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ux4d0NbOEjaZRpTLqhcjmLTf54/KYxIdtzNkaqDjDYrCLXcxBP/Fh+2HT6oe/jGL3
         VWrB6cWNG+KnbjHVBbW7yhSmKKP1HXEwJ+RhJbtRu/5mAZ57hKWuWkYGzMlMTucIXX
         jbVMfecgewk7Y+pQUpFH1UF1WADy/y+BijgpSmio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Williams <dan.j.williams@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/64] include/linux/swapops.h: correct guards for non_swap_entry()
Date:   Wed, 22 Apr 2020 11:57:23 +0200
Message-Id: <20200422095020.026555152@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 22af9d8a84ae2..28d572b7ea73e 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -368,7 +368,8 @@ static inline void num_poisoned_pages_inc(void)
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



