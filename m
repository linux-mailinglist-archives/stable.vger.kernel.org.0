Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4EE10B9BC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbfK0U4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729650AbfK0U4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DFDE2084D;
        Wed, 27 Nov 2019 20:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888174;
        bh=wtjYU+nHjHQOYZA/U7nBjkeTi8Gils3V5XygPliyQmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4Hzr4hVt7pmCSDIFWHlCmYO23nFWaWbWbQULrVdr4ldDH84y3Wsj+d40G7FtqNwG
         D2hmVIifi+LFj+ZtVxPeSB5ZBLXvb6bM607J6K9qdvW7aYkvhM4qVFq3Bg/GFZG5vQ
         3TjSM3ZuUDtoGbScbSmxkJtkGACBejr+QN1iEHQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/306] powerpc/boot: Disable vector instructions
Date:   Wed, 27 Nov 2019 21:28:03 +0100
Message-Id: <20191127203117.194632825@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
index 25e3184f11f78..7d5ddf53750ce 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -32,8 +32,8 @@ else
 endif
 
 BOOTCFLAGS    := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
-		 -fno-strict-aliasing -Os -msoft-float -pipe \
-		 -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
+		 -fno-strict-aliasing -Os -msoft-float -mno-altivec -mno-vsx \
+		 -pipe -fomit-frame-pointer -fno-builtin -fPIC -nostdinc \
 		 -D$(compress-y)
 
 ifdef CONFIG_PPC64_BOOT_WRAPPER
-- 
2.20.1



