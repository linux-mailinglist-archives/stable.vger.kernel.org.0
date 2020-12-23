Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F512E143C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgLWCWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgLWCWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D4FA23340;
        Wed, 23 Dec 2020 02:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690133;
        bh=jy51iq8t1S2+P1FuN/O4BSiNfHKgD0DwphlEPREaxBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o43szrpZ15/qr1AaF2Eokroo6BOwytBFBt1EKYt/ePa0JyjqwE/wo9HIuPyqs0zrB
         NxR3nhRO8DygjYb+sz3noGQ5Y7ATXOH+83mAzuwFv40BH6SQJQFFafE54pMH5G/iOK
         GxnII9cYarK3PypwdXkMjfnUysDXnBAAzeo/UrHWe4VUMrzAWzrPfhiENEgcCVp5pg
         Uh5qquukdTnDkYtIFmuIuRYTX/CMa+ZEGyFr70ksaAn5wCU7x4ot/wCQLUZnsDyviI
         Z3Q0P0FmXHUQaedDXej6SMI/4ZcAl3r6njJ3sMjv7FVCvQvCNGVJAZIp9xplOyAV3e
         h68fty/R+npJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriele Paoloni <gabriele.paoloni@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 56/87] x86/mce: Panic for LMCE only if mca_cfg.tolerant < 3
Date:   Tue, 22 Dec 2020 21:20:32 -0500
Message-Id: <20201223022103.2792705-56-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index 2a13468f87739..c0f71b731d4b3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1294,7 +1294,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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

