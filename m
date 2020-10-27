Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BBA29B98A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802583AbgJ0PuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801348AbgJ0Pkd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:40:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2636122384;
        Tue, 27 Oct 2020 15:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813232;
        bh=TUyu2UhcE4YN/EhBOkkBznpHt/Cd8seUgTQ4uwD81fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkXEZmV7jGhZIjh/F0rH76bfJ49uiSCX85wlyU/BApWByyE7muMLH3Z0eR+FjG+82
         esb6OgxmI/NT/JQBAkYg2p7k0ei00ckjZZDhaCrD+sD8V7x/56RICF+5F4zzOEGHB4
         8uUTTs0uhF1yASZXCgvqrg508vUavv2EjNsmODcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 483/757] powerpc: PPC_SECURE_BOOT should not require PowerNV
Date:   Tue, 27 Oct 2020 14:52:13 +0100
Message-Id: <20201027135513.130604730@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Axtens <dja@axtens.net>

[ Upstream commit 5c5e46dad939b2bf4df04293ab9ac68abd7c1f55 ]

In commit 61f879d97ce4 ("powerpc/pseries: Detect secure and trusted
boot state of the system.") we taught the kernel how to understand the
secure-boot parameters used by a pseries guest.

However, CONFIG_PPC_SECURE_BOOT still requires PowerNV. I didn't
catch this because pseries_le_defconfig includes support for
PowerNV and so everything still worked. Indeed, most configs will.
Nonetheless, technically PPC_SECURE_BOOT doesn't require PowerNV
any more.

The secure variables support (PPC_SECVAR_SYSFS) doesn't do anything
on pSeries yet, but I don't think it's worth adding a new condition -
at some stage we'll want to add a backend for pSeries anyway.

Fixes: 61f879d97ce4 ("powerpc/pseries: Detect secure and trusted boot state of the system.")
Signed-off-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200924014922.172914-1-dja@axtens.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 787e829b6f25c..997da0221780b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -980,7 +980,7 @@ config PPC_MEM_KEYS
 config PPC_SECURE_BOOT
 	prompt "Enable secure boot support"
 	bool
-	depends on PPC_POWERNV
+	depends on PPC_POWERNV || PPC_PSERIES
 	depends on IMA_ARCH_POLICY
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT
 	help
-- 
2.25.1



