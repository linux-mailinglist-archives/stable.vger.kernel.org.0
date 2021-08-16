Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBEB3ED608
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239843AbhHPNQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240279AbhHPNPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99C3A632DF;
        Mon, 16 Aug 2021 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119534;
        bh=+2RxgNRlY6jVBAJgrIlgXsu/laS8PTv92YYKfMLbDVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eT9VwGZJ+T+sdq5UEywFJB1Xs/BkxUh5KvNPe2XKXOQmeD6P+hitKZ6VGgXnouojb
         PdZbx4p+CsWgLZSKuOo6nsK9k8KJ/DAk/IDDvLUZAzoyCGjpPaVVP+ZKclhfGtTB+S
         i2H7GSEDkIz0wQY+iKfDH986NGduiEGk84Z9Fvrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changbin Du <changbin.du@gmail.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>
Subject: [PATCH 5.13 030/151] riscv: kexec: do not add -mno-relax flag if compiler doesnt support it
Date:   Mon, 16 Aug 2021 15:01:00 +0200
Message-Id: <20210816125445.069530835@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>

commit 030d6dbf0c2e5fdf23ad29557f0c87a882993e26 upstream.

The RISC-V special option '-mno-relax' which to disable linker relaxations
is supported by GCC8+. For GCC7 and lower versions do not support this
option.

Fixes: fba8a8674f68 ("RISC-V: Add kexec support")
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -11,7 +11,7 @@ endif
 CFLAGS_syscall_table.o	+= $(call cc-option,-Wno-override-init,)
 
 ifdef CONFIG_KEXEC
-AFLAGS_kexec_relocate.o := -mcmodel=medany -mno-relax
+AFLAGS_kexec_relocate.o := -mcmodel=medany $(call cc-option,-mno-relax)
 endif
 
 extra-y += head.o


