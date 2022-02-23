Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6104C08E9
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbiBWCdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237498AbiBWCdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:33:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25E95C84B;
        Tue, 22 Feb 2022 18:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79E58614FF;
        Wed, 23 Feb 2022 02:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8590C340F0;
        Wed, 23 Feb 2022 02:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583452;
        bh=dD+9dySqOBY0GnPXc0vqEOlGIoqkKIGq+vQ0XmTQUfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8MzRb4Zqp3XES7w0W+zRRwQFRSeDAB5v0lzI3hvi/xHIMNLFHcbAMBz/NaVMWQVb
         30IaAY72aogps7/C7yHUupykDZvniz37o5vGavEnYYrRW75OmwNwFUv1A5TNMfiD0m
         ALou3c1E0cFaItu/p7Ixj5N12mWzMlSejlekBNQylvkXC2AG0FXDzaBeVyRXTXCb2m
         ArffD5YrPn9XKpH1Zb9jmk+5dmV47slBSUwrISNwAu0SbIHSSCABxEUBn/p6GXK511
         VSbO3dunn0JkjXmqAaNaD5h/C/WVxovwaSUHhtBIBa0kyamgn46tPh+s4XDsTdqbUt
         S9L9VpuF6Vn+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        will@kernel.org, rikard.falkeborn@gmail.com, eric.auger@redhat.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.10 08/18] KVM: arm64: vgic: Read HW interrupt pending state from the HW
Date:   Tue, 22 Feb 2022 21:30:25 -0500
Message-Id: <20220223023035.241551-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023035.241551-1-sashal@kernel.org>
References: <20220223023035.241551-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 5bfa685e62e9ba93c303a9a8db646c7228b9b570 ]

It appears that a read access to GIC[DR]_I[CS]PENDRn doesn't always
result in the pending interrupts being accurately reported if they are
mapped to a HW interrupt. This is particularily visible when acking
the timer interrupt and reading the GICR_ISPENDR1 register immediately
after, for example (the interrupt appears as not-pending while it really
is...).

This is because a HW interrupt has its 'active and pending state' kept
in the *physical* distributor, and not in the virtual one, as mandated
by the spec (this is what allows the direct deactivation). The virtual
distributor only caries the pending and active *states* (note the
plural, as these are two independent and non-overlapping states).

Fix it by reading the HW state back, either from the timer itself or
from the distributor if necessary.

Reported-by: Ricardo Koller <ricarkol@google.com>
Tested-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220208123726.3604198-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index b2d73fc0d1ef4..9e1459534ce54 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -248,6 +248,8 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 						    IRQCHIP_STATE_PENDING,
 						    &val);
 			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+		} else if (vgic_irq_is_mapped_level(irq)) {
+			val = vgic_get_phys_line_level(irq);
 		} else {
 			val = irq_is_pending(irq);
 		}
-- 
2.34.1

