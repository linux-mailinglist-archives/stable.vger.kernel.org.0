Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CE669D5D8
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 22:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbjBTVhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 16:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjBTVhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 16:37:16 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20C2212A2;
        Mon, 20 Feb 2023 13:37:15 -0800 (PST)
Date:   Mon, 20 Feb 2023 21:37:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1676929034;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OUkh5Ko3jhevc1Bk0P+SZ5C68Sj3b1dGZJOtZcbce38=;
        b=0CNtf7kcqFkcV9pWdxoJNHAKuu1BeQ/YK/XLZQgDHkbNqnSU79B9P0STpA+qtBktIaWmuh
        y9Ucm07H/GhPXyAOt/Fa7OkHpQdfwts3rUJlURtxuY6bI1yoaqK9X7E1FQDeEmN6GLLy4t
        BxpQF+Yxe7Vg7NtdOvHh0uPMSADiLk9orEbDjoGNFqWntB5sPsOJkSBcAN0P3hnwXWBZky
        aAiqzdSa1HXAcIxRYQl6AhX2eqtfoc1GWBcEfgvznf2H6RHx3LY8UbLX/ElR9dOgmvuf+U
        Q6kMV3hKA3+zPQs3a61gSByVVeSh5+oAKjwym6xXqy6MI22kZ9owe1hFwa4ZKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1676929034;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OUkh5Ko3jhevc1Bk0P+SZ5C68Sj3b1dGZJOtZcbce38=;
        b=4xN8exoTrPvE1IPo7Xe37RWmAbNOwHsWXLIAR4a153ZZFVK+SVqEwOW5eDjBrg5XDnOt6M
        N/zx3VeXq9mPUGAg==
From:   "tip-bot2 for Marc Zyngier" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] genirq/msi: Take the per-device MSI lock before
 validating the control structure
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <8E@shell.armlinux.org.uk>
References: <8E@shell.armlinux.org.uk>
MIME-Version: 1.0
Message-ID: <167692903325.387.6855102455566331681.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     0af2795f936f1ea1f9f1497447145dfcc7ed2823
Gitweb:        https://git.kernel.org/tip/0af2795f936f1ea1f9f1497447145dfcc7ed2823
Author:        Marc Zyngier <maz@kernel.org>
AuthorDate:    Mon, 20 Feb 2023 19:01:01 
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Mon, 20 Feb 2023 22:29:54 +01:00

genirq/msi: Take the per-device MSI lock before validating the control structure

Calling msi_ctrl_valid() ultimately results in calling
msi_get_device_domain(), which requires holding the device MSI lock.

However, in msi_domain_populate_irqs() the lock is taken right after having
called msi_ctrl_valid(), which is just a tad too late.

Take the lock before invoking msi_ctrl_valid().

Fixes: 40742716f294 ("genirq/msi: Make msi_add_simple_msi_descs() device domain aware")
Reported-by: "Russell King (Oracle)" <linux@armlinux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/Y/Opu6ETe3ZzZ/8E@shell.armlinux.org.uk
Link: https://lore.kernel.org/r/20230220190101.314446-1-maz@kernel.org

---
 kernel/irq/msi.c |  9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 783a3e6..13d9649 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -1084,10 +1084,13 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
 	struct xarray *xa;
 	int ret, virq;
 
-	if (!msi_ctrl_valid(dev, &ctrl))
-		return -EINVAL;
-
 	msi_lock_descs(dev);
+
+	if (!msi_ctrl_valid(dev, &ctrl)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
 	ret = msi_domain_add_simple_msi_descs(dev, &ctrl);
 	if (ret)
 		goto unlock;
