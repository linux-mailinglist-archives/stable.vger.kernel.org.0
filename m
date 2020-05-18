Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260441D8395
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbgERSGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733111AbgERSGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:06:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 199DD20853;
        Mon, 18 May 2020 18:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825167;
        bh=UbfeksTSL+z0wNvTmx3BLuXXAbmKMJLCP1x1BcvqVSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFftfzZOnujGNDrZWjoy4A/ob6aMh3Wa3hbUYHHQANEcK+xFhJ46ILQJWwBp/XMYh
         MvyxckPdUCxSp5AiPlgdP0HYu7Leh4Jb0MfkKN7mPItkVEANfGi3HZLD1rVq33Vp8d
         4U9Q4zJkUiHpDihlCw2O2yxjkOp6mwfU9zLOnbAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 155/194] powerpc/32s: Fix build failure with CONFIG_PPC_KUAP_DEBUG
Date:   Mon, 18 May 2020 19:37:25 +0200
Message-Id: <20200518173544.134907020@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 4833ce06e6855d526234618b746ffb71d6612c9a upstream.

gpr2 is not a parametre of kuap_check(), it doesn't exist.

Use gpr instead.

Fixes: a68c31fc01ef ("powerpc/32s: Implement Kernel Userspace Access Protection")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/ea599546f2a7771bde551393889e44e6b2632332.1587368807.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/book3s/32/kup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/book3s/32/kup.h
+++ b/arch/powerpc/include/asm/book3s/32/kup.h
@@ -75,7 +75,7 @@
 
 .macro kuap_check	current, gpr
 #ifdef CONFIG_PPC_KUAP_DEBUG
-	lwz	\gpr2, KUAP(thread)
+	lwz	\gpr, KUAP(thread)
 999:	twnei	\gpr, 0
 	EMIT_BUG_ENTRY 999b, __FILE__, __LINE__, (BUGFLAG_WARNING | BUGFLAG_ONCE)
 #endif


