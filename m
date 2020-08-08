Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4123FA5F
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgHHXkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgHHXkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:40:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD1C20716;
        Sat,  8 Aug 2020 23:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596930015;
        bh=HVJC6K6oUqf0NTWf0N29VA5BeABOH0MfAAvmGv5LN8s=;
        h=From:To:Cc:Subject:Date:From;
        b=SoRdIUCvM21m4W2RJHnuY8F5Xg9zPD7IDKpCMsEdT/6ZlkWtBkqfaJC36GKxjfGQw
         X7Tjl9hDQbCQiYnvI1qEm7MymVoKU8avCIFCRTNr4zzUD7DdMDlJsKV0BbVd0+B+OQ
         AifbnA+Amt2A+6Vko5rZcclsJ1sJPrEHtQn/htpA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhenzhong Duan <zhenzhong.duan@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 01/14] x86/mce/inject: Fix a wrong assignment of i_mce.status
Date:   Sat,  8 Aug 2020 19:40:00 -0400
Message-Id: <20200808234013.3619541-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenzhong Duan <zhenzhong.duan@gmail.com>

[ Upstream commit 5d7f7d1d5e01c22894dee7c9c9266500478dca99 ]

The original code is a nop as i_mce.status is or'ed with part of itself,
fix it.

Fixes: a1300e505297 ("x86/ras/mce_amd_inj: Trigger deferred and thresholding errors interrupts")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://lkml.kernel.org/r/20200611023238.3830-1-zhenzhong.duan@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index e57b59762f9f5..94aa91b09c288 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -518,7 +518,7 @@ static void do_inject(void)
 	 */
 	if (inj_type == DFR_INT_INJ) {
 		i_mce.status |= MCI_STATUS_DEFERRED;
-		i_mce.status |= (i_mce.status & ~MCI_STATUS_UC);
+		i_mce.status &= ~MCI_STATUS_UC;
 	}
 
 	/*
-- 
2.25.1

