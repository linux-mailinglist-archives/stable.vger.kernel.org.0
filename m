Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD13B5C99
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbfIRG17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730624AbfIRG16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:27:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23BC421925;
        Wed, 18 Sep 2019 06:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568788077;
        bh=txizpSKWNllJpJ8T6Vas/37oGmdhWUzm8YhP+TFhjJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F81BXwTWw0pLqa7hP9Vxn39gQtDGfwshr1XJmXlBKROqwbFNfLtgB/xFvWHEav7Tn
         4Kulvkw3VKxf4GjxJfESzZCPrf0fZDMAiLtzAxme9ItAt60ghbHq2+Uf18yP4m5BX8
         njG/EsO37OrlzpvYuDNGnraPpqWvV+fzpZ8UNvmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.2 85/85] x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to silence GCC9 build warning
Date:   Wed, 18 Sep 2019 08:19:43 +0200
Message-Id: <20190918061238.053565265@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 42e0e95474fc6076b5cd68cab8fa0340a1797a72 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -38,6 +38,7 @@ REALMODE_CFLAGS	:= $(M16_CFLAGS) -g -Os
 
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -ffreestanding)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -fno-stack-protector)
+REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), -Wno-address-of-packed-member)
 REALMODE_CFLAGS += $(call __cc-option, $(CC), $(REALMODE_CFLAGS), $(cc_stack_align4))
 export REALMODE_CFLAGS
 


