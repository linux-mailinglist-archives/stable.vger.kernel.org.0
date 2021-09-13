Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A426409621
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347165AbhIMOsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346642AbhIMOqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:46:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE16263227;
        Mon, 13 Sep 2021 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541530;
        bh=pUKMgRRhubTv8YlIAIeLAWIfKVKabc8WEZ8bBTka+oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1FWDRts7AjgM6o0sn+JzYZPZzcs2tzP6pE0hX0hw1gDJbdnIPY1Vz7wV2qYV43V5
         pkVMq+OGSFFxQFHseBqgQIm5b3CxqjrP6/iVkhKMafW91WAGIO7j4UUO9kSuIP0rVt
         UbF5+ciS1QsDWqtd86KTm5W+BTY1bv2Z41Nwu4VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Arnd Bergmann <arnd@kernel.org>,
        John David Anglin <dave.anglin@bell.net>
Subject: [PATCH 5.14 333/334] parisc: Fix unaligned-access crash in bootloader
Date:   Mon, 13 Sep 2021 15:16:27 +0200
Message-Id: <20210913131124.688441395@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit c42813b71a06a2ff4a155aa87ac609feeab76cf3 upstream.

Kernel v5.14 has various changes to optimize unaligned memory accesses,
e.g. commit 0652035a5794 ("asm-generic: unaligned: remove byteshift helpers").

Those changes triggered an unalignment-exception and thus crashed the
bootloader on parisc because the unaligned "output_len" variable now suddenly
was read word-wise while it was read byte-wise in the past.

Fix this issue by declaring the external output_len variable as char which then
forces the compiler to generate byte-accesses.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: John David Anglin <dave.anglin@bell.net>
Bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102162
Fixes: 8c031ba63f8f ("parisc: Unbreak bootloader due to gcc-7 optimizations")
Fixes: 0652035a5794 ("asm-generic: unaligned: remove byteshift helpers")
Cc: <stable@vger.kernel.org> # v5.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/boot/compressed/misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/boot/compressed/misc.c
+++ b/arch/parisc/boot/compressed/misc.c
@@ -26,7 +26,7 @@
 extern char input_data[];
 extern int input_len;
 /* output_len is inserted by the linker possibly at an unaligned address */
-extern __le32 output_len __aligned(1);
+extern char output_len;
 extern char _text, _end;
 extern char _bss, _ebss;
 extern char _startcode_end;


