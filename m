Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC9D40E711
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347709AbhIPR2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:28:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348338AbhIPRZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A2F61BF6;
        Thu, 16 Sep 2021 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810677;
        bh=uwA0nUERC+utH2fpcqTViMZbqrZcqe6qSSC9TEOQ8Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEHVdwvTyh3M8Uy3FJDkqSzEcpIttWifuq520mGrJ4wsRKx/DRoKnUDKyJQvKYD7g
         //62ErO/hsstsKf7j0Dbjz192nJf7d1nzI9+MSgIsLM9KaxVh7fG7eKYnQEm+SxMwh
         k12z88mcmlyzd7BnmQHk4ZopCCuXs/IpHB0Qo1hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 227/432] s390/jump_label: print real address in a case of a jump label bug
Date:   Thu, 16 Sep 2021 17:59:36 +0200
Message-Id: <20210916155818.538921806@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



