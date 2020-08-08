Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8BA23FB48
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgHHXsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgHHXh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E881E20791;
        Sat,  8 Aug 2020 23:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929848;
        bh=F592JwkZMMRW6U976eGgKBJ9UP2MyAhBL78uU1iPJ+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsJfSGvo2ipKlmXK6gBF7Jws1S8iz+aEMdYnp1nzHxduQHebYGBhUvKWS1vTtKRm3
         joATZ+mISFMiwa2mXp/nEmhsk/xkE0023HpE78QYYN2eGqSq8pfokm8en81Bnm9tXf
         7hHCuqdafxmk96g4wVWwI1SSOsokn6mFmz/5JE3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>, Ammy Yi <ammy.yi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chao Qin <chao.qin@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 03/58] perf/x86/intel/uncore: Fix oops when counting IMC uncore events on some TGL
Date:   Sat,  8 Aug 2020 19:36:29 -0400
Message-Id: <20200808233724.3618168-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 2af834f1faab3f1e218fcbcab70a399121620d62 ]

When counting IMC uncore events on some TGL machines, an oops will be
triggered.
  [ 393.101262] BUG: unable to handle page fault for address:
  ffffb45200e15858
  [ 393.101269] #PF: supervisor read access in kernel mode
  [ 393.101271] #PF: error_code(0x0000) - not-present page

Current perf uncore driver still use the IMC MAP SIZE inherited from
SNB, which is 0x6000.
However, the offset of IMC uncore counters is larger than 0x6000,
e.g. 0xd8a0.

Enlarge the IMC MAP SIZE for TGL to 0xe000.

Fixes: fdb64822443e ("perf/x86: Add Intel Tiger Lake uncore support")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Chao Qin <chao.qin@intel.com>
Link: https://lkml.kernel.org/r/1590679169-61823-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index 3de1065eefc44..1038e9f1e3542 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -1085,6 +1085,7 @@ static struct pci_dev *tgl_uncore_get_mc_dev(void)
 }
 
 #define TGL_UNCORE_MMIO_IMC_MEM_OFFSET		0x10000
+#define TGL_UNCORE_PCI_IMC_MAP_SIZE		0xe000
 
 static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
 {
@@ -1112,7 +1113,7 @@ static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
 	addr |= ((resource_size_t)mch_bar << 32);
 #endif
 
-	box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
+	box->io_addr = ioremap(addr, TGL_UNCORE_PCI_IMC_MAP_SIZE);
 }
 
 static struct intel_uncore_ops tgl_uncore_imc_freerunning_ops = {
-- 
2.25.1

