Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C7B404E41
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344994AbhIIMKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350592AbhIIMIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38B3C619E2;
        Thu,  9 Sep 2021 11:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188079;
        bh=uwA0nUERC+utH2fpcqTViMZbqrZcqe6qSSC9TEOQ8Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lj7oeNDPgsvawAryT9+JcmCeuB+zQ+on65Qqpp0e6TnQpXX/2253BYztU3UD6vyZR
         R7TE9lelNs1W1SUXFvgfnXkRGiD5KGYc4CIbzR5GtKvdHCaWFxO7uVVTWHCXT0nI/3
         9XJEZslGJfhXYmCccG9o7/+2FfBj++Lqk4PsIIA0PWJcOUDVulTu0WRPBO6D06+MWp
         5Ikk8xcNGcYKwaIwM6QMSDA0fvdD67dTIEjL+rJIHAL7DfCvLuNAIL/HJq32ByhdKL
         4iomzSghFHd1W8toxMoQ+ymbKZ4kBRaKwCJALE70AP1yl0nO3YxMfScX850g70nwEv
         8vpYYJ8oFqMxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 065/219] s390/jump_label: print real address in a case of a jump label bug
Date:   Thu,  9 Sep 2021 07:44:01 -0400
Message-Id: <20210909114635.143983-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index ab584e8e3527..9156653b56f6 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -36,7 +36,7 @@ static void jump_label_bug(struct jump_entry *entry, struct insn *expected,
 	unsigned char *ipe = (unsigned char *)expected;
 	unsigned char *ipn = (unsigned char *)new;
 
-	pr_emerg("Jump label code mismatch at %pS [%p]\n", ipc, ipc);
+	pr_emerg("Jump label code mismatch at %pS [%px]\n", ipc, ipc);
 	pr_emerg("Found:    %6ph\n", ipc);
 	pr_emerg("Expected: %6ph\n", ipe);
 	pr_emerg("New:      %6ph\n", ipn);
-- 
2.30.2

