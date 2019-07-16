Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAE76A5DB
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731824AbfGPJtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 05:49:31 -0400
Received: from smtpbgeu1.qq.com ([52.59.177.22]:40718 "EHLO smtpbgeu1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732469AbfGPJta (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 05:49:30 -0400
X-QQ-mid: bizesmtp11t1563270563t6pzi57p
Received: from localhost.localdomain (unknown [218.76.23.26])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 16 Jul 2019 17:49:21 +0800 (CST)
X-QQ-SSF: 014000000000004066F2B00A0000000
X-QQ-FEAT: y3iK4Lsvf4AgzeHG1eoRNlgqi3lNiSY+UQRXzLFi+xFMajHRK1SM3JDZDuqCn
        6FezfiKISF5+27BnnyHObXQ+Ly18o/vT/fUTvU47lCUoT14fi1ow65diY/wKauaT6CoacvR
        ocMao1Q3edVGQEZ1KWKmre9CsBM3CKYj9p6u7AqlgyJBxIazwc7xKDY/2zY6N4QGKTLXfAo
        jJANm5jYFamL2hFtn7RDHdBnYSAMT8mPPfJ7/HrfzarAsMMT5cQlixYWOxEMob7FOaJNkel
        p0PWq9EONgXST4y4gbErjOoD+X2vh+lon3Ia57V7/wYX/qcgs0NerMCwCZHQzYbltLxA==
X-QQ-GoodBg: 2
From:   weirongguang <weirongguang@kylinos.cn>
To:     liuyun01@kylinos.cn
Cc:     nh@kylinos.cn, Michael Weiser <michael.weiser@gmx.de>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juerg Haefliger <juergh@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: [PATCH] arm64: Disable unhandled signal log messages by default
Date:   Tue, 16 Jul 2019 17:49:13 +0800
Message-Id: <1563270553-96580-1-git-send-email-weirongguang@kylinos.cn>
X-Mailer: git-send-email 2.7.4
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign1
X-QQ-Bgrelay: 1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Weiser <michael.weiser@gmx.de>

BugLink: http://bugs.launchpad.net/bugs/1762453

commit 5ee39a71fd89ab7240c5339d04161c44a8e03269 upstream.

aarch64 unhandled signal kernel messages are very verbose, suggesting
them to be more of a debugging aid:

sigsegv[33]: unhandled level 2 translation fault (11) at 0x00000000, esr
0x92000046, in sigsegv[400000+71000]
CPU: 1 PID: 33 Comm: sigsegv Tainted: G        W        4.15.0-rc3+ #3
Hardware name: linux,dummy-virt (DT)
pstate: 60000000 (nZCv daif -PAN -UAO)
pc : 0x4003f4
lr : 0x4006bc
sp : 0000fffffe94a060
x29: 0000fffffe94a070 x28: 0000000000000000
x27: 0000000000000000 x26: 0000000000000000
x25: 0000000000000000 x24: 00000000004001b0
x23: 0000000000486ac8 x22: 00000000004001c8
x21: 0000000000000000 x20: 0000000000400be8
x19: 0000000000400b30 x18: 0000000000484728
x17: 000000000865ffc8 x16: 000000000000270f
x15: 00000000000000b0 x14: 0000000000000002
x13: 0000000000000001 x12: 0000000000000000
x11: 0000000000000000 x10: 0008000020008008
x9 : 000000000000000f x8 : ffffffffffffffff
x7 : 0004000000000000 x6 : ffffffffffffffff
x5 : 0000000000000000 x4 : 0000000000000000
x3 : 00000000004003e4 x2 : 0000fffffe94a1e8
x1 : 000000000000000a x0 : 0000000000000000

Disable them by default, so they can be enabled using
/proc/sys/debug/exception-trace.

Cc: <stable@vger.kernel.org>
Signed-off-by: Michael Weiser <michael.weiser@gmx.de>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Juerg Haefliger <juergh@canonical.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 arch/arm64/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 3b653d5..2423501 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -49,7 +49,7 @@ static const char *handler[]= {
 	"Error"
 };
 
-int show_unhandled_signals = 1;
+int show_unhandled_signals = 0;
 
 /*
  * Dump out the contents of some memory nicely...
-- 
2.7.4



