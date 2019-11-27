Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3866010B8C9
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbfK0Uqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:46:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbfK0Uqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:46:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26D95217C3;
        Wed, 27 Nov 2019 20:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887606;
        bh=gLtelvidJmu/jlsBQOJ2hGDX/2Qcy3X0HMoFKf8YEr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vw5ThjjIZCkm4o24DgdUgBQWi2a7PfmX3E2thgwKxwRiT5v1Ey8OYdqGt71fp6a1e
         Lt7drgQd93rs0IAXQWXxd+WETg0RWeeX9U9cfBW7uadlWCsRpXfztUjTO2ryrMBfJE
         ZN92voH/zILAcr+ukG9LwTn+n7rtrKWP9XuKUfNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 024/211] powerpc/boot: Disable vector instructions
Date:   Wed, 27 Nov 2019 21:29:17 +0100
Message-Id: <20191127203053.361932149@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit e8e132e6885962582784b6fa16a80d07ea739c0f ]

This will avoid auto-vectorisation when building with higher
optimisation levels.

We don't know if the machine can support VSX and even if it's present
it's probably not going to be enabled at this point in boot.

These flag were both added prior to GCC 4.6 which is the minimum
compiler version supported by upstream, thanks to Segher for the
details.

Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index e2a5a932c24a8..5807c9d8e56d5 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -24,8 +24,8 @@ compress-$(CONFIG_KERNEL_GZIP) := CONFIG_KERNEL_GZIP
 compress-$(CONFIG_KERNEL_XZ)   := CONFIG_KERNEL_XZ
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-		 -fno-strict-aliasing -Os -msoft-float -pipe \
-		 -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
+		 -fno-strict-aliasing -Os -msoft-float -mno-altivec -mno-vsx \
+		 -pipe -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 -D$(compress-y)
 
 BOOTCC := $(CC)
-- 
2.20.1



