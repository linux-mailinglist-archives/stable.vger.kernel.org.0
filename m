Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FF9441823
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhKAJoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233357AbhKAJmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB73D6137E;
        Mon,  1 Nov 2021 09:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758910;
        bh=46AeDbiSnYHpXNQLpRT8vroGbCZSfrLoI5tbgsyJM4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYq60iQ2xyI16tpl/HZwjgCL3xxs/ViJP4tr2iGdhW/yquQgSDlTHFpRSXN0/Nmcn
         G7KKAsYDMeNS51Lif4/x3CAfA7eN7MTVGuiKJiDkQQBNXYFhJ/O1SmCdKRiGw/k6Ai
         u3Pt4bEFrdr3jIbVn5be1x/h1Vr7yTuMEF/96YpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.14 004/125] ARM: 9138/1: fix link warning with XIP + frame-pointer
Date:   Mon,  1 Nov 2021 10:16:17 +0100
Message-Id: <20211101082534.307499698@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 44cc6412e66b2b84544eaf2e14cf1764301e2a80 upstream.

When frame pointers are used instead of the ARM unwinder,
and the kernel is built using clang with an external assembler
and CONFIG_XIP_KERNEL, every file produces two warnings
like:

arm-linux-gnueabi-ld: warning: orphan section `.ARM.extab' from `net/mac802154/util.o' being placed in section `.ARM.extab'
arm-linux-gnueabi-ld: warning: orphan section `.ARM.exidx' from `net/mac802154/util.o' being placed in section `.ARM.exidx'

The same fix was already merged for the normal (non-XIP)

linker script, with a longer description.

Fixes: c39866f268f8 ("arm/build: Always handle .ARM.exidx and .ARM.extab sections")
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/vmlinux-xip.lds.S |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/kernel/vmlinux-xip.lds.S
+++ b/arch/arm/kernel/vmlinux-xip.lds.S
@@ -40,6 +40,10 @@ SECTIONS
 		ARM_DISCARD
 		*(.alt.smp.init)
 		*(.pv_table)
+#ifndef CONFIG_ARM_UNWIND
+		*(.ARM.exidx) *(.ARM.exidx.*)
+		*(.ARM.extab) *(.ARM.extab.*)
+#endif
 	}
 
 	. = XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR);


