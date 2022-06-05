Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D18C53DBC6
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344252AbiFENxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344228AbiFENxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:53:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101CE616F;
        Sun,  5 Jun 2022 06:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97EA760F9F;
        Sun,  5 Jun 2022 13:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390E7C3411E;
        Sun,  5 Jun 2022 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654437215;
        bh=NMn/D9JPxt8jLL6icF27dO7Gk6ddPFeYALAuEG6UVWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hLoSRzUZaWgnM2zpSSYBpyOJ80bwWGqTPMs4mVDdnjWJ4vuaf6WX7tUbhQFY2W919
         nvyA9C7yZ5vzDUDIuGYooSkOTmHGkZOUy/QNTd23Ml5V4LfdCuM+HcwiskqwL3dVTG
         7o+UbCmq0I0lrpDJA8xJiIoT3jB3lfiOajjZtGgfKETA3vV/m/LIp5MaS0L8DwjTqz
         lV8ntCiEfTTgl0eWiv+nMU0HiZl3d0A2iE4PTWI5YzWmd0mkpr/GIP6C0MhAayx8tV
         /1oojhqImCHaBB13zb5yJRKBwEAE9XtWOA84rDK1bj6WRumqj1LWNx3i0C7JDkEBdt
         aUvYZfKigIBWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, John Garry <john.garry@huawei.com>,
        David Decotigny <ddecotig@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH MANUALSEL 5.18 6/7] genirq/msi: Shutdown managed interrupts with unsatifiable affinities
Date:   Sun,  5 Jun 2022 09:53:14 -0400
Message-Id: <20220605135320.61247-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220605135320.61247-1-sashal@kernel.org>
References: <20220605135320.61247-1-sashal@kernel.org>
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

