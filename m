Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFB9328BDE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239878AbhCASlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:41:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240128AbhCASgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:36:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2520365268;
        Mon,  1 Mar 2021 17:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619791;
        bh=VhUdqMxmlCMUNY4o4P0+g6ExMWzhed8BTRHfI5lN4LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDptCMuvHeZufZ+BGe/3RaEUNVQgOALobeucBvGhf3DYZZbHXor0LuQGn9dw39IZJ
         lV0h5+fwRL7ufCgEFFFWTdbJzKgwD7FxwqqDoTvSokRxsXEacaxZft5a1ZQj0v/4Wy
         DYgUwcu9+FIQoKBj496I29sljOZGsBZBQL3bIRX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank van der Linden <fllinden@amazon.com>,
        Shaoying Xu <shaoyi@amazon.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 582/663] arm64 module: set plt* section addresses to 0x0
Date:   Mon,  1 Mar 2021 17:13:50 +0100
Message-Id: <20210301161210.661046412@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/module.lds.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -1,7 +1,7 @@
 #ifdef CONFIG_ARM64_MODULE_PLTS
 SECTIONS {
-	.plt (NOLOAD) : { BYTE(0) }
-	.init.plt (NOLOAD) : { BYTE(0) }
-	.text.ftrace_trampoline (NOLOAD) : { BYTE(0) }
+	.plt 0 (NOLOAD) : { BYTE(0) }
+	.init.plt 0 (NOLOAD) : { BYTE(0) }
+	.text.ftrace_trampoline 0 (NOLOAD) : { BYTE(0) }
 }
 #endif


