Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD34D1E2E21
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390567AbgEZT1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390273AbgEZTEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:04:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F87920849;
        Tue, 26 May 2020 19:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519875;
        bh=hrbJyOLEuxk36OPNi1fKCASFHtlHY4Zp1pnVLXNnWFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/3lB3vEz1sKEpO09avOvLf73ordnElXrDEl1HPHfiQqxcb1ZWlyRtOrH1cPll6dj
         V8F+Oduhwx+fkEW4iIHb4SD6eK65fBGN4GpNryM0QKfSIy3VeBHT60LTWsrxZnSA8E
         SepBQxqLIdPLCgzQ4zgtKVngoluAfrLYPCeOoN1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/81] powerpc: Remove STRICT_KERNEL_RWX incompatibility with RELOCATABLE
Date:   Tue, 26 May 2020 20:53:24 +0200
Message-Id: <20200526183932.664564063@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit c55d7b5e64265fdca45c85b639013e770bde2d0e ]

I have tested this with the Radix MMU and everything seems to work, and
the previous patch for Hash seems to fix everything too.
STRICT_KERNEL_RWX should still be disabled by default for now.

Please test STRICT_KERNEL_RWX + RELOCATABLE!

Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191224064126.183670-2-ruscur@russell.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6f475dc5829b..da48a2ca272e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -139,7 +139,7 @@ config PPC
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE
 	select ARCH_HAS_SG_CHAIN
-	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
+	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if PPC64
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-- 
2.25.1



