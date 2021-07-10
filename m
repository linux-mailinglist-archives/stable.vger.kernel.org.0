Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23A43C3073
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhGJCfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234874AbhGJCeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:34:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06181613E3;
        Sat, 10 Jul 2021 02:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884297;
        bh=c3pGcO7VwwhEPAcrjKBb3SnOFO6hstcNqRSHQqU0mt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H12tsEtqhx0pBtrYDNH6V656P0+5RgH1SvEHObssLXaKVlLLpO5NKQ/T6I9aEMBZB
         AJS9k4T+rUOYPBeuLI3sP6CWuJ/fOMNtwGn1sF3zxHTUQk1+7ljfGa/wEaiMLpRxB/
         Nv1HG+wVdI0P8XkyhopsCVYrkUccAiAsX/YAO+6WYilmD42z0i6xGiD6xi37Jtoanb
         lWTZtTwT9aox6CCktP1jckUFfZGgUrE7TRDd1kHJ0it4103faud33jqQXyAJtoJN7O
         +TgDUHkNXOrkMSb/YmUPSRdIu6tIjcZP9iNkDquelLLZ1G0gEtTQtYmVJMPsFR5dZH
         LRx/gWzNb5E5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 43/63] s390/processor: always inline stap() and __load_psw_mask()
Date:   Fri,  9 Jul 2021 22:26:49 -0400
Message-Id: <20210710022709.3170675-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9c9a915afd90f7534c16a71d1cd44b58596fddf3 ]

s390 is the only architecture which makes use of the __no_kasan_or_inline
attribute for two functions. Given that both stap() and __load_psw_mask()
are very small functions they can and should be always inlined anyway.

Therefore get rid of __no_kasan_or_inline and always inline these
functions.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 560d8b77b1d1..48d6ccdef5f7 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -215,7 +215,7 @@ static inline unsigned long current_stack_pointer(void)
 	return sp;
 }
 
-static __no_kasan_or_inline unsigned short stap(void)
+static __always_inline unsigned short stap(void)
 {
 	unsigned short cpu_address;
 
@@ -254,7 +254,7 @@ static inline void __load_psw(psw_t psw)
  * Set PSW mask to specified value, while leaving the
  * PSW addr pointing to the next instruction.
  */
-static __no_kasan_or_inline void __load_psw_mask(unsigned long mask)
+static __always_inline void __load_psw_mask(unsigned long mask)
 {
 	unsigned long addr;
 	psw_t psw;
-- 
2.30.2

