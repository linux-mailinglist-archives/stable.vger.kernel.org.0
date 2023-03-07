Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A9D6AED0B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCGSAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbjCGSAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6905615B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:54:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 095D661469
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BACC433EF;
        Tue,  7 Mar 2023 17:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211662;
        bh=grH1rfzk8g0jf2veuTXxDUMi5VAYKpNfinzHX7O3uoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANhWB0r/8ASBzQDK0swzXnLujuJahXpiCeWAqo/geUexX/xpWY5oTbmW8apwKWOrd
         9yfdoU1A5seF5dU6BlqkL0Bu+MhmuMI7Nyh5Urp4xVbDijCQoRk75c06K9t0EL9yCB
         tsPyTPcNHEBXio145bn223YubGP2ws51W5bS1tCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 6.2 0936/1001] genirq/msi: Take the per-device MSI lock before validating the control structure
Date:   Tue,  7 Mar 2023 18:01:48 +0100
Message-Id: <20230307170102.723833693@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 0af2795f936f1ea1f9f1497447145dfcc7ed2823 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/msi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index 783a3e6a0b10..13d96495e6d0 100644
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
-- 
2.39.2



