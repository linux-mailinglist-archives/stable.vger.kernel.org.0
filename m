Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0103E4093EC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344750AbhIMOZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344708AbhIMOXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E302761B3C;
        Mon, 13 Sep 2021 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540875;
        bh=4LtRL2sRWfggO6m+Fluzy4qEcpSqdlUJaaiPByFil+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKhd6n8kHWe6ZlUn8HiO5Ls4STJOVCNuMfSYlqcPWTBfFqs7i7HwG3bdV0RiCBHJK
         okXZ8+ecFggX/ShxAFwCzztcUKIaKgHTJ4vnVEp03/P9KyuAadxPKPD3SMHtsFGI0E
         dd/F39aC+XkZSYQQwyuKWsphzIaUqSlaOWmLLIb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 071/334] m68k: Fix asm register constraints for atomic ops
Date:   Mon, 13 Sep 2021 15:12:05 +0200
Message-Id: <20210913131115.802704940@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 87d93029fe83e326d5b906e12e95600b157d2c0d ]

Depending on register assignment by the compiler:

    {standard input}:3084: Error: operands mismatch -- statement `andl %a1,%d1' ignored
    {standard input}:3145: Error: operands mismatch -- statement `orl %a1,%d1' ignored
    {standard input}:3195: Error: operands mismatch -- statement `eorl %a1,%d1' ignored

Indeed, the first operand must not be an address register.  However, it
can be an immediate value.  Fix this by adjusting the register
constraint from "g" (general purpose register) to "di" (data register or
immediate).

Fixes: e39d88ea3ce4a471 ("locking/atomic, arch/m68k: Implement atomic_fetch_{add,sub,and,or,xor}()")
Fixes: d839bae4269aea46 ("locking,arch,m68k: Fold atomic_ops")
Fixes: 1da177e4c3f41524 ("Linux-2.6.12-rc2")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210809112903.3898660-1-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/atomic.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 8637bf8a2f65..cfba83d230fd 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -48,7 +48,7 @@ static inline int arch_atomic_##op##_return(int i, atomic_t *v)		\
 			"	casl %2,%1,%0\n"			\
 			"	jne 1b"					\
 			: "+m" (*v), "=&d" (t), "=&d" (tmp)		\
-			: "g" (i), "2" (arch_atomic_read(v)));		\
+			: "di" (i), "2" (arch_atomic_read(v)));		\
 	return t;							\
 }
 
@@ -63,7 +63,7 @@ static inline int arch_atomic_fetch_##op(int i, atomic_t *v)		\
 			"	casl %2,%1,%0\n"			\
 			"	jne 1b"					\
 			: "+m" (*v), "=&d" (t), "=&d" (tmp)		\
-			: "g" (i), "2" (arch_atomic_read(v)));		\
+			: "di" (i), "2" (arch_atomic_read(v)));		\
 	return tmp;							\
 }
 
-- 
2.30.2



