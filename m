Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B902267BF
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387566AbgGTQOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388250AbgGTQOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6BA62064B;
        Mon, 20 Jul 2020 16:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261661;
        bh=eW2KrhQqTzX7xP0QopsTINkoMeHdMEn+TwYcjkFAGrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogtgLM+BaCoA7cbZbKwax+e6FhtXegHrE8WJGGwzVZnU6ZyssRJrVjUnLEIWTeLdt
         IsaGgjMIFkqhWGqGHtRvVEimuO72432JJ7H1yBanskpETaNpkwXz5DdbUMwoOD4uz8
         ghGe+05cD2Taj2sLS3ZLPcSO0osxVv2imkRCnfPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Schwab <schwab@suse.de>,
        Anup Patel <anup@brainfault.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.7 196/244] riscv: use 16KB kernel stack on 64-bit
Date:   Mon, 20 Jul 2020 17:37:47 +0200
Message-Id: <20200720152835.169511819@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Schwab <schwab@suse.de>

commit 0cac21b02ba5f3095fd2dcc77c26a25a0b2432ed upstream.

With the current 8KB stack size there are frequent overflows in a 64-bit
configuration.  We may split IRQ stacks off in the future, but this fixes a
number of issues right now.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
[Palmer: mention irqstack in the commit text]
Fixes: 7db91e57a0ac ("RISC-V: Task implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/riscv/include/asm/thread_info.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -12,7 +12,11 @@
 #include <linux/const.h>
 
 /* thread information allocation */
+#ifdef CONFIG_64BIT
+#define THREAD_SIZE_ORDER	(2)
+#else
 #define THREAD_SIZE_ORDER	(1)
+#endif
 #define THREAD_SIZE		(PAGE_SIZE << THREAD_SIZE_ORDER)
 
 #ifndef __ASSEMBLY__


