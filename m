Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953E0246A21
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgHQPam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730004AbgHQPak (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:30:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A867722D03;
        Mon, 17 Aug 2020 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678239;
        bh=0JfNETjq/XTA0zMeFA6Xk35P+x0qg/r5ZflzwEjc7k8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujRFCF/nodLLORL5HgnqvLLKD5u2c3ldqlunD5XYGkyX21W6iyO+559tgVd1IJ9KZ
         RomcI1qWNu7o1ENRykLp9crz1TNZYCBz82IYQ6jQl40nIqLfessJDRdjSUsO+StOoj
         vsIiAOdkMkesIvkXz6vspX+D6SFoniPmGKmQnKD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 266/464] powerpc/perf: Fix missing is_sier_aviable() during build
Date:   Mon, 17 Aug 2020 17:13:39 +0200
Message-Id: <20200817143846.528801182@linuxfoundation.org>
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

From: Madhavan Srinivasan <maddy@linux.ibm.com>

[ Upstream commit 3c9450c053f88e525b2db1e6990cdf34d14e7696 ]

Compilation error:
  arch/powerpc/perf/perf_regs.c:80:undefined reference to `.is_sier_available'

Currently is_sier_available() is part of core-book3s.c, which is added
to build based on CONFIG_PPC_PERF_CTRS.

A config with CONFIG_PERF_EVENTS and without CONFIG_PPC_PERF_CTRS will
have a build break because of missing is_sier_available().

In practice it only breaks when CONFIG_FSL_EMB_PERF_EVENT=n because
that also guards the usage of is_sier_available(). That only happens
with CONFIG_PPC_BOOK3E_64=y and CONFIG_FSL_SOC_BOOKE=n.

Patch adds is_sier_available() in asm/perf_event.h to fix the build
break for configs missing CONFIG_PPC_PERF_CTRS.

Fixes: 333804dc3b7a ("powerpc/perf: Update perf_regs structure to include SIER")
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
[mpe: Add detail about CONFIG_FSL_SOC_BOOKE]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200614083604.302611-1-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/perf_event.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/include/asm/perf_event.h b/arch/powerpc/include/asm/perf_event.h
index eed3954082fa2..1e8b2e1ec1db6 100644
--- a/arch/powerpc/include/asm/perf_event.h
+++ b/arch/powerpc/include/asm/perf_event.h
@@ -12,6 +12,8 @@
 
 #ifdef CONFIG_PPC_PERF_CTRS
 #include <asm/perf_event_server.h>
+#else
+static inline bool is_sier_available(void) { return false; }
 #endif
 
 #ifdef CONFIG_FSL_EMB_PERF_EVENT
-- 
2.25.1



