Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86421405338
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355839AbhIIMt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:49:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355283AbhIIMpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:45:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82FC363210;
        Thu,  9 Sep 2021 11:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188549;
        bh=uwA0nUERC+utH2fpcqTViMZbqrZcqe6qSSC9TEOQ8Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVo6r7xZViCVr+n/8QXr57RgFa6lgLu5C1PPFfcVI0cd/u3Zfxpkia5v2Phgir/4w
         nWzf7kgOMf5sEGmyWrOY4NbuAAJVJVNvtJXjYFtPe77A9b6zXw+jMmukKmSUrIORz3
         EeO5BKsR2VJ1wIfOwtuwj4jSXY+4OYmu1MUK1ccMBDRW3s5sIAwDIx+tbYiunvwwVB
         kpb6HfZ1ATtNnb5MmH0B57VP2fEDsUPmFgK57wLLMPNuiwbZT+5aU60reUrdDShkFi
         fXVNEh+xPk0+FJ6jKdsXgmTMXUR1BjsCquRBgJViDMDLagsAj7LQ264xUZajGgrFxe
         TSNUKQlDxjlcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 033/109] s390/jump_label: print real address in a case of a jump label bug
Date:   Thu,  9 Sep 2021 07:53:50 -0400
Message-Id: <20210909115507.147917-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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

