Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C2A405565
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358853AbhIINJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:09:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357525AbhIINBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BDAC63287;
        Thu,  9 Sep 2021 11:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188768;
        bh=7Wns3l9gX+H590DCvppk6lTmRGB+Hss0HwLW9cHwN+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbjS3rNzN2YCMQ2j9j7OZ6HuKM4Mxw+8scrbcU9BnIY7+5SjrAhmTVAPv31XvZyIZ
         ihCcN5ly3ng2GaxpuaBHi27qMTX1Bp9QAJkciB4yz9EoOwohf0nQ0PziiIhmDuRzQP
         lU9FOyVBgOLJE4Up5NCGReVC1Us0VS9SH6D8rJXB58IuM5m/YSjJobW2yhmClAEyUB
         IDl7jGo/lK0LQd3bPM/oLWMTGn4y51KHPC0FaNeOxGOeSI0+qn3qrNPL4TDsvXMQeE
         yIMF7WCUzntccVJGXHT3dy160I2zB4jr9rUnPiojkjpiSNfkfmzVq/tHMMO0LyGhaM
         Z3z5eCD4Fn0fA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 22/59] s390/jump_label: print real address in a case of a jump label bug
Date:   Thu,  9 Sep 2021 07:58:23 -0400
Message-Id: <20210909115900.149795-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 5492886c14744d239e87f1b0b774b5a341e755cc ]

In case of a jump label print the real address of the piece of code
where a mismatch was detected. This is right before the system panics,
so there is nothing revealed.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index 43f8430fb67d..608b363cd35b 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -43,7 +43,7 @@ static void jump_label_bug(struct jump_entry *entry, struct insn *expected,
 	unsigned char *ipe = (unsigned char *)expected;
 	unsigned char *ipn = (unsigned char *)new;
 
-	pr_emerg("Jump label code mismatch at %pS [%p]\n", ipc, ipc);
+	pr_emerg("Jump label code mismatch at %pS [%px]\n", ipc, ipc);
 	pr_emerg("Found:    %6ph\n", ipc);
 	pr_emerg("Expected: %6ph\n", ipe);
 	pr_emerg("New:      %6ph\n", ipn);
-- 
2.30.2

