Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E872810BDD7
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbfK0Uxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbfK0Uxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:53:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 714612068E;
        Wed, 27 Nov 2019 20:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888028;
        bh=zBhu2+KdYMb3Yub8SsyOlnjWpHgy8s+5nopaN6TD0kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1rX2pSxSdBay+8ZqOJ3ISnIAeWk5NJMbb7H63yKEmohG566iwGHQcLDXPCQJtObeb
         WTtj50DKCAJl9AvholZAtXwm+rAgGFUhjAW8eNJNLc2yJmGiRV/l3scxrCsKLGHxQy
         VNv1sNHVsIO0r0b/yAzj6f/Rfxxht8G21Bo1cG1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 4.14 181/211] x86/doublefault/32: Fix stack canaries in the double fault handler
Date:   Wed, 27 Nov 2019 21:31:54 +0100
Message-Id: <20191127203110.894026448@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 3580d0b29cab08483f84a16ce6a1151a1013695f upstream.

The double fault TSS was missing GS setup, which is needed for stack
canaries to work.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/doublefault.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/doublefault.c
+++ b/arch/x86/kernel/doublefault.c
@@ -65,6 +65,9 @@ struct x86_hw_tss doublefault_tss __cach
 	.ss		= __KERNEL_DS,
 	.ds		= __USER_DS,
 	.fs		= __KERNEL_PERCPU,
+#ifndef CONFIG_X86_32_LAZY_GS
+	.gs		= __KERNEL_STACK_CANARY,
+#endif
 
 	.__cr3		= __pa_nodebug(swapper_pg_dir),
 };


