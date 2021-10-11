Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ADF4290DB
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243513AbhJKOND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:13:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243105AbhJKOLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:11:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54F1A6120A;
        Mon, 11 Oct 2021 14:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960974;
        bh=GsOKpLZbNKyk0oRTidppXS/3zJVsgtJu4Wv25N74IPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPemtAiJ3NpNsgNNOc9ruQ1th7I+wki51Nvk7DwfrQMhd8C6/AJ/+uGnO8kcmerW/
         0Y8/62+Bp+sw4mtF8iitSmprkEyzQ/EpBccuKX/0idRh0wE56nxW1RzKuEM146DeAK
         S5B4XXJc8R592AgZb3l9j0C/EpG8JJo/vTHlUgk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 129/151] RISC-V: Include clone3() on rv32
Date:   Mon, 11 Oct 2021 15:46:41 +0200
Message-Id: <20211011134521.976822927@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
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
index 4b989ae15d59..8062996c2dfd 100644
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



