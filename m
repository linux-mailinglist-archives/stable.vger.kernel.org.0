Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0203E63DF05
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiK3SnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiK3Smz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:42:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9204ABC16
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:42:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40E83B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F85C433D6;
        Wed, 30 Nov 2022 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833769;
        bh=YYFfguAR0WLT78RoSoOuxno6o1fkXPZ4RaOq44hCWHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I33UX2S4HfhOlicpI2/gH26XMMwaB58cg6IPwzYd355BrIsbMglk+WUIC4ylbxnHf
         sid9uzb86Lat5v0N7BUP75cQVb6hCAbyGR6OPyzUmPQSOwy7PgJnRNsdIxKIs4cmgn
         j4veqThmHMAdov4iqhnpIIx18c3eXoILAyEVP1wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.15 195/206] genirq: Take the proposed affinity at face value if force==true
Date:   Wed, 30 Nov 2022 19:24:07 +0100
Message-Id: <20221130180537.979195798@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

commit c48c8b829d2b966a6649827426bcdba082ccf922 upstream.

Although setting the affinity of an interrupt to a set of CPUs that doesn't
have any online CPU is generally frowned apon, there are a few limited
cases where such affinity is set from a CPUHP notifier, setting the
affinity to a CPU that isn't online yet.

The saving grace is that this is always done using the 'force' attribute,
which gives a hint that the affinity setting can be outside of the online
CPU mask and the callsite set this flag with the knowledge that the
underlying interrupt controller knows to handle it.

This restores the expected behaviour on Marek's system.

Fixes: 33de0aa4bae9 ("genirq: Always limit the affinity to online CPUs")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/4b7fc13c-887b-a664-26e8-45aed13f048a@samsung.com
Link: https://lore.kernel.org/r/20220414140011.541725-1-maz@kernel.org

Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/manage.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -266,10 +266,16 @@ int irq_do_set_affinity(struct irq_data
 		prog_mask = mask;
 	}
 
-	/* Make sure we only provide online CPUs to the irqchip */
+	/*
+	 * Make sure we only provide online CPUs to the irqchip,
+	 * unless we are being asked to force the affinity (in which
+	 * case we do as we are told).
+	 */
 	cpumask_and(&tmp_mask, prog_mask, cpu_online_mask);
-	if (!cpumask_empty(&tmp_mask))
+	if (!force && !cpumask_empty(&tmp_mask))
 		ret = chip->irq_set_affinity(data, &tmp_mask, force);
+	else if (force)
+		ret = chip->irq_set_affinity(data, mask, force);
 	else
 		ret = -EINVAL;
 


