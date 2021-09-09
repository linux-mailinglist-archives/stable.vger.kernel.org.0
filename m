Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018D0405708
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357241AbhIIN3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358419AbhIINHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B110632AF;
        Thu,  9 Sep 2021 12:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188841;
        bh=26DpxREAUW4RnhxRwr/LD/ekH0ARh3OLBDizhE3yZ2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJ8QtSjqw7zHSkszIYOPS5m/xVmimV7dRI9aQ8mpp8w63HdjtLQ3o98cS/HLOwwnH
         rBZCogT3jRhRvI37qKfRCdXEmizJGtO2zFnPMJb5scF+0enZx9M8ry9GsDdHmbPP69
         RCBd9+6uHKG3mweTPpMHu329bTj0I7yCXVC/y0L71JhiIbHprvuBg9y+yzgGcvnUm4
         QhrEO/P29or7Wuu5gcG8CCKgew5yAcaWkl+pLFAFd/kCNsNOZz6XYBlddUlYtmimCt
         vcrpQ5iWaO5DHp9Vd8o3UTE3VScj5KLLJVtFNGrzqe2YfwUv0+jApbrry25ndPBMRd
         E42yKZNBCsz4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 20/48] s390/jump_label: print real address in a case of a jump label bug
Date:   Thu,  9 Sep 2021 07:59:47 -0400
Message-Id: <20210909120015.150411-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909120015.150411-1-sashal@kernel.org>
References: <20210909120015.150411-1-sashal@kernel.org>
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
index 083b05f5f5ab..cbc187706648 100644
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

