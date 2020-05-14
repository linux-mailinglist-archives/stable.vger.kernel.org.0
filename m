Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051C71D3C78
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgENTHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:07:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbgENSxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:53:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5336F207D4;
        Thu, 14 May 2020 18:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482415;
        bh=VsK0g977HCUvv2p+p8A6vloXv/+zI/XyUKoE/Mhqg0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jj3L+o4Z2KYuuzgxbCPPqz/w60PYepUx1k2fTicpdQuX9OdcqVWWzohgk6yrfrzBD
         FQAg81ZTKCITiCeNhSKP8hdCj3kUOwRhQ9WsYDghB5j0tFz+gMtXhEXIC2T0z1Gf7I
         kQvW/y/1B7zAMBK8PU3+Ke9tjgSNLizi+fksK940=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 20/49] x86/mm/cpa: Flush direct map alias during cpa
Date:   Thu, 14 May 2020 14:52:41 -0400
Message-Id: <20200514185311.20294-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

[ Upstream commit ab5130186d7476dcee0d4e787d19a521ca552ce9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pageattr.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a19a71b4d1850..281e584cfe39e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -42,7 +42,8 @@ struct cpa_data {
 	unsigned long	pfn;
 	unsigned int	flags;
 	unsigned int	force_split		: 1,
-			force_static_prot	: 1;
+			force_static_prot	: 1,
+			force_flush_all		: 1;
 	struct page	**pages;
 };
 
@@ -352,10 +353,10 @@ static void cpa_flush(struct cpa_data *data, int cache)
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
@@ -1584,6 +1585,8 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 		alias_cpa.curpage = 0;
 
+		cpa->force_flush_all = 1;
+
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
 		if (ret)
 			return ret;
@@ -1604,6 +1607,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 		alias_cpa.curpage = 0;
 
+		cpa->force_flush_all = 1;
 		/*
 		 * The high mapping range is imprecise, so ignore the
 		 * return value.
-- 
2.20.1

