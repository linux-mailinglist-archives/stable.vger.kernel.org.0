Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F3614BA3D
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbgA1OTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730900AbgA1OTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 211AA24695;
        Tue, 28 Jan 2020 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221171;
        bh=07CHsY02F5oVnFJd4YI45/MEKIfIKYkc+rgYTBg0unA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7iJVGmnhBGJR/Rw/YRum9uDgeMQYt5F3CDPQiZy84nEWVgiETg3JWKmmYzN0PPQs
         7Xocq7gtXcFdQRt9gMPw72KD7AGxEExI43SHv6l8NA+j4SsGfbC1BSv45moEtpMu7o
         FLNE4D4e6/2Kx55vX3uHLlsE264I4O8oTG9f8v+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 118/271] powerpc: vdso: Make vdso32 installation conditional in vdso_install
Date:   Tue, 28 Jan 2020 15:04:27 +0100
Message-Id: <20200128135901.374763027@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit ff6d27823f619892ab96f7461764840e0d786b15 ]

The 32-bit vDSO is not needed and not normally built for 64-bit
little-endian configurations.  However, the vdso_install target still
builds and installs it.  Add the same config condition as is normally
used for the build.

Fixes: e0d005916994 ("powerpc/vdso: Disable building the 32-bit VDSO ...")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index a60c9c6e5cc17..de29b88c0e700 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -373,7 +373,9 @@ vdso_install:
 ifeq ($(CONFIG_PPC64),y)
 	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 $@
 endif
+ifdef CONFIG_VDSO32
 	$(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso32 $@
+endif
 
 archclean:
 	$(Q)$(MAKE) $(clean)=$(boot)
-- 
2.20.1



