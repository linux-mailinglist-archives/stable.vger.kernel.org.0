Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D73A300B88
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbhAVSkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728485AbhAVOSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:18:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C34A23AA1;
        Fri, 22 Jan 2021 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324857;
        bh=PGVt/uwhb/VpQsf7HIsOOMkO7FiMHcLIxoVXDsofli8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmbRYkvA+qVvvFMYAsOg6mJXo/KyrJe/6l/bd+9fK/khtGFCEzLpqcTUuRjtr1vXi
         eWawSdAReeDH4a22SGygquA4ccFNhbzafUjtylyPat6wc965WbVk+bDSMs6FAGvdDT
         tb5YJn1rJyepUiZsy6bp8bVUU9ocH+HLFCGwsQGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.14 04/50] MIPS: relocatable: fix possible boot hangup with KASLR enabled
Date:   Fri, 22 Jan 2021 15:11:45 +0100
Message-Id: <20210122135735.351639218@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

commit 69e976831cd53f9ba304fd20305b2025ecc78eab upstream.

LLVM-built Linux triggered a boot hangup with KASLR enabled.

arch/mips/kernel/relocate.c:get_random_boot() uses linux_banner,
which is a string constant, as a random seed, but accesses it
as an array of unsigned long (in rotate_xor()).
When the address of linux_banner is not aligned to sizeof(long),
such access emits unaligned access exception and hangs the kernel.

Use PTR_ALIGN() to align input address to sizeof(long) and also
align down the input length to prevent possible access-beyond-end.

Fixes: 405bc8fd12f5 ("MIPS: Kernel: Implement KASLR using CONFIG_RELOCATABLE")
Cc: stable@vger.kernel.org # 4.7+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/relocate.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -187,8 +187,14 @@ static int __init relocate_exception_tab
 static inline __init unsigned long rotate_xor(unsigned long hash,
 					      const void *area, size_t size)
 {
-	size_t i;
-	unsigned long *ptr = (unsigned long *)area;
+	const typeof(hash) *ptr = PTR_ALIGN(area, sizeof(hash));
+	size_t diff, i;
+
+	diff = (void *)ptr - area;
+	if (unlikely(size < diff + sizeof(hash)))
+		return hash;
+
+	size = ALIGN_DOWN(size - diff, sizeof(hash));
 
 	for (i = 0; i < size / sizeof(hash); i++) {
 		/* Rotate by odd number of bits and XOR. */


