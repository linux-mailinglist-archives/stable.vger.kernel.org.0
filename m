Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BBC32EA23
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhCEMgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231842AbhCEMgR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:36:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0654065012;
        Fri,  5 Mar 2021 12:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947777;
        bh=7GO0TGi6Er23x6UCEkMsC0GpKslv51kLTBQ8Kslm/xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrU83c6scwwNV50JZyFAXQ6Ms1Hcz5rfF5dYB8veU0q5pm4IILSw/BgEXBNi+fidC
         F1Sw67NvtWl7tQ0R+YN9HcyR5SqlLGRoKahXXyzLtGUFBLMaF9X9Sx6VXAjYNiIBZA
         zLEXiYY/Qe+L0GmF97JFBl7CQPor6kdPKpqW/I1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/72] parisc: Bump 64-bit IRQ stack size to 64 KB
Date:   Fri,  5 Mar 2021 13:21:57 +0100
Message-Id: <20210305120900.032374826@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John David Anglin <dave.anglin@bell.net>

[ Upstream commit 31680c1d1595a59e17c14ec036b192a95f8e5f4a ]

Bump 64-bit IRQ stack size to 64 KB.

I had a kernel IRQ stack overflow on the mx3210 debian buildd machine.  This patch increases the
64-bit IRQ stack size to 64 KB.  The 64-bit stack size needs to be larger than the 32-bit stack
size since registers are twice as big.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/irq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index e5fcfb70cc7c..4d54aa70ea5f 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -376,7 +376,11 @@ static inline int eirr_to_irq(unsigned long eirr)
 /*
  * IRQ STACK - used for irq handler
  */
+#ifdef CONFIG_64BIT
+#define IRQ_STACK_SIZE      (4096 << 4) /* 64k irq stack size */
+#else
 #define IRQ_STACK_SIZE      (4096 << 3) /* 32k irq stack size */
+#endif
 
 union irq_stack_union {
 	unsigned long stack[IRQ_STACK_SIZE/sizeof(unsigned long)];
-- 
2.30.1



