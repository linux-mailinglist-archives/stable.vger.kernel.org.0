Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44261F29A1
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgFIACf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730905AbgFHXWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3815E20814;
        Mon,  8 Jun 2020 23:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658523;
        bh=O6auuTkwi7vwrtwutuGHafNgr5U2Ux5oBVPZFBpv+P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njzl6J8oT/hS42fcscLvdfKaNH5qEF1pq5Skc0NlTjrPkwAUdDrYn12YFAKq6/16J
         38DsXtpUA0R3N7FWtGbKCcFgUc3o/RCIwBAwewEZbvFFOiyqreZZTHYFeRL0giOcDS
         5sHaZgRIhrRrt7kyJEEO5ulY4OCQuqSTW/oeFuuw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YuanJunQing <yuanjunqing66@163.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 149/175] MIPS: Fix IRQ tracing when call handle_fpe() and handle_msa_fpe()
Date:   Mon,  8 Jun 2020 19:18:22 -0400
Message-Id: <20200608231848.3366970-149-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YuanJunQing <yuanjunqing66@163.com>

[ Upstream commit 31e1b3efa802f97a17628dde280006c4cee4ce5e ]

Register "a1" is unsaved in this function,
 when CONFIG_TRACE_IRQFLAGS is enabled,
 the TRACE_IRQS_OFF macro will call trace_hardirqs_off(),
 and this may change register "a1".
 The changed register "a1" as argument will be send
 to do_fpe() and do_msa_fpe().

Signed-off-by: YuanJunQing <yuanjunqing66@163.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/genex.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
index efde27c99414..9c5f8a5d097f 100644
--- a/arch/mips/kernel/genex.S
+++ b/arch/mips/kernel/genex.S
@@ -474,20 +474,20 @@ NESTED(nmi_handler, PT_SIZE, sp)
 	.endm
 
 	.macro	__build_clear_fpe
+	CLI
+	TRACE_IRQS_OFF
 	.set	push
 	/* gas fails to assemble cfc1 for some archs (octeon).*/ \
 	.set	mips1
 	SET_HARDFLOAT
 	cfc1	a1, fcr31
 	.set	pop
-	CLI
-	TRACE_IRQS_OFF
 	.endm
 
 	.macro	__build_clear_msa_fpe
-	_cfcmsa	a1, MSA_CSR
 	CLI
 	TRACE_IRQS_OFF
+	_cfcmsa	a1, MSA_CSR
 	.endm
 
 	.macro	__build_clear_ade
-- 
2.25.1

