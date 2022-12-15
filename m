Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182B464D9AD
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 11:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiLOKqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 05:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLOKqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 05:46:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77101F629;
        Thu, 15 Dec 2022 02:46:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4478161D78;
        Thu, 15 Dec 2022 10:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD9DC433EF;
        Thu, 15 Dec 2022 10:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671101195;
        bh=McOhDbVk0JP93y4a1SmXb8+7y052zP6zdNJ92f0ueYY=;
        h=From:To:Cc:Subject:Date:From;
        b=p1bVSMqrrJ0RECFYWt4n/HzRckicS01Tm0Ej6X08MA9N1GvwIdNDgXmUU2HjcClFL
         jDwV9CIluaPuPWw+EIoHbmr/KiNnKI51kGSKYUncmoy4JsiIIHvl8dIsInvsaD+a/a
         wQ0joNp0ZdqGejIE4WPok8MmDS0PR1FwfAAe+A1bQ7T+2u8fYWQAm6+jykEsau6DHl
         qqQT0O1E43Eos6rfgMx+ruXGZq72sLGrPUyzyaDEBjB3h4ax6RvctsVJgSfdk2aMs3
         BvhJtohpP2nj9NQPJgYbtlz2BC9sdixiv1dvYMA96pJG+ygIYoOdhpvlhcxpu4HpO9
         WoAShiFXBBrsQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1p5llZ-00059t-To; Thu, 15 Dec 2022 11:47:06 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Liam Girdwood <lgirdwood@gmail.com>,
        Maciej Purski <m.purski@samsung.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] regulator: core: fix deadlock on regulator enable
Date:   Thu, 15 Dec 2022 11:46:46 +0100
Message-Id: <20221215104646.19818-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When updating the operating mode as part of regulator enable, the caller
has already locked the regulator tree and drms_uA_update() must not try
to do the same in order not to trigger a deadlock.

The lock inversion is reported by lockdep as:

  ======================================================
  WARNING: possible circular locking dependency detected
  6.1.0-next-20221215 #142 Not tainted
  ------------------------------------------------------
  udevd/154 is trying to acquire lock:
  ffffc11f123d7e50 (regulator_list_mutex){+.+.}-{3:3}, at: regulator_lock_dependent+0x54/0x280

  but task is already holding lock:
  ffff80000e4c36e8 (regulator_ww_class_acquire){+.+.}-{0:0}, at: regulator_enable+0x34/0x80

  which lock already depends on the new lock.

  ...

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(regulator_ww_class_acquire);
                                 lock(regulator_list_mutex);
                                 lock(regulator_ww_class_acquire);
    lock(regulator_list_mutex);

   *** DEADLOCK ***

just before probe of a Qualcomm UFS controller (occasionally) deadlocks
when enabling one of its regulators.

Fixes: 9243a195be7a ("regulator: core: Change voltage setting path")
Fixes: f8702f9e4aa7 ("regulator: core: Use ww_mutex for regulators locking")
Cc: stable@vger.kernel.org      # 5.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 729c45393803..ae69e493913d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1002,7 +1002,7 @@ static int drms_uA_update(struct regulator_dev *rdev)
 		/* get input voltage */
 		input_uV = 0;
 		if (rdev->supply)
-			input_uV = regulator_get_voltage(rdev->supply);
+			input_uV = regulator_get_voltage_rdev(rdev->supply->rdev);
 		if (input_uV <= 0)
 			input_uV = rdev->constraints->input_uV;
 
-- 
2.37.4

