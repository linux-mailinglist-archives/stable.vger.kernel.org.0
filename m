Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220F640E60E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350925AbhIPRRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351286AbhIPRPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D39396141B;
        Thu, 16 Sep 2021 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810382;
        bh=qLNaAOyqoAqpNxxCdY/eg9rS4f8tRtYL9hWufE04kGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfJOtH7myOh5QlHCn7Ipbs9Z4sAv4+3z4G3+n9nHgdVzOy8xAPWHFCVQum/ypDG0c
         lITdJ7itsUNcVdrPzeW7l5SYzTQLSKVgSffQFdXMCBXRyJHya5xh3sNe5lfqoM+Ab3
         E9tc9CdTyDnUViDzSF77s4EvG9q8qg5jtUooRnn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 120/432] powerpc/config: Fix IPV6 warning in mpc855_ads
Date:   Thu, 16 Sep 2021 17:57:49 +0200
Message-Id: <20210916155814.833165587@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit c5ac55b6cbc604ad4144c380feae20f69453df91 ]

When building this config there's a warning:

  79:warning: override: reassigning to symbol IPV6

Commit 9a1762a4a4ff ("powerpc/8xx: Update mpc885_ads_defconfig to
improve CI") added CONFIG_IPV6=y, but left '# CONFIG_IPV6 is not set'
in.

IPV6 is default y, so remove both to clean up the build.

Fixes: 9a1762a4a4ff ("powerpc/8xx: Update mpc885_ads_defconfig to improve CI")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210817045407.2445664-2-joel@jms.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/mpc885_ads_defconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/configs/mpc885_ads_defconfig b/arch/powerpc/configs/mpc885_ads_defconfig
index d21f266cea9a..5cd17adf903f 100644
--- a/arch/powerpc/configs/mpc885_ads_defconfig
+++ b/arch/powerpc/configs/mpc885_ads_defconfig
@@ -21,7 +21,6 @@ CONFIG_INET=y
 CONFIG_IP_MULTICAST=y
 CONFIG_IP_PNP=y
 CONFIG_SYN_COOKIES=y
-# CONFIG_IPV6 is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_BLOCK=y
@@ -76,7 +75,6 @@ CONFIG_PERF_EVENTS=y
 CONFIG_MATH_EMULATION=y
 CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y
 CONFIG_STRICT_KERNEL_RWX=y
-CONFIG_IPV6=y
 CONFIG_BPF_JIT=y
 CONFIG_DEBUG_VM_PGTABLE=y
 CONFIG_BDI_SWITCH=y
-- 
2.30.2



