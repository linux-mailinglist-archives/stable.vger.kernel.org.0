Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272A91FE0E9
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731843AbgFRB1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731836AbgFRB1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBC5520776;
        Thu, 18 Jun 2020 01:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443638;
        bh=sz2VY7bKf1cEfS5TP7IGpkiCBgblk54msJDFCj5Xo9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmA/EACX4W8r2tOg2ILQu/HMkki0f8WN9kEk6cdNd2tRgha6JbiYhfjPO/2Jmj9oi
         uE4wi6omXr5SrxI+bzH7UUN80cpd1cLKtVahruUrZAqAlah9VfbLdlk2e2W268X1CE
         5kYDIKdBBJ6D7mqL7pSGdBpGDr5o4M4d2ywTMuPQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 061/108] powerpc/ps3: Fix kexec shutdown hang
Date:   Wed, 17 Jun 2020 21:25:13 -0400
Message-Id: <20200618012600.608744-61-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoff Levand <geoff@infradead.org>

[ Upstream commit 126554465d93b10662742128918a5fc338cda4aa ]

The ps3_mm_region_destroy() and ps3_mm_vas_destroy() routines
are called very late in the shutdown via kexec's mmu_cleanup_all
routine.  By the time mmu_cleanup_all runs it is too late to use
udbg_printf, and calling it will cause PS3 systems to hang.

Remove all debugging statements from ps3_mm_region_destroy() and
ps3_mm_vas_destroy() and replace any error reporting with calls
to lv1_panic.

With this change builds with 'DEBUG' defined will not cause kexec
reboots to hang, and builds with 'DEBUG' defined or not will end
in lv1_panic if an error is encountered.

Signed-off-by: Geoff Levand <geoff@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/7325c4af2b4c989c19d6a26b90b1fec9c0615ddf.1589049250.git.geoff@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/ps3/mm.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index b0f34663b1ae..19bae78b1f25 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -212,13 +212,14 @@ void ps3_mm_vas_destroy(void)
 {
 	int result;
 
-	DBG("%s:%d: map.vas_id    = %llu\n", __func__, __LINE__, map.vas_id);
-
 	if (map.vas_id) {
 		result = lv1_select_virtual_address_space(0);
-		BUG_ON(result);
-		result = lv1_destruct_virtual_address_space(map.vas_id);
-		BUG_ON(result);
+		result += lv1_destruct_virtual_address_space(map.vas_id);
+
+		if (result) {
+			lv1_panic(0);
+		}
+
 		map.vas_id = 0;
 	}
 }
@@ -316,19 +317,20 @@ static void ps3_mm_region_destroy(struct mem_region *r)
 	int result;
 
 	if (!r->destroy) {
-		pr_info("%s:%d: Not destroying high region: %llxh %llxh\n",
-			__func__, __LINE__, r->base, r->size);
 		return;
 	}
 
-	DBG("%s:%d: r->base = %llxh\n", __func__, __LINE__, r->base);
-
 	if (r->base) {
 		result = lv1_release_memory(r->base);
-		BUG_ON(result);
+
+		if (result) {
+			lv1_panic(0);
+		}
+
 		r->size = r->base = r->offset = 0;
 		map.total = map.rm.size;
 	}
+
 	ps3_mm_set_repository_highmem(NULL);
 }
 
-- 
2.25.1

