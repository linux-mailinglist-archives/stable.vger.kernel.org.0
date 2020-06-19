Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5BE20160D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389912AbgFSQZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389565AbgFSO5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:57:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9599217D8;
        Fri, 19 Jun 2020 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578643;
        bh=MdW3KQHJFjrbPO/7LWBN3FFilQj3utVGrULWCGVyXAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KO3bFyGbfQq7kUn5/kMJZogxMzH26iRlIuTf5lbqeVVjAGszF+L3xUw/LK3CVMrQs
         ryWsuLIzMjqS9Yvs+I61hEGRjqLHIqhvXFUm6Afs1PWbrI1wCvH77PEa7vM3vCuvIc
         RcBk9pu+JWwNBbiX58AOJWujmCawidYZxwlqy6qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Peter Collingbourne <pcc@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fangrui Song <maskray@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/267] efi/libstub/x86: Work around LLVM ELF quirk build regression
Date:   Fri, 19 Jun 2020 16:31:26 +0200
Message-Id: <20200619141653.718551571@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit f77767ed5f4d398b29119563155e4ece2dfeee13 ]

When building the x86 EFI stub with Clang, the libstub Makefile rules
that manipulate the ELF object files may throw an error like:

    STUBCPY drivers/firmware/efi/libstub/efi-stub-helper.stub.o
  strip: drivers/firmware/efi/libstub/efi-stub-helper.stub.o: Failed to find link section for section 10
  objcopy: drivers/firmware/efi/libstub/efi-stub-helper.stub.o: Failed to find link section for section 10

This is the result of a LLVM feature [0] where symbol references are
stored in a LLVM specific .llvm_addrsig section in a non-transparent way,
causing generic ELF tools such as strip or objcopy to choke on them.

So force the compiler not to emit these sections, by passing the
appropriate command line option.

[0] https://sourceware.org/bugzilla/show_bug.cgi?id=23817

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d9845099635e..d3777d754984 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -28,6 +28,7 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   -D__NO_FORTIFY \
 				   $(call cc-option,-ffreestanding) \
 				   $(call cc-option,-fno-stack-protector) \
+				   $(call cc-option,-fno-addrsig) \
 				   -D__DISABLE_EXPORTS
 
 GCOV_PROFILE			:= n
-- 
2.25.1



