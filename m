Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B415E3907D
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731257AbfFGPtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731919AbfFGPtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:49:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F9221473;
        Fri,  7 Jun 2019 15:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922556;
        bh=2nSs+r0mkSEPa95yznIxQ/o92NaL/HmVqSOrpeVP8Es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eM1UZgx36oE5sz1FdkqpYRks8kDd9UjwqTeqPRozT/JntqtNKc4ZmveDVqo9+CKZK
         /qlVTElOjEGoRfnzZcByzmZqzcoaTSRUGHBhG/Ay4hZUy52JY21q1Xi7LDjMPteNhn
         VWsElZSQGlTTpyVwdbz30xWozljdV7ddybcq1QWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 5.1 54/85] arm64: Fix the arm64_personality() syscall wrapper redirection
Date:   Fri,  7 Jun 2019 17:39:39 +0200
Message-Id: <20190607153855.515650835@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit 00377277166bac6939d8f72b429301369acaf2d8 upstream.

Following commit 4378a7d4be30 ("arm64: implement syscall wrappers"), the
syscall function names gained the '__arm64_' prefix. Ensure that we
have the correct #define for redirecting a default syscall through a
wrapper.

Fixes: 4378a7d4be30 ("arm64: implement syscall wrappers")
Cc: <stable@vger.kernel.org> # 4.19.x-
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/sys.c
+++ b/arch/arm64/kernel/sys.c
@@ -50,7 +50,7 @@ SYSCALL_DEFINE1(arm64_personality, unsig
 /*
  * Wrappers to pass the pt_regs argument.
  */
-#define sys_personality		sys_arm64_personality
+#define __arm64_sys_personality		__arm64_sys_arm64_personality
 
 asmlinkage long sys_ni_syscall(const struct pt_regs *);
 #define __arm64_sys_ni_syscall	sys_ni_syscall


