Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7874E26AEFF
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 22:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgIOU44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 16:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbgIOU4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 16:56:25 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26D18206C9;
        Tue, 15 Sep 2020 20:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600203360;
        bh=e5wNj+TCgI1KVAWJ00feekmiZXlky3JI18dAo3ntG2I=;
        h=From:To:Cc:Subject:Date:From;
        b=HrmIUB9YQohGabbESRYmDgPAoi6yUolq50lxkuEhg7GdyaGJC1r//HHAsDjGzg40g
         tZCwGG/pmKfSXnHl7zLb6Xm5LW+6muzWxtB/30+Zp+5fIq4R0tmoRqS4Jr1IrRJKIA
         ESSgVA8C7YnRj65EoiqqVK/8CwXVHXXUAvCSZdD8=
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Bill Wendling <morbo@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Greg Thelen <gthelen@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] x86/smap: Fix the smap_save() asm
Date:   Tue, 15 Sep 2020 13:55:58 -0700
Message-Id: <9f513eef618b6e72a088cc8b2787496f190d1c2d.1600203307.git.luto@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The old smap_save() code was:

  pushf
  pop %0

with %0 defined by an "=rm" constraint.  This is fine if the
compiler picked the register option, but it was incorrect with an
%rsp-relative memory operand.  With some intentional abuse, I can
get both gcc and clang to generate code along these lines:

  pushfq
  popq 0x8(%rsp)
  mov 0x8(%rsp),%rax

which is incorrect and will not work as intended.

Fix it by removing the memory option.  This issue is exacerbated by
a clang optimization bug:

  https://bugs.llvm.org/show_bug.cgi?id=47530

Fixes: e74deb11931f ("x86/uaccess: Introduce user_access_{save,restore}()")
Cc: stable@vger.kernel.org
Reported-by: Bill Wendling <morbo@google.com> # I think
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/include/asm/smap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/smap.h b/arch/x86/include/asm/smap.h
index 8b58d6975d5d..be6d675ae3ac 100644
--- a/arch/x86/include/asm/smap.h
+++ b/arch/x86/include/asm/smap.h
@@ -61,7 +61,7 @@ static __always_inline unsigned long smap_save(void)
 		      ALTERNATIVE("jmp 1f", "", X86_FEATURE_SMAP)
 		      "pushf; pop %0; " __ASM_CLAC "\n\t"
 		      "1:"
-		      : "=rm" (flags) : : "memory", "cc");
+		      : "=r" (flags) : : "memory", "cc");
 
 	return flags;
 }
-- 
2.26.2

