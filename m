Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DD1261D6B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731586AbgIHTgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:36:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730961AbgIHP5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:57:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FE6624054;
        Tue,  8 Sep 2020 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579497;
        bh=Hewy9hQnlnXEm29lpUyfLeAiJpD5m1GoWJ30QLYRv24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhrKV0rFWLJ4XxIU+kMtQF48PTyAGI25cW1WdmneVo1sWYlYL9RJuPWDNxTvSVyRU
         cskUDiM0OQYJvA4UPFQjxoHzGNqOS6PTmWa8H9JpD4lvt1hZEVR00q1PL9FOJEoooh
         Ds44TD64SxoViRdFYdUT1ANe4+k3uX6t5Y8pGlFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Pei <huangpei@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 102/186] MIPS: add missing MSACSR and upper MSA initialization
Date:   Tue,  8 Sep 2020 17:24:04 +0200
Message-Id: <20200908152246.579843615@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit bb06748207cfb1502d11b90325eba7f8c44c9f02 ]

In cc97ab235f3f ("MIPS: Simplify FP context initialization), init_fp_ctx
just initialize the fp/msa context, and own_fp_inatomic just restore
FCSR and 64bit FP regs from it, but miss MSACSR and upper MSA regs for
MSA, so MSACSR and MSA upper regs's value from previous task on current
cpu can leak into current task and cause unpredictable behavior when MSA
context not initialized.

Fixes: cc97ab235f3f ("MIPS: Simplify FP context initialization")
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/traps.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index e664d8b43e72b..2e9d0637591c9 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1286,6 +1286,18 @@ static int enable_restore_fp_context(int msa)
 		err = own_fpu_inatomic(1);
 		if (msa && !err) {
 			enable_msa();
+			/*
+			 * with MSA enabled, userspace can see MSACSR
+			 * and MSA regs, but the values in them are from
+			 * other task before current task, restore them
+			 * from saved fp/msa context
+			 */
+			write_msa_csr(current->thread.fpu.msacsr);
+			/*
+			 * own_fpu_inatomic(1) just restore low 64bit,
+			 * fix the high 64bit
+			 */
+			init_msa_upper();
 			set_thread_flag(TIF_USEDMSA);
 			set_thread_flag(TIF_MSA_CTX_LIVE);
 		}
-- 
2.25.1



