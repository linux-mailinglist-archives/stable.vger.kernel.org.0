Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BDF1CAAC1
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgEHMgg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbgEHMgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49F2721835;
        Fri,  8 May 2020 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941394;
        bh=W0lQNYYjtpUY/fE/X6ebU13m7wtSSSmfGcgqNuv+JP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5D6dHgdXZ4OpMphLoqpHfQVgP4NhHWYpTaSnv8mhsrQDY6DH+/oPfCEYitk4veL2
         sS6E7npdBwRdneurSTzqZhQSEprE0QW0Pgis/0tp8dmYpoCDh4hUq5sc1zuUlH1fQY
         RcfrM4EaRF+VAfVDpFQWNO0Bz1MZwbzTSubDuzr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 015/312] MIPS: BMIPS: Clear MIPS_CACHE_ALIASES earlier
Date:   Fri,  8 May 2020 14:30:06 +0200
Message-Id: <20200508123125.570385401@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 73c4ca047f440c79f545bc6133e3033f754cd239 upstream.

BMIPS5000 and BMIPS5200 processor have no D cache aliases, and this is
properly handled by the per-CPU override added at the end of
r4k_cache_init(), the problem is that the output of probe_pcache()
disagrees with that, since this is too late:

Primary instruction cache 32kB, VIPT, 4-way, linesize 64 bytes.
Primary data cache 32kB, 4-way, VIPT, cache aliases, linesize 32 bytes

With the change moved earlier, we now have a consistent output with the
settings we are intending to have:

Primary instruction cache 32kB, VIPT, 4-way, linesize 64 bytes.
Primary data cache 32kB, 4-way, VIPT, no aliases, linesize 32 bytes

Fixes: d74b0172e4e2c ("MIPS: BMIPS: Add special cache handling in c-r4k.c")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/13011/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/c-r4k.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -1310,6 +1310,8 @@ static void probe_pcache(void)
 
 	case CPU_BMIPS5000:
 		c->icache.flags |= MIPS_CACHE_IC_F_DC;
+		/* Cache aliases are handled in hardware; allow HIGHMEM */
+		c->dcache.flags &= ~MIPS_CACHE_ALIASES;
 		break;
 
 	case CPU_LOONGSON2:
@@ -1749,8 +1751,6 @@ void r4k_cache_init(void)
 		flush_icache_range = (void *)b5k_instruction_hazard;
 		local_flush_icache_range = (void *)b5k_instruction_hazard;
 
-		/* Cache aliases are handled in hardware; allow HIGHMEM */
-		current_cpu_data.dcache.flags &= ~MIPS_CACHE_ALIASES;
 
 		/* Optimization: an L2 flush implicitly flushes the L1 */
 		current_cpu_data.options |= MIPS_CPU_INCLUSIVE_CACHES;


