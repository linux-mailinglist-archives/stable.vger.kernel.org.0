Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0633428EEE
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbhJKNxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237558AbhJKNv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4457C60F35;
        Mon, 11 Oct 2021 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960199;
        bh=viXiHdPmngiTRMz49JB4l91oaJ5LphyDDRh4UEmyCT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juv6ClsZDRIAx0xE3AA/HIRLTLX/e+pbyUii0fpKHf6wFk0n5/bIAdhV+KghIcQ1y
         fcDbpOr7uHK3ZoeKR6L99rFgDNbW1ivBnk3VqWfWyfIpiN/tChfEhSLxhcOVcQAL6E
         x2Sk6hh93f0oR5e8Sn4ecK2eTdChQ2O53DNw3qds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/52] RISC-V: Include clone3() on rv32
Date:   Mon, 11 Oct 2021 15:46:17 +0200
Message-Id: <20211011134505.380852703@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmerdabbelt@google.com>

[ Upstream commit 59a4e0d5511ba61353ea9a4efdb1b86c23ecf134 ]

As far as I can tell this should be enabled on rv32 as well, I'm not
sure why it's rv64-only.  checksyscalls is complaining about our lack of
clone3() on rv32.

Fixes: 56ac5e213933 ("riscv: enable sys_clone3 syscall for rv64")
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/uapi/asm/unistd.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/uapi/asm/unistd.h b/arch/riscv/include/uapi/asm/unistd.h
index 13ce76cc5aff..80dff2c2bf67 100644
--- a/arch/riscv/include/uapi/asm/unistd.h
+++ b/arch/riscv/include/uapi/asm/unistd.h
@@ -18,9 +18,10 @@
 #ifdef __LP64__
 #define __ARCH_WANT_NEW_STAT
 #define __ARCH_WANT_SET_GET_RLIMIT
-#define __ARCH_WANT_SYS_CLONE3
 #endif /* __LP64__ */
 
+#define __ARCH_WANT_SYS_CLONE3
+
 #include <asm-generic/unistd.h>
 
 /*
-- 
2.33.0



