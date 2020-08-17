Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26534246953
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgHQPUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729193AbgHQPTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:19:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64ED720729;
        Mon, 17 Aug 2020 15:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677553;
        bh=F592JwkZMMRW6U976eGgKBJ9UP2MyAhBL78uU1iPJ+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4Fk4EoYgk/uhGCqvGN1QOxrtni1b/PbF5Jt/41cTj2sbKPq2/tVP7GwoPosMg9Qr
         dq5VGU3hqbgxGK0MMClAeyI8wco7cCNDbuGz5bJIBlnqNDXsAGYE2LOsDzAp5XY32D
         ysilwQ4lnmfD/y9JL/bbkt10OXEdw/3abvVV30PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammy Yi <ammy.yi@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Chao Qin <chao.qin@intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 008/464] perf/x86/intel/uncore: Fix oops when counting IMC uncore events on some TGL
Date:   Mon, 17 Aug 2020 17:09:21 +0200
Message-Id: <20200817143834.149381289@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



