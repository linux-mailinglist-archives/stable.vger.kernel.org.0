Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2BC369D409
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 20:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbjBTTXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 14:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbjBTTXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 14:23:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71372B74C;
        Mon, 20 Feb 2023 11:23:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A67CB80DC9;
        Mon, 20 Feb 2023 19:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDDEC433D2;
        Mon, 20 Feb 2023 19:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676919689;
        bh=cd8CHI/SUrIQ9onJ/rf4zf7DqTdfWJzsNS6odyxJ9jg=;
        h=From:To:Cc:Subject:Date:From;
        b=Z0l21h8/S8idNZrbheBhfJe6Ea8RuRna/+tHVfOgl61/G4Jw7G5LBOhMJoLMUT1DQ
         pWSoTJY+xmQBfIhG5EPzWZcZ5r1V5HPumH+LwfMvgDCXJYA92hIc2x2K0vPRKJ28BY
         eu/ukW3BYCz40JYT+UYAmFd+nhbLjOjJYk2vftOdk8O3a7HO1XnjalZMrkJiN+MPv7
         gBJlq9iaEWgk15U+cU2yWjfvsj8ztmtnTCYmIaOTWdmfUqQYX7rj6XPvCnrEOSbB22
         yMEx/62+wDPqoKWPJ3W9ExFKfSH2mBAdp96OBJRtPD/rCOv91PpbrXMpSRIsGBo4e5
         xbReRnm4mxYCA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pUBPi-00BsZD-U5;
        Mon, 20 Feb 2023 19:01:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        stable@vger.kernel.org
Subject: [PATCH] genirq/msi: Take the per-device MSI lock before validating the control structure
Date:   Mon, 20 Feb 2023 19:01:01 +0000
Message-Id: <20230220190101.314446-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, tglx@linutronix.de, linux@armlinux.org.uk, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Calling msi_ctrl_valid() ultimately results in calling
msi_get_device_domain(), which requires holding the device MSI lock.

However, we take that lock right after having called msi_ctrl_valid(),
which is just a tad too late. Taking the lock earlier solves the issue.

Fixes: 40742716f294 ("genirq/msi: Make msi_add_simple_msi_descs() device domain aware")
Reported-by: "Russell King (Oracle)" <linux@armlinux.org.uk>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/Y/Opu6ETe3ZzZ/8E@shell.armlinux.org.uk
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
2.34.1

