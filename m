Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA548511E72
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiD0RuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 13:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiD0RuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 13:50:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D04443ECB;
        Wed, 27 Apr 2022 10:46:58 -0700 (PDT)
Date:   Wed, 27 Apr 2022 17:46:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651081617;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htCv97HWJBXwAKxNDO9I9Cj0Tvfm3S+nPV9KJDmcKOc=;
        b=ygpt40bOBuPv+hVmP5XfTRu4QwtBigQYjep7+fj0ggnhq+VKAGoatMJXNmtCL+vX19PwQz
        cchJnW+g33lL6dlcNrMvSL43D4r01So4d3ar9CXk1EmQ4iw5cAZELXIlO9lA+mTdjwD/RK
        t3CnnCEf4uSkxMa2eILm1pt73QcswdE/j1DPkN09gMGYraUEOSx5BDe56fr1cvIM04hBan
        auzFTuafO9fW5mqJwOBCf8H9GcoH1owEwUZC3VSdoHKG7qiCJGSiMo55z9iG3ceZdqbbNx
        9C51CTi3Vv8fBVRjEtYk8ZJhECaAike6QIxh09jjg8QpXSG5PxysZwlOwKaUCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651081617;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htCv97HWJBXwAKxNDO9I9Cj0Tvfm3S+nPV9KJDmcKOc=;
        b=J6rXUH80Hv6fnznLPYhb0GnKRjzqRFnLszHSc+/7JukNM4BeKovLmDrFKJfQ0x3upcdQqe
        kJV8Vl/90DBJQoBA==
From:   "tip-bot2 for Shin'ichiro Kawasaki" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] bus: fsl-mc-msi: Fix MSI descriptor mutex lock for
 msi_first_desc()
Cc:     "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <20220412075636.755454-1-shinichiro.kawasaki@wdc.com>
References: <20220412075636.755454-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Message-ID: <165108161560.4207.6285834000819152880.tip-bot2@tip-bot2>
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

Commit-ID:     c7d2f89fea26c84d5accc55d9976dd7e5305e63a
Gitweb:        https://git.kernel.org/tip/c7d2f89fea26c84d5accc55d9976dd7e5305e63a
Author:        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
AuthorDate:    Tue, 12 Apr 2022 16:56:36 +09:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 27 Apr 2022 19:42:32 +02:00

bus: fsl-mc-msi: Fix MSI descriptor mutex lock for msi_first_desc()

Commit e8604b1447b4 introduced a call to the helper function
msi_first_desc(), which needs MSI descriptor mutex lock before
call. However, the required mutex lock was not added. This results in
lockdep assertion:

 WARNING: CPU: 4 PID: 119 at kernel/irq/msi.c:274 msi_first_desc+0xd0/0x10c
  msi_first_desc+0xd0/0x10c
  fsl_mc_msi_domain_alloc_irqs+0x7c/0xc0
  fsl_mc_populate_irq_pool+0x80/0x3cc

Fix this by adding the mutex lock and unlock around the function call.

Fixes: e8604b1447b4 ("bus: fsl-mc-msi: Simplify MSI descriptor handling")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220412075636.755454-1-shinichiro.kawasaki@wdc.com

---
 drivers/bus/fsl-mc/fsl-mc-msi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/fsl-mc/fsl-mc-msi.c b/drivers/bus/fsl-mc/fsl-mc-msi.c
index 5e0e439..0cfe859 100644
--- a/drivers/bus/fsl-mc/fsl-mc-msi.c
+++ b/drivers/bus/fsl-mc/fsl-mc-msi.c
@@ -224,8 +224,12 @@ int fsl_mc_msi_domain_alloc_irqs(struct device *dev,  unsigned int irq_count)
 	if (error)
 		return error;
 
+	msi_lock_descs(dev);
 	if (msi_first_desc(dev, MSI_DESC_ALL))
-		return -EINVAL;
+		error = -EINVAL;
+	msi_unlock_descs(dev);
+	if (error)
+		return error;
 
 	/*
 	 * NOTE: Calling this function will trigger the invocation of the
