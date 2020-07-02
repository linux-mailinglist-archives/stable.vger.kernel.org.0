Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93D2211905
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 03:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgGBBav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 21:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729286AbgGBB0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 21:26:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECAC320748;
        Thu,  2 Jul 2020 01:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653207;
        bh=6t0304VVq8qHRtF3VlLkSQavf4nL9jYUuZhfGtHtCTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQJXIB22tVDmNt3JankG873a+wVGMOC+2tA/IsTQYo6QxK35Sy5mu5hlAq8T28yYj
         q/NqbNu4PMBWoSu1YeTdNjhMSIcgjA1PItQVDWYwebAPaRpwZ1kdi4DujCx3wfgukn
         DtGU3cQlkJZ93o9AxnjNWCvcAqPkuPmyrgpYWiSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Marco Elver <elver@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 26/27] x86/entry: Increase entry_stack size to a full page
Date:   Wed,  1 Jul 2020 21:26:14 -0400
Message-Id: <20200702012615.2701532-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012615.2701532-1-sashal@kernel.org>
References: <20200702012615.2701532-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit c7aadc09321d8f9a1d3bd1e6d8a47222ecddf6c5 ]

Marco crashed in bad_iret with a Clang11/KCSAN build due to
overflowing the stack. Now that we run C code on it, expand it to a
full page.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Reported-by: Marco Elver <elver@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Lai Jiangshan <jiangshanlai@gmail.com>
Tested-by: Marco Elver <elver@google.com>
Link: https://lkml.kernel.org/r/20200618144801.819246178@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index efb44bd3a7140..0f750e7b24071 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -336,7 +336,7 @@ struct x86_hw_tss {
 #define INVALID_IO_BITMAP_OFFSET	0x8000
 
 struct entry_stack {
-	unsigned long		words[64];
+	char	stack[PAGE_SIZE];
 };
 
 struct entry_stack_page {
-- 
2.25.1

