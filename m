Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB4A205E64
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389000AbgFWUWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390111AbgFWUV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:21:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9B752082F;
        Tue, 23 Jun 2020 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943719;
        bh=L81CTMAMKJfNBfViabYix7rP+KfnO+1KZz9C2FuNPG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJ+4SiHT9GC/rv6WUKNmpF3JxQPdfdJ41uRaLLgtYEE+EKdwFjU3k3UmW++gO+oiu
         BuXyWyJG32JGByeatX6NCiGnp/wB/wJBUnkL1C+XPC5i4mDY23S6cpQ67Qe7U7f1rZ
         JHnecXCwEtpV+HgRVCuv+BUz85EwCE1MLORvfhi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, erhard_f@mailbox.org,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/314] powerpc/kasan: Fix stack overflow by increasing THREAD_SHIFT
Date:   Tue, 23 Jun 2020 21:53:38 +0200
Message-Id: <20200623195339.904396127@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit edbadaf0671072298e506074128b64e003c5812c ]

When CONFIG_KASAN is selected, the stack usage is increased.

In the same way as x86 and arm64 architectures, increase
THREAD_SHIFT when CONFIG_KASAN is selected.

Fixes: 2edb16efc899 ("powerpc/32: Add KASAN support")
Reported-by: <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=207129
Link: https://lore.kernel.org/r/2c50f3b1c9bbaa4217c9a98f3044bd2a36c46a4f.1586361277.git.christophe.leroy@c-s.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 44431dc06982f..ad620637cbd11 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -747,6 +747,7 @@ config THREAD_SHIFT
 	range 13 15
 	default "15" if PPC_256K_PAGES
 	default "14" if PPC64
+	default "14" if KASAN
 	default "13"
 	help
 	  Used to define the stack size. The default is almost always what you
-- 
2.25.1



