Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B9B66C8AB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbjAPQlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbjAPQlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:41:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273F72ED4E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:29:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 888B2CE1283
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598F6C433D2;
        Mon, 16 Jan 2023 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886559;
        bh=s5d8qjGwlphUnBSAHLDRvuazw7pkrVfwwO4buH/pA+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBZmPK+k8RJV/3IctZfn8EGjMFjtSQHMlZ15UQFiJKNonRseBCT5iqWgCSaEb5uxD
         wJWTuNMCnsvPOhnQF55i5NspTtXTsHxerqS5bQxg7W3kxCD9jLnfVJxO2goiin29iu
         +ZIQ961vkz1yld6XpTD8/Xe2zRVP86gOpe+cGAj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 449/658] regulator: core: fix deadlock on regulator enable
Date:   Mon, 16 Jan 2023 16:48:57 +0100
Message-Id: <20230116154930.037951154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit cb3543cff90a4448ed560ac86c98033ad5fecda9 upstream.

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
Link: https://lore.kernel.org/r/20221215104646.19818-1-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -956,7 +956,7 @@ static int drms_uA_update(struct regulat
 		/* get input voltage */
 		input_uV = 0;
 		if (rdev->supply)
-			input_uV = regulator_get_voltage(rdev->supply);
+			input_uV = regulator_get_voltage_rdev(rdev->supply->rdev);
 		if (input_uV <= 0)
 			input_uV = rdev->constraints->input_uV;
 		if (input_uV <= 0) {


