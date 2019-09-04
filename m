Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F53A8BE4
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfIDQHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732163AbfIDQCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:02:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9322622CF5;
        Wed,  4 Sep 2019 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612921;
        bh=n4O69lSB8nwj9edhHifkBr0eP+IfjyRsjVkeu8i6mzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz8yh6LcYEdqewQCeUwC3sKS8d+tgPTb11xxBjt3xdz3Pd5GO4Q3LjKxeWYJf2NIC
         LtO+kVezy+j4PoNDPeHVqlqT9KGe0G17TFLYvq9AUht9KU9TQDnv/uS0PnHvLb1RP+
         buFRFlwZPGtnjfQQhg/LlTCzPdEpROVxhnmzXgek=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 25/36] x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to silence GCC9 build warning
Date:   Wed,  4 Sep 2019 12:01:11 -0400
Message-Id: <20190904160122.4179-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 42e0e95474fc6076b5cd68cab8fa0340a1797a72 ]

One of the very few warnings I have in the current build comes from
arch/x86/boot/edd.c, where I get the following with a gcc9 build:

   arch/x86/boot/edd.c: In function ‘query_edd’:
   arch/x86/boot/edd.c:148:11: warning: taking address of packed member of ‘struct boot_params’ may result in an unaligned pointer value [-Waddress-of-packed-member]
     148 |  mbrptr = boot_params.edd_mbr_sig_buffer;
         |           ^~~~~~~~~~~

This warning triggers because we throw away all the CFLAGS and then make
a new set for REALMODE_CFLAGS, so the -Wno-address-of-packed-member we
added in the following commit is not present:

  6f303d60534c ("gcc-9: silence 'address-of-packed-member' warning")

The simplest solution for now is to adjust the warning for this version
of CFLAGS as well, but it would definitely make sense to examine whether
REALMODE_CFLAGS could be derived from CFLAGS, so that it picks up changes
in the compiler flags environment automatically.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b4c72da8a7adb..cd596ca609010 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -39,6 +39,7 @@ REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os -D__KERNEL__ \
 
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -ffreestanding)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -fno-stack-protector)
+REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -Wno-address-of-packed-member)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), $(cc_stack_align4))
 export REALMODE_CFLAGS
 
-- 
2.20.1

