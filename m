Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB00A53DBD8
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344419AbiFENzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344599AbiFENyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:54:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39A4B7F5;
        Sun,  5 Jun 2022 06:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8389FB80735;
        Sun,  5 Jun 2022 13:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7B2C34115;
        Sun,  5 Jun 2022 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437247;
        bh=NMn/D9JPxt8jLL6icF27dO7Gk6ddPFeYALAuEG6UVWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRnU3Unpk2NxVGaheTfsiVykcQ6C3vRQ+BinX1fS/3tYzlQGxLJtdiC3L0ZPCT9bT
         xtBvOyqB3B6b65Jf7H/eQhjP/6Uju94rYAU5LaaqsvPr8xquEJCOY2OVEDm5djJbyq
         JN6FQBpZbNoMZLDZBsryibAhpXhc+T01DXocBo4UmbJpV8CRI46VjnD6QEJdTvpRcQ
         5LC4bO8NsEibp++Q0sCXShB6zShT2R050Faax4iHwDJ2sy/dvg2bTpa6q5bi5iUusq
         2PtTG2SDRzP3+GB8p5mXPtLZkzIJwHCJDKhGkKj6ycuVuiR4V+R9Han+JOH0FxNG1W
         L0I5Z6INNN35w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, John Garry <john.garry@huawei.com>,
        David Decotigny <ddecotig@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH MANUALSEL 5.17 5/6] genirq/msi: Shutdown managed interrupts with unsatifiable affinities
Date:   Sun,  5 Jun 2022 09:53:36 -0400
Message-Id: <20220605135341.61427-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220605135341.61427-1-sashal@kernel.org>
References: <20220605135341.61427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit d802057c7c553ad426520a053da9f9fe08e2c35a ]

When booting with maxcpus=<small number>, interrupt controllers
such as the GICv3 ITS may not be able to satisfy the affinity of
some managed interrupts, as some of the HW resources are simply
not available.

The same thing happens when loading a driver using managed interrupts
while CPUs are offline.

In order to deal with this, do not try to activate such interrupt
if there is no online CPU capable of handling it. Instead, place
it in shutdown state. Once a capable CPU shows up, it will be
activated.

Reported-by: John Garry <john.garry@huawei.com>
Reported-by: David Decotigny <ddecotig@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/20220405185040.206297-2-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/msi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 2bdfce5edafd..a9ee535293eb 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -818,6 +818,21 @@ static int msi_init_virq(struct irq_domain *domain, int virq, unsigned int vflag
 		irqd_clr_can_reserve(irqd);
 		if (vflags & VIRQ_NOMASK_QUIRK)
 			irqd_set_msi_nomask_quirk(irqd);
+
+		/*
+		 * If the interrupt is managed but no CPU is available to
+		 * service it, shut it down until better times. Note that
+		 * we only do this on the !RESERVE path as x86 (the only
+		 * architecture using this flag) deals with this in a
+		 * different way by using a catch-all vector.
+		 */
+		if ((vflags & VIRQ_ACTIVATE) &&
+		    irqd_affinity_is_managed(irqd) &&
+		    !cpumask_intersects(irq_data_get_affinity_mask(irqd),
+					cpu_online_mask)) {
+			    irqd_set_managed_shutdown(irqd);
+			    return 0;
+		    }
 	}
 
 	if (!(vflags & VIRQ_ACTIVATE))
-- 
2.35.1

