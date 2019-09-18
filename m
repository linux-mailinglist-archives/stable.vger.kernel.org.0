Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89075B5CDA
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfIRGZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbfIRGZa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9836E21924;
        Wed, 18 Sep 2019 06:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787930;
        bh=wauRTjmGo+4c67cB3j2p7Ym9wqqe6uvtDzztz9dU+UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifcxeVZnhR7JWelXAyZzUTqgjHH+zPH2Fhbum2O7Gqc9vTQ+G/SaGZRmy9uNH8cKe
         FHPfwhNk+qq+VH7JSQ8L162+6IijnwanJl4s1f9lk2v1AAtfAzfplQwZ6g8rEsxoxC
         I2u1ApMt/pRBoQ1adsHNnpyU4nYqGT9+X61oGSBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Chen <deanbo422@gmail.com>,
        Greentime Hu <green.hu@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@pku.edu.cn>,
        Stafford Horne <shorne@gmail.com>,
        Jonas Bonn <jonas@southpole.se>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Ley Foon Tan <lftan@altera.com>,
        Richard Kuo <rkuo@codeaurora.org>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <jacquiot.aurelien@gmail.com>,
        Guo Ren <guoren@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.2 35/85] ipc: fix semtimedop for generic 32-bit architectures
Date:   Wed, 18 Sep 2019 08:18:53 +0200
Message-Id: <20190918061235.256229463@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 78e05972c5e6c8e9ca4c00ccc6985409da69f904 upstream.

As Vincent noticed, the y2038 conversion of semtimedop in linux-5.1
broke when commit 00bf25d693e7 ("y2038: use time32 syscall names on
32-bit") changed all system calls on all architectures that take
a 32-bit time_t to point to the _time32 implementation, but left out
semtimedop in the asm-generic header.

This affects all 32-bit architectures using asm-generic/unistd.h:
h8300, unicore32, openrisc, nios2, hexagon, c6x, arc, nds32 and csky.

The notable exception is riscv32, which has dropped support for the
time32 system calls entirely.

Reported-by: Vincent Chen <deanbo422@gmail.com>
Cc: stable@vger.kernel.org
Cc: Vincent Chen <deanbo422@gmail.com>
Cc: Greentime Hu <green.hu@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Ley Foon Tan <lftan@altera.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <jacquiot.aurelien@gmail.com>
Cc: Guo Ren <guoren@kernel.org>
Fixes: 00bf25d693e7 ("y2038: use time32 syscall names on 32-bit")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/asm-generic/unistd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -569,7 +569,7 @@ __SYSCALL(__NR_semget, sys_semget)
 __SC_COMP(__NR_semctl, sys_semctl, compat_sys_semctl)
 #if defined(__ARCH_WANT_TIME32_SYSCALLS) || __BITS_PER_LONG != 32
 #define __NR_semtimedop 192
-__SC_COMP(__NR_semtimedop, sys_semtimedop, sys_semtimedop_time32)
+__SC_3264(__NR_semtimedop, sys_semtimedop_time32, sys_semtimedop)
 #endif
 #define __NR_semop 193
 __SYSCALL(__NR_semop, sys_semop)


