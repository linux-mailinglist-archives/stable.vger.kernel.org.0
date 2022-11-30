Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE18663DDEA
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiK3Sb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiK3Sbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:31:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D868D672
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:31:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8501BB81CA1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92F4C433D6;
        Wed, 30 Nov 2022 18:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833106;
        bh=7f6QaxeuafeUdEKArzcO1nFsB+hyUgHQRJV/v3MQNys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9KkiTCb7N3e/GM9tYdCUVExFqklLrmeiYMxvIVb0jNafl5ZykznvW3+mbbc9z8ci
         eH2KDJbt7aAA77YnbjCl//AYH/iCzq0/pxwsIW3/U7rN3MyA2BW1DY2hvVonY5TJYN
         fxINV09GUWPtL6lW4Behnoki65HkgGSU8CCfqBgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Garry <john.garry@huawei.com>,
        David Decotigny <ddecotig@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.10 152/162] genirq/msi: Shutdown managed interrupts with unsatifiable affinities
Date:   Wed, 30 Nov 2022 19:23:53 +0100
Message-Id: <20221130180532.598133513@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Capitulino <luizcap@amazon.com>

From: Marc Zyngier <maz@kernel.org>

commit d802057c7c553ad426520a053da9f9fe08e2c35a upstream.

[ This commit is almost a rewrite because it conflicts with Thomas
  Gleixner's refactoring of this code in v5.17-rc1. I wasn't sure if
  I should drop all the s-o-bs (including Mark's), but decided
  to keep as the original commit ]

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

Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/msi.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -456,6 +456,13 @@ int __msi_domain_alloc_irqs(struct irq_d
 			irqd_clr_can_reserve(irq_data);
 			if (domain->flags & IRQ_DOMAIN_MSI_NOMASK_QUIRK)
 				irqd_set_msi_nomask_quirk(irq_data);
+			if ((info->flags & MSI_FLAG_ACTIVATE_EARLY) &&
+				irqd_affinity_is_managed(irq_data) &&
+				!cpumask_intersects(irq_data_get_affinity_mask(irq_data),
+						    cpu_online_mask)) {
+				irqd_set_managed_shutdown(irq_data);
+				continue;
+			}
 		}
 		ret = irq_domain_activate_irq(irq_data, can_reserve);
 		if (ret)


