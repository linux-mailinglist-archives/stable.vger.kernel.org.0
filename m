Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F53226453
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbgGTPoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730365AbgGTPoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:44:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D01742064B;
        Mon, 20 Jul 2020 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259850;
        bh=P2ysq1NxrLaFk1X+my8dkrWsgOs67+ruXrr9CBrYbDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVtSu0PRIMwqd93+FRyxGO5smh0NjPHIYiaPYJj2j9cHDdxEWGdrlmUP3HcI0wiIs
         wqpUoAIWmeQ85Gt/8c0QhPSkdzNRbpwrjHLsVTnqzLSIysxWE1UUJ4zz3jaMzGiBxU
         9u15pRAG3MQQRRb/Z7qSAa9evMk3LEW77yzb9JCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Marco Elver <elver@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 016/125] x86/entry: Increase entry_stack size to a full page
Date:   Mon, 20 Jul 2020 17:35:55 +0200
Message-Id: <20200720152803.767781285@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6a87eda9691e4..56a89519dc144 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -344,7 +344,7 @@ struct x86_hw_tss {
 #define INVALID_IO_BITMAP_OFFSET	0x8000
 
 struct entry_stack {
-	unsigned long		words[64];
+	char	stack[PAGE_SIZE];
 };
 
 struct entry_stack_page {
-- 
2.25.1



