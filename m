Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2FC20D4A2
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbgF2TKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730406AbgF2TKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:10:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95D54254D1;
        Mon, 29 Jun 2020 15:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446028;
        bh=3Ob8pXuAG12RcidzX5/UkCv6xb4eoYNzwyVZ7XKkcCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttiXW4FFOdSW+1kouNdyYm+Ay3CIeMmS7dBbFotKhmHWIq8kdG2YZSU8NxOcGqCpz
         WMZoybw+UwyKz9D8zrNHgMK9PY2zAze0iKPCTKmd509NXHVblqj0vYQO9dM3/hgher
         Q0rqRH6yNwoxLPiH6wYJ47YnR1Fh0yAtLXou4/r4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 034/135] powerpc/ps3: Fix kexec shutdown hang
Date:   Mon, 29 Jun 2020 11:51:28 -0400
Message-Id: <20200629155309.2495516-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
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
index b0f34663b1aec..19bae78b1f25b 100644
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

