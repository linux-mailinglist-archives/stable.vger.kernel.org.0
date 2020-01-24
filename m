Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E1F1486DC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403852AbgAXOTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:39072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403846AbgAXOTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:19:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE1222527;
        Fri, 24 Jan 2020 14:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875540;
        bh=KhVlt+qljKi5E9ciLNaFzqJlnZU1bRRfabfVh+WYVA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bIThUOE17ixH+9TFK8+PaswlkjY3c3oY7Ktmi3ZP/R/kLdUiVptT5m6MZqm8XB0i
         Sp1mEwITMNEM2yG1LoLonTta7R+XwVyLKHLEm7QiNW1X+ToyxwbomJ9a7+4KKowsCm
         VOrMHJ1Bkw78KqDrkAtPRxm3BKUWPK+PpeaMHhk8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Rudo <prudo@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 037/107] s390/setup: Fix secure ipl message
Date:   Fri, 24 Jan 2020 09:17:07 -0500
Message-Id: <20200124141817.28793-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

[ Upstream commit 40260b01d029ba374637838213af500e03305326 ]

The new machine loader on z15 always creates an IPL Report block and
thus sets the IPL_PL_FLAG_IPLSR even when secure boot is disabled. This
causes the wrong message being printed at boot. Fix this by checking for
IPL_PL_FLAG_SIPL instead.

Fixes: 9641b8cc733f ("s390/ipl: read IPL report at early boot")
Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 3ff291bc63b7e..b95e6fa34cc8e 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1059,7 +1059,7 @@ static void __init log_component_list(void)
 
 	if (!early_ipl_comp_list_addr)
 		return;
-	if (ipl_block.hdr.flags & IPL_PL_FLAG_IPLSR)
+	if (ipl_block.hdr.flags & IPL_PL_FLAG_SIPL)
 		pr_info("Linux is running with Secure-IPL enabled\n");
 	else
 		pr_info("Linux is running with Secure-IPL disabled\n");
-- 
2.20.1

