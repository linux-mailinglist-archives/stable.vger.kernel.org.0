Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18008261A8A
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbgIHSgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731198AbgIHQJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FF2624141;
        Tue,  8 Sep 2020 15:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580150;
        bh=bKU7rHDuIb84x8A+wT1iF7rOZljg5I0QY2Pox4v0Wak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5zYMiz55pEyHiGNJrOb2KhTorwldl9CG1AKZCURK0q9XzpYkrQwy7oTyQj6L7pIc
         4exwdQVIUSF88MaaBi40VbqlQlorldAN1HKHuizoSoNL/sQa5XL63+MlinclTen//g
         RrdHPD4VloV1edqWZmvc5TnuulTbqsyojJCWXtx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/88] MIPS: mm: BMIPS5000 has inclusive physical caches
Date:   Tue,  8 Sep 2020 17:25:21 +0200
Message-Id: <20200908152222.086901083@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit dbfc95f98f0158958d1f1e6bf06d74be38dbd821 ]

When the BMIPS generic cpu-feature-overrides.h file was introduced,
cpu_has_inclusive_caches/MIPS_CPU_INCLUSIVE_CACHES was not set for
BMIPS5000 CPUs. Correct this when we have initialized the MIPS secondary
cache successfully.

Fixes: f337967d6d87 ("MIPS: BMIPS: Add cpu-feature-overrides.h")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/c-r4k.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 05a539d3a5970..7650edd5cf7ff 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -1789,7 +1789,11 @@ static void setup_scache(void)
 				printk("MIPS secondary cache %ldkB, %s, linesize %d bytes.\n",
 				       scache_size >> 10,
 				       way_string[c->scache.ways], c->scache.linesz);
+
+				if (current_cpu_type() == CPU_BMIPS5000)
+					c->options |= MIPS_CPU_INCLUSIVE_CACHES;
 			}
+
 #else
 			if (!(c->scache.flags & MIPS_CACHE_NOT_PRESENT))
 				panic("Dunno how to handle MIPS32 / MIPS64 second level cache");
-- 
2.25.1



