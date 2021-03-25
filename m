Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711CA3487FB
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 05:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhCYEiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 00:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhCYEhy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 00:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDAEF61A14;
        Thu, 25 Mar 2021 04:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616647074;
        bh=R/0VGAuR9hWukgipjX/CZAqJ9nDPINcCLWzVjzgnumw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gPdifNNpijui7ypa+pI69790CiNQ6UzNgYwYp6A5k6tBfVHR6DJZgKZeUcS9xIrGl
         r+XOa4cRkte2v8uv5m3frFXnS9tiuxagj+NbZWV6RBHVzWCeTnpJSeS0qoCLu2GYUM
         jyTZGz8/JUm11hnSm27Sp6H4md1jEc2dJE9zKcaA=
Date:   Wed, 24 Mar 2021 21:37:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, Chaitanya.Kulkarni@wdc.com,
        dsterba@suse.com, ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, oliver.sang@intel.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject:  [patch 13/14] mm/highmem: fix
 CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
Message-ID: <20210325043753.HwajHE_mK%akpm@linux-foundation.org>
In-Reply-To: <20210324213644.bf03a529aec4ef9580e17dbc@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/highmem: fix CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP

The kernel test robot found that __kmap_local_sched_out() was not
correctly skipping the guard pages when CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
was set.[1] This was due to CONFIG_DEBUG_HIGHMEM check being used.

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
---

 mm/highmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~mm-highmem-fix-config_debug_kmap_local_force_map
+++ a/mm/highmem.c
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
_
