Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE79F2E12C5
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgLWCYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:24:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgLWCYc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C16F221E5;
        Wed, 23 Dec 2020 02:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690232;
        bh=0r6bWH3isYsQt1YnNm7PhViwFMgHBQ79ofpoSy8Ur9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmtfGRHyo0VxJY+xHsUcnmX72QY/GzTw/vHV4yp3lJ4E63i9DaPMo4SAPKZAZ+U9K
         f6nC2Pzo23LZZgZwHL5JMtfuyX5bhkDghm0Kpd1a8YS4EnXKe0nXUimGMyuzHbo7j1
         a3Hyk706rM8yXSz3OQFGlZl3jJa2x8seSqEmc8R9/kLiUZ9oniqhQRRDaEcLSCeKjx
         Q0n4tcPvk222H8UJQeuTEU+S2vJXT4EhpnEMSU9H/Xt7E2kZAAsDfz0qMnDKoMU1UO
         JtwRogkJD388ESKx/JC8fW/QF/QDI0XVff6xtcwJcEMr8EezWSgqx7vw9As+HCgFmP
         mvlCLJDDW9GwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriele Paoloni <gabriele.paoloni@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 47/66] x86/mce: Panic for LMCE only if mca_cfg.tolerant < 3
Date:   Tue, 22 Dec 2020 21:22:33 -0500
Message-Id: <20201223022253.2793452-47-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriele Paoloni <gabriele.paoloni@intel.com>

[ Upstream commit 3a866b16fd2360a9c4ebf71cfbf7ebfe968c1409 ]

Right now for LMCE, if no_way_out is set, mce_panic() is called
regardless of mca_cfg.tolerant. This is not correct as, if
mca_cfg.tolerant = 3, the code should never panic.

Add that check.

 [ bp: use local ptr 'cfg'. ]

Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20201127161819.3106432-4-gabriele.paoloni@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 95c09db1bba21..b89258cfa15e0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1245,7 +1245,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * to see it will clear it.
 	 */
 	if (lmce) {
-		if (no_way_out)
+		if (no_way_out && cfg->tolerant < 3)
 			mce_panic("Fatal local machine check", &m, msg);
 	} else {
 		order = mce_start(&no_way_out);
-- 
2.27.0

