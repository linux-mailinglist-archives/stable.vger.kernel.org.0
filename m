Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A30415EB8B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391460AbgBNQKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:10:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390622AbgBNQKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03ADB2468F;
        Fri, 14 Feb 2020 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696618;
        bh=VxGyWnEba5VNmYC+QZbrZ1DU0OE8ldnVhLLrAP06RRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUp1confT9OiNuyhsL/IHtuZH1zvIMv/MEUqT/t2fGV8WDDAW9KwQO+OFdA9u2R4Y
         5Bmx+Z4wOLoIdxMMHMlXzDbN3eA/qoS/4qKbONQMQwjf7RZdytNwd5sqCOOs2d6snD
         II/c5eJxFsOZjDSPTvcV3mOV71DujtwObc6whJe4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Bringmann <mwb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 400/459] powerpc/pseries/lparcfg: Fix display of Maximum Memory
Date:   Fri, 14 Feb 2020 11:00:50 -0500
Message-Id: <20200214160149.11681-400-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Bringmann <mwb@linux.ibm.com>

[ Upstream commit f1dbc1c5c70d0d4c60b5d467ba941fba167c12f6 ]

Correct overflow problem in calculation and display of Maximum Memory
value to syscfg.

Signed-off-by: Michael Bringmann <mwb@linux.ibm.com>
[mpe: Only n_lmbs needs casting to unsigned long]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/5577aef8-1d5a-ca95-ff0a-9c7b5977e5bf@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index e33e8bc4b69bd..38c306551f76b 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -435,10 +435,10 @@ static void maxmem_data(struct seq_file *m)
 {
 	unsigned long maxmem = 0;
 
-	maxmem += drmem_info->n_lmbs * drmem_info->lmb_size;
+	maxmem += (unsigned long)drmem_info->n_lmbs * drmem_info->lmb_size;
 	maxmem += hugetlb_total_pages() * PAGE_SIZE;
 
-	seq_printf(m, "MaxMem=%ld\n", maxmem);
+	seq_printf(m, "MaxMem=%lu\n", maxmem);
 }
 
 static int pseries_lparcfg_data(struct seq_file *m, void *v)
-- 
2.20.1

