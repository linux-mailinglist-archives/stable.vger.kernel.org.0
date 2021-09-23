Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D70415635
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 05:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239164AbhIWDkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 23:40:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239150AbhIWDkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59EBA61211;
        Thu, 23 Sep 2021 03:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368317;
        bh=R7lS05/W32gsVyE3040Km9s4BjDQi6uL083xRRWgUs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c26SZeBCpomds+Q8XwVFcWrWpl8FdmgsN0R9KBH4xzctTyVQSthQXdQt5ZqfOq3VK
         8b0ztQCVznKw0BHLkYzUrVHc/Fys1Uegg8GjiRJlW3yXCyktsq9Aue3YkRV9/wCoOl
         jdsZYui1ANcTOCMhl5fy29QYVLwW4JqxTPffPB89AVHvr25rzlmeSKDdXlyJBC/fWr
         syDIlj7H73PyjrUVLz1cMnIfV2HVNHao6OtwpFmSArH8MM3uzz53Tyh3YEaZaqmABO
         Awp6KbgE+MKQAETOuOkzV0V3uydx7pTaxcxWADRDPNgkszu/ovHRa1AqxOKOrdBhYE
         pjJxGz+aucv0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hamza Mahfooz <someguy@effective-light.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, Christoph@vger.kernel.org,
        m.szyprowski@samsung.com, iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.14 08/34] dma-debug: prevent an error message from causing runtime problems
Date:   Wed, 22 Sep 2021 23:37:56 -0400
Message-Id: <20210923033823.1420814-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923033823.1420814-1-sashal@kernel.org>
References: <20210923033823.1420814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamza Mahfooz <someguy@effective-light.com>

[ Upstream commit 510e1a724ab1bf38150be2c1acabb303f98d0047 ]

For some drivers, that use the DMA API. This error message can be reached
several millions of times per second, causing spam to the kernel's printk
buffer and bringing the CPU usage up to 100% (so, it should be rate
limited). However, since there is at least one driver that is in the
mainline and suffers from the error condition, it is more useful to
err_printk() here instead of just rate limiting the error message (in hopes
that it will make it easier for other drivers that suffer from this issue
to be spotted).

Link: https://lkml.kernel.org/r/fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com
Reported-by: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index f2faa13534e5..70519f67556f 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -567,7 +567,8 @@ static void add_dma_entry(struct dma_debug_entry *entry)
 		pr_err("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
 	} else if (rc == -EEXIST) {
-		pr_err("cacheline tracking EEXIST, overlapping mappings aren't supported\n");
+		err_printk(entry->dev, entry,
+			"cacheline tracking EEXIST, overlapping mappings aren't supported\n");
 	}
 }
 
-- 
2.30.2

