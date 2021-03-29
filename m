Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C378034CA25
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhC2IfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233294AbhC2IeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:34:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 881E761601;
        Mon, 29 Mar 2021 08:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006841;
        bh=/8pC+aB8vIxGZ1rLfLyif8WJI8gMCmiBJGWfVbdIBy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QC97qvDpzeBOXwPrLjUKW/olNHryP2lbs6urzH1W2cbJGojrFNCYnvgKzqOUGMJAc
         B3ARx2vHpDCq0TZQ7HACaws/MJPkEwfzmhdzBD49sZIzMvZIRg7tgqgb0KUq7vBPaX
         p96XSui7MgLr+b7IK8aZmzjeo3zT+rQY1Ori5QGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        kernel test robot <oliver.sang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 084/254] mm/highmem: fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
Date:   Mon, 29 Mar 2021 09:56:40 +0200
Message-Id: <20210329075635.922676641@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

commit 487cfade12fae0eb707bdce71c4d585128238a7d upstream.

The kernel test robot found that __kmap_local_sched_out() was not
correctly skipping the guard pages when DEBUG_KMAP_LOCAL_FORCE_MAP was
set.[1] This was due to DEBUG_HIGHMEM check being used.

Change the configuration check to be correct.

[1] https://lore.kernel.org/lkml/20210304083825.GB17830@xsang-OptiPlex-9020/

Link: https://lkml.kernel.org/r/20210318230657.1497881-1-ira.weiny@intel.com
Fixes: 0e91a0c6984c ("mm/highmem: Provide CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP")
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver Sang <oliver.sang@intel.com>
Cc: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc: David Sterba <dsterba@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/highmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index 86f2b9495f9c..6ef8f5e05e7e 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -618,7 +618,7 @@ void __kmap_local_sched_out(void)
 		int idx;
 
 		/* With debug all even slots are unmapped and act as guard */
-		if (IS_ENABLED(CONFIG_DEBUG_HIGHMEM) && !(i & 0x01)) {
+		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
 			WARN_ON_ONCE(!pte_none(pteval));
 			continue;
 		}
@@ -654,7 +654,7 @@ void __kmap_local_sched_in(void)
 		int idx;
 
 		/* With debug all even slots are unmapped and act as guard */
-		if (IS_ENABLED(CONFIG_DEBUG_HIGHMEM) && !(i & 0x01)) {
+		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
 			WARN_ON_ONCE(!pte_none(pteval));
 			continue;
 		}
-- 
2.31.0



