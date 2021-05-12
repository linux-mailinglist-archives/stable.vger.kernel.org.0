Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9EE37CD85
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240580AbhELQz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243963AbhELQmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C871061C56;
        Wed, 12 May 2021 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835724;
        bh=cR7PS7IAQOEv8/KE5wKy1EqdcXGIp3+Z0cIYXc9C8CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6wN+DuRzXwEhy0+pNkfLypC96Chfc01GXqRsX5Rz/KjcAqu0JdGOic0DrizguAd9
         qrix1EwR2afWzCXmA7e0C+2YCjc9Z3Fc6wjp/5A4QHWxjtgrBNJlfew04CddhBXmqZ
         Lsw0JNBzFBkjXAxILnv2n+iyzEkcyuoFlYL3jCdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 460/677] powerpc/mm: Move the linear_mapping_mutex to the ifdef where it is used
Date:   Wed, 12 May 2021 16:48:26 +0200
Message-Id: <20210512144852.643780824@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 4e8ce6d85232..7a59a5c9aa5d 100644
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



