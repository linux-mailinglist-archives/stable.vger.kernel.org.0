Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4ADC4057CE
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354928AbhIINmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356440AbhIIMzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB5EA613AD;
        Thu,  9 Sep 2021 11:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188676;
        bh=pPUTDhlbhoWxCecJxjTKaCYpbhlU/dyhrWccM8e4UF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD7POMwFN4HIg89gZDHyiowzixXPh36OyoQA0ciAQrfolpj06FtqgdzEc23Q3a/cs
         xg9fWdgmv8Kzwrx60dPr5/bToSvfu2IiXvWwu86W26eas1usyzsiLPg9OPrms/Arlc
         RD23mlplTKN4Ku/g28PsfBR7hTUxfqpQbXxz5SSJJ5hUcQ9np3ibaT1Xv7aFLcM5aK
         zcs0vp0twUxLjxxiZ8ihUSEXO9fKCB/dBhU+DJPiwQ3U4BuWyPVkoVyTI8/A2qVaQj
         igXi14bBRMU99Z2P5YnP7BFyooNf0rB9Mx4Jlh6Xly7VRSXTAEBgJQJGNnQrHqeH2f
         2L+w02QlnKrqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 24/74] s390/jump_label: print real address in a case of a jump label bug
Date:   Thu,  9 Sep 2021 07:56:36 -0400
Message-Id: <20210909115726.149004-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index 68f415e334a5..10009a0cdb37 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -41,7 +41,7 @@ static void jump_label_bug(struct jump_entry *entry, struct insn *expected,
 	unsigned char *ipe = (unsigned char *)expected;
 	unsigned char *ipn = (unsigned char *)new;
 
-	pr_emerg("Jump label code mismatch at %pS [%p]\n", ipc, ipc);
+	pr_emerg("Jump label code mismatch at %pS [%px]\n", ipc, ipc);
 	pr_emerg("Found:    %6ph\n", ipc);
 	pr_emerg("Expected: %6ph\n", ipe);
 	pr_emerg("New:      %6ph\n", ipn);
-- 
2.30.2

