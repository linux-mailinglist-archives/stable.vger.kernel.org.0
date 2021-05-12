Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CF237C9FD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhELQXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239985AbhELQQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:16:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E136761C77;
        Wed, 12 May 2021 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834185;
        bh=jZyxStz9PxKM5bU1Ew/a+7WbmydqS5V4KShDOhYVkok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v65hJp2MCw6OSx8/8HXMIliTklfAYpCV2d9ZLmnUGMYS7WwtOINuNBTCzl12PMPEW
         /8maA1OfqpIehCRIqdi7agO14sFicoFjhR7Z1ebUGIUvVkjq+a+9cEmZpGmsCjFRzi
         RNLz8dTyGpricwpQlRFz3pLu1wo93V0QqboLHt5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 407/601] powerpc/mm: Move the linear_mapping_mutex to the ifdef where it is used
Date:   Wed, 12 May 2021 16:48:04 +0200
Message-Id: <20210512144841.230657688@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 9be77e11dade414d2fa63750aa5c754fac49d619 ]

The mutex linear_mapping_mutex is defined at the of the file while its
only two user are within the CONFIG_MEMORY_HOTPLUG block.
A compile without CONFIG_MEMORY_HOTPLUG set fails on PREEMPT_RT because
its mutex implementation is smart enough to realize that it is unused.

Move the definition of linear_mapping_mutex to ifdef block where it is
used.

Fixes: 1f73ad3e8d755 ("powerpc/mm: print warning in arch_remove_linear_mapping()")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210219165648.2505482-1-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index afab328d0887..d6c3f0b79f1d 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -54,7 +54,6 @@
 
 #include <mm/mmu_decl.h>
 
-static DEFINE_MUTEX(linear_mapping_mutex);
 unsigned long long memory_limit;
 bool init_mem_is_free;
 
@@ -72,6 +71,7 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 EXPORT_SYMBOL(phys_mem_access_prot);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+static DEFINE_MUTEX(linear_mapping_mutex);
 
 #ifdef CONFIG_NUMA
 int memory_add_physaddr_to_nid(u64 start)
-- 
2.30.2



