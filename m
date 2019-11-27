Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3837B10BAC9
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbfK0VGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732441AbfK0VGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A79121843;
        Wed, 27 Nov 2019 21:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888794;
        bh=zBhu2+KdYMb3Yub8SsyOlnjWpHgy8s+5nopaN6TD0kU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y73nsRcdho1bkvi4Hx6fHZhnDHTyDVYSa9HhLqZKlRpaRBIE9BiXwO9UaY3+TB/N5
         d15NYYYL6jRm8+RpGo4YE1WhrH5bqDKM9kbZo5T/z/tXFgrN5ctjhEERUyF8dKSWHl
         xQbx8mKWP7Dc4K2ilsIj4TeytaLmnvtm21UxdiJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 4.19 271/306] x86/doublefault/32: Fix stack canaries in the double fault handler
Date:   Wed, 27 Nov 2019 21:32:01 +0100
Message-Id: <20191127203134.623566738@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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


