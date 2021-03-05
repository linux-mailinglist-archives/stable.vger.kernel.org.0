Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04DD32EA49
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbhCEMhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhCEMhS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:37:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65CF665004;
        Fri,  5 Mar 2021 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947838;
        bh=J2D7/x4m0IBsynDiFzOuCySCWoKqTn+QiixGa+F0MUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyIzvZiZ3ahqTLAJwIb1CgUwt1+8lUAYEiv7MhaYXApJj7DgMv10OgYD7tzUyeN53
         289julw0MTmkfE+5vo7OATNqYy5VfwaDx+9TtkOdxtzevmBbRenJFOciB64NVhkaaI
         xGlxqn8ldaNNQEle4URq5KbZhFpoEJXvhcM9BZZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank van der Linden <fllinden@amazon.com>,
        Shaoying Xu <shaoyi@amazon.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 4.19 05/52] arm64 module: set plt* section addresses to 0x0
Date:   Fri,  5 Mar 2021 13:21:36 +0100
Message-Id: <20210305120853.927081823@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaoying Xu <shaoyi@amazon.com>

commit f5c6d0fcf90ce07ee0d686d465b19b247ebd5ed7 upstream.

These plt* and .text.ftrace_trampoline sections specified for arm64 have
non-zero addressses. Non-zero section addresses in a relocatable ELF would
confuse GDB when it tries to compute the section offsets and it ends up
printing wrong symbol addresses. Therefore, set them to zero, which mirrors
the change in commit 5d8591bc0fba ("module: set ksymtab/kcrctab* section
addresses to 0x0").

Reported-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210216183234.GA23876@amazon.com
Signed-off-by: Will Deacon <will@kernel.org>
[shaoyi@amazon.com: made same changes in arch/arm64/kernel/module.lds for 5.4]
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
arch/arm64/include/asm/module.lds.h was renamed from arch/arm64/kernel/module.lds
by commit 596b0474d3d9 ("kbuild: preprocess module linker script") since v5.10.
Therefore, made same changes in arch/arm64/kernel/module.lds for 5.4. 

 arch/arm64/kernel/module.lds |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/module.lds
+++ b/arch/arm64/kernel/module.lds
@@ -1,5 +1,5 @@
 SECTIONS {
-	.plt (NOLOAD) : { BYTE(0) }
-	.init.plt (NOLOAD) : { BYTE(0) }
-	.text.ftrace_trampoline (NOLOAD) : { BYTE(0) }
+	.plt 0 (NOLOAD) : { BYTE(0) }
+	.init.plt 0 (NOLOAD) : { BYTE(0) }
+	.text.ftrace_trampoline 0 (NOLOAD) : { BYTE(0) }
 }


