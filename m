Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EDB6DBA28
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 12:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjDHKrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 06:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbjDHKrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 06:47:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C33B4C17;
        Sat,  8 Apr 2023 03:46:27 -0700 (PDT)
Date:   Sat, 08 Apr 2023 10:45:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1680950716;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2aWNdqWCH6ooG7ZKCY8CAmB8Wk506YvYsyDSFqRjWL0=;
        b=2uf8x+Al4PhQgvInEDLMteVLg2UdgF1YLfOJ7GL3LYqyRTg1DP/IxYIu5A+goI7Qmv9fXV
        1TOlVSTkZys69TIEbVeWATSf8qSWtUxDZzfOK+d9bTMWR1En5NF0f/en4tl6bf3oQuVbKC
        dSewnGyyoLGjbNS1EcyR+x5WnMQe9anfWtnhaZYpajMVW5kQ4iFaF23Hhawy64q09KjL7w
        cxh9x6JLnYvINTixi9tgAuThPsu0w9FsmKWYhcOnNx6r388KZTUUwk6PSkvmar5a3NQH/+
        7Nr3clHpzlKwn1ymt72MwzlxUgcQsN0mV0nt5/0a6/efZJ4EgjXp5HWesS+oqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1680950716;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2aWNdqWCH6ooG7ZKCY8CAmB8Wk506YvYsyDSFqRjWL0=;
        b=XywPNYzKt5qoF8plW89y4YstY9GNgyqI4/cmdMr7sorJbjiD42e689Cn6evI3hfiYaCG+1
        lShr76qa4+jZGjDw==
From:   "irqchip-bot for Jianmin Lv" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/loongson-eiointc: Fix returned
 value on parsing MADT
Cc:     stable@vger.kernel.org, Jianmin Lv <lvjianmin@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20230407083453.6305-2-lvjianmin@loongson.cn>
References: <20230407083453.6305-2-lvjianmin@loongson.cn>
MIME-Version: 1.0
Message-ID: <168095071596.404.15580990145239593807.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     112eaa8fec5ea75f1be003ec55760b09a86799f8
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/112eaa8fec5ea75f1be003ec55760b09a86799f8
Author:        Jianmin Lv <lvjianmin@loongson.cn>
AuthorDate:    Fri, 07 Apr 2023 16:34:49 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Sat, 08 Apr 2023 11:29:18 +01:00

irqchip/loongson-eiointc: Fix returned value on parsing MADT

In pch_pic_parse_madt(), a NULL parent pointer will be
returned from acpi_get_vec_parent() for second pch-pic domain
related to second bridge while calling eiointc_acpi_init() at
first time, where the parent of it has not been initialized
yet, and will be initialized during second time calling
eiointc_acpi_init(). So, it's reasonable to return zero so
that failure of acpi_table_parse_madt() will be avoided, or else
acpi_cascade_irqdomain_init() will return and initialization of
followed pch_msi domain will be skipped.

Although it does not matter when pch_msi_parse_madt() returns
-EINVAL if no invalid parent is found, it's also reasonable to
return zero for that.

Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230407083453.6305-2-lvjianmin@loongson.cn
---
 drivers/irqchip/irq-loongson-eiointc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index d15fd38..62a632d 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -343,7 +343,7 @@ static int __init pch_pic_parse_madt(union acpi_subtable_headers *header,
 	if (parent)
 		return pch_pic_acpi_init(parent, pchpic_entry);
 
-	return -EINVAL;
+	return 0;
 }
 
 static int __init pch_msi_parse_madt(union acpi_subtable_headers *header,
@@ -355,7 +355,7 @@ static int __init pch_msi_parse_madt(union acpi_subtable_headers *header,
 	if (parent)
 		return pch_msi_acpi_init(parent, pchmsi_entry);
 
-	return -EINVAL;
+	return 0;
 }
 
 static int __init acpi_cascade_irqdomain_init(void)
