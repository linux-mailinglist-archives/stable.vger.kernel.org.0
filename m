Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CAE1D0DB9
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387767AbgEMJzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388238AbgEMJzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:55:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122C4205ED;
        Wed, 13 May 2020 09:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363717;
        bh=vAyTy4r/PAq4UOpinLcKhBk/Qzc2OfeoEtEpUCCAc2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNodMjz3bDRNgCMENgXkNYitCFnqYrYAsFW5EKwfKnKCUQOLOmtMDyHTZhc9llsQ1
         TUMqN7NNMEoAfWhRzQkmqqQOouJw7UnBojVJwx2nIkzpEXlW1SCXp1ONGXimHuI0fM
         3189tenasSts53U9CbNQnLQFjpHhFeolpqRN20YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.6 096/118] x86/mm/cpa: Flush direct map alias during cpa
Date:   Wed, 13 May 2020 11:45:15 +0200
Message-Id: <20200513094425.718296537@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

commit ab5130186d7476dcee0d4e787d19a521ca552ce9 upstream.

As an optimization, cpa_flush() was changed to optionally only flush
the range in @cpa if it was small enough.  However, this range does
not include any direct map aliases changed in cpa_process_alias(). So
small set_memory_() calls that touch that alias don't get the direct
map changes flushed. This situation can happen when the virtual
address taking variants are passed an address in vmalloc or modules
space.

In these cases, force a full TLB flush.

Note this issue does not extend to cases where the set_memory_() calls are
passed a direct map address, or page array, etc, as the primary target. In
those cases the direct map would be flushed.

Fixes: 935f5839827e ("x86/mm/cpa: Optimize cpa_flush_array() TLB invalidation")
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200424105343.GA20730@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/pat/set_memory.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -42,7 +42,8 @@ struct cpa_data {
 	unsigned long	pfn;
 	unsigned int	flags;
 	unsigned int	force_split		: 1,
-			force_static_prot	: 1;
+			force_static_prot	: 1,
+			force_flush_all		: 1;
 	struct page	**pages;
 };
 
@@ -352,10 +353,10 @@ static void cpa_flush(struct cpa_data *d
 		return;
 	}
 
-	if (cpa->numpages <= tlb_single_page_flush_ceiling)
-		on_each_cpu(__cpa_flush_tlb, cpa, 1);
-	else
+	if (cpa->force_flush_all || cpa->numpages > tlb_single_page_flush_ceiling)
 		flush_tlb_all();
+	else
+		on_each_cpu(__cpa_flush_tlb, cpa, 1);
 
 	if (!cache)
 		return;
@@ -1595,6 +1596,8 @@ static int cpa_process_alias(struct cpa_
 		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 		alias_cpa.curpage = 0;
 
+		cpa->force_flush_all = 1;
+
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
 		if (ret)
 			return ret;
@@ -1615,6 +1618,7 @@ static int cpa_process_alias(struct cpa_
 		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 		alias_cpa.curpage = 0;
 
+		cpa->force_flush_all = 1;
 		/*
 		 * The high mapping range is imprecise, so ignore the
 		 * return value.


