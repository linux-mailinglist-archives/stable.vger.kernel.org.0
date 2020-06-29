Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0182220E7CC
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbgF2WAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgF2SfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D97C2247E4;
        Mon, 29 Jun 2020 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444150;
        bh=XarSoApLLTETtyGYNWWLrDZKQDBGnJS7T4Sk19EpEdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUSAoqWPBFUjuq42hX1zhcP9Cp5nvPhBOc4U8iKjMBvCx6S9BuYU2T21p4wG0AIuz
         7NhWZotWh75MrMaTN12jis0q+d3TbzWzcnR9axbKR9fP+k67vNJ1OJgdybVeZwy3dl
         X7lOOWLgWEkLgD/AKC2CbgFMPrl3Kritt5NrZr10=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arseny Solokha <asolokha@kb.kras.ru>,
        Jason Yan <yanaijie@huawei.com>, Scott Wood <oss@buserror.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 256/265] powerpc/fsl_booke/32: Fix build with CONFIG_RANDOMIZE_BASE
Date:   Mon, 29 Jun 2020 11:18:09 -0400
Message-Id: <20200629151818.2493727-257-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arseny Solokha <asolokha@kb.kras.ru>

commit 7e4773f73dcfb92e7e33532162f722ec291e75a4 upstream.

Building the current 5.8 kernel for an e500 machine with
CONFIG_RANDOMIZE_BASE=y and CONFIG_BLOCK=n yields the following
failure:

  arch/powerpc/mm/nohash/kaslr_booke.c: In function 'kaslr_early_init':
  arch/powerpc/mm/nohash/kaslr_booke.c:387:2: error: implicit
  declaration of function 'flush_icache_range'; did you mean 'flush_tlb_range'?

Indeed, including asm/cacheflush.h into kaslr_booke.c fixes the build.

Fixes: 2b0e86cc5de6 ("powerpc/fsl_booke/32: implement KASLR infrastructure")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Acked-by: Scott Wood <oss@buserror.net>
[mpe: Tweak change log to mention CONFIG_BLOCK=n]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200613162801.1946619-1-asolokha@kb.kras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/nohash/kaslr_booke.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 4a75f2d9bf0e0..bce0e5349978f 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -14,6 +14,7 @@
 #include <linux/memblock.h>
 #include <linux/libfdt.h>
 #include <linux/crash_core.h>
+#include <asm/cacheflush.h>
 #include <asm/pgalloc.h>
 #include <asm/prom.h>
 #include <asm/kdump.h>
-- 
2.25.1

