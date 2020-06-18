Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFB41FE56F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgFRBRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729724AbgFRBRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F01821D94;
        Thu, 18 Jun 2020 01:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443023;
        bh=fdOGuCa3JQl7tLPU51z62udmLQ0Y1JPeU/lcXBm4I/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NA5UFABagwZUKP2rqQF7XPZShqWpPLwVwYYpjN3SHcolrbCfM/aYVlSQqNondvUY8
         FMo7c7Cdq5eiTQLicLNDt4fdhnusUNPcrRDhBhtKIy9gDUO8QbVOOULHv+OGv3Aw7R
         dlmMPoDCOSorru3ZXM7vBe3lsezM4NwUDGahFJH8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>, erhard_f@mailbox.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 024/266] powerpc/kasan: Fix stack overflow by increasing THREAD_SHIFT
Date:   Wed, 17 Jun 2020 21:12:29 -0400
Message-Id: <20200618011631.604574-24-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 3dc5aecdd853..135d770e8e57 100644
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

