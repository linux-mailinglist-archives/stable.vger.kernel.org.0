Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07B72FAAB1
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393968AbhARTyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390223AbhARLhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D13AD2253A;
        Mon, 18 Jan 2021 11:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969770;
        bh=PGVt/uwhb/VpQsf7HIsOOMkO7FiMHcLIxoVXDsofli8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5O+CXnagIKUhL2v/Uc3G1iMzOeI80xxT59GrWyv345wlSlg8pLt3UuOA1mdl8E57
         n/fPQIEeBlD6xPH0GyLL0jaIne0jEkinCeZEDOWlTv2c8QvNY7WEsTGnH9uIX+UxpF
         +Cv36p55GMyVElGN938S9Kbyk3QrV0uGpoGAk7/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.19 06/43] MIPS: relocatable: fix possible boot hangup with KASLR enabled
Date:   Mon, 18 Jan 2021 12:34:29 +0100
Message-Id: <20210118113335.258863477@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
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


