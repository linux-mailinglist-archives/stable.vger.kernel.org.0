Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F9532177C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhBVMtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:49:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231649AbhBVMoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:44:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF99764F53;
        Mon, 22 Feb 2021 12:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997690;
        bh=h6SYKDCBnAdNuZBztfdBNLLqozhp4n4RinLdLaRBMkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJLvyCUOxFcST2FO4++saGJctDW83ieqD5VD1zOMVG/A0pEZM8hF5/8WuvvMLzxvV
         gEkpQtQTGsvMyMHtwsa9km7pohdY9DCO+484pRAMqPXKxEEvnmnVcKwqW8/2vtjx8g
         LS+BFSF2WlTADTgLQo3SDrz/5C/Tjp284oO0ScD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 28/49] h8300: fix PREEMPTION build, TI_PRE_COUNT undefined
Date:   Mon, 22 Feb 2021 13:36:26 +0100
Message-Id: <20210222121027.020016476@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ade9679c159d5bbe14fb7e59e97daf6062872e2b ]

Fix a build error for undefined 'TI_PRE_COUNT' by adding it to
asm-offsets.c.

  h8300-linux-ld: arch/h8300/kernel/entry.o: in function `resume_kernel': (.text+0x29a): undefined reference to `TI_PRE_COUNT'

Link: https://lkml.kernel.org/r/20210212021650.22740-1-rdunlap@infradead.org
Fixes: df2078b8daa7 ("h8300: Low level entry")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/h8300/kernel/asm-offsets.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/h8300/kernel/asm-offsets.c b/arch/h8300/kernel/asm-offsets.c
index dc2d16ce8a0d5..3e33a9844d99a 100644
--- a/arch/h8300/kernel/asm-offsets.c
+++ b/arch/h8300/kernel/asm-offsets.c
@@ -62,6 +62,9 @@ int main(void)
 	OFFSET(TI_FLAGS, thread_info, flags);
 	OFFSET(TI_CPU, thread_info, cpu);
 	OFFSET(TI_PRE, thread_info, preempt_count);
+#ifdef CONFIG_PREEMPTION
+	DEFINE(TI_PRE_COUNT, offsetof(struct thread_info, preempt_count));
+#endif
 
 	return 0;
 }
-- 
2.27.0



