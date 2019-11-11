Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94C5F7CDB
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbfKKSuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729736AbfKKSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A62E20674;
        Mon, 11 Nov 2019 18:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498233;
        bh=IXQvvTCPAxqp4Jk6jbh0oE46whydmr1vi31H9PbYkYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmPiRj9y23XOs7RHWs2G1QW6kA8UlKDveOyVnWqb4qCwa67HXi4Dk/5UFgJX98EFn
         /CvO5lkdPl1s+Iiq+kyDDG/7oY85tTkWAOD1tCgvwWympBLjYIpY8j87jOjJSe8/zR
         kPzUSC42eIrPWP+6iWMLcYVuD4xLyzCw85Tksrl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Jirman <megous@megous.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 5.3 060/193] ARM: sunxi: Fix CPU powerdown on A83T
Date:   Mon, 11 Nov 2019 19:27:22 +0100
Message-Id: <20191111181505.422619195@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

commit e690053e97e7a9c968df9a97cef9089dfa8e6a44 upstream.

PRCM_PWROFF_GATING_REG has CPU0 at bit 4 on A83T. So without this
patch, instead of gating the CPU0, the whole cluster was power gated,
when shutting down first CPU in the cluster.

Fixes: 6961275e72a8c1 ("ARM: sun8i: smp: Add support for A83T")
Signed-off-by: Ondrej Jirman <megous@megous.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Cc: stable@vger.kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-sunxi/mc_smp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-sunxi/mc_smp.c
+++ b/arch/arm/mach-sunxi/mc_smp.c
@@ -481,14 +481,18 @@ static void sunxi_mc_smp_cpu_die(unsigne
 static int sunxi_cpu_powerdown(unsigned int cpu, unsigned int cluster)
 {
 	u32 reg;
+	int gating_bit = cpu;
 
 	pr_debug("%s: cluster %u cpu %u\n", __func__, cluster, cpu);
 	if (cpu >= SUNXI_CPUS_PER_CLUSTER || cluster >= SUNXI_NR_CLUSTERS)
 		return -EINVAL;
 
+	if (is_a83t && cpu == 0)
+		gating_bit = 4;
+
 	/* gate processor power */
 	reg = readl(prcm_base + PRCM_PWROFF_GATING_REG(cluster));
-	reg |= PRCM_PWROFF_GATING_REG_CORE(cpu);
+	reg |= PRCM_PWROFF_GATING_REG_CORE(gating_bit);
 	writel(reg, prcm_base + PRCM_PWROFF_GATING_REG(cluster));
 	udelay(20);
 


