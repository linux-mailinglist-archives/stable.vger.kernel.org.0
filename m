Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A712D577BE
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfF0AiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbfF0AiC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:38:02 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D42BE2187F;
        Thu, 27 Jun 2019 00:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595881;
        bh=ukyT0zWO949yq54aqPCDMCmxrnUPIEiL8DdNMkXKvSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1A0+Y/ld+SeWEylhkeaRE23tMv5+M6d5RkiRihhOB9rf2X8WUT59s1gj5W4HWCz8
         Jt0PZWtnDUmsB2Cptj92nqF6ZrZBc2O96MnNaVlJUzdjd+LXmKhzizjMeYXKhQxEW6
         WVh49DbCHgT+KrXTAEZ/WS/QyJCDpAHHQL3Bg0W8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Hu <nickhu@andestech.com>, Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 34/60] riscv: Fix udelay in RV32.
Date:   Wed, 26 Jun 2019 20:35:49 -0400
Message-Id: <20190627003616.20767-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Hu <nickhu@andestech.com>

[ Upstream commit d0e1f2110a5eeb6e410b2dd37d98bc5b30da7bc7 ]

In RV32, udelay would delay the wrong cycle. When it shifts right
"UDELAY_SHIFT" bits, it either delays 0 cycle or 1 cycle. It only works
correctly in RV64. Because the 'ucycles' always needs to be 64 bits
variable.

Signed-off-by: Nick Hu <nickhu@andestech.com>
Reviewed-by: Palmer Dabbelt <palmer@sifive.com>
[paul.walmsley@sifive.com: fixed minor spelling error]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/lib/delay.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/lib/delay.c b/arch/riscv/lib/delay.c
index dce8ae24c6d3..ee6853c1e341 100644
--- a/arch/riscv/lib/delay.c
+++ b/arch/riscv/lib/delay.c
@@ -88,7 +88,7 @@ EXPORT_SYMBOL(__delay);
 
 void udelay(unsigned long usecs)
 {
-	unsigned long ucycles = usecs * lpj_fine * UDELAY_MULT;
+	u64 ucycles = (u64)usecs * lpj_fine * UDELAY_MULT;
 
 	if (unlikely(usecs > MAX_UDELAY_US)) {
 		__delay((u64)usecs * riscv_timebase / 1000000ULL);
-- 
2.20.1

