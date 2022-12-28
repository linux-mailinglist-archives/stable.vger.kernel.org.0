Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF29658509
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbiL1RFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbiL1REi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A7D2036B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:59:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AABFB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B1EC433D2;
        Wed, 28 Dec 2022 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246744;
        bh=bGXTgoqWJi2fUp5K0LLLL0nuoz+1EZDAO3OwtrNwmm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+mucoBF4YOYxN6s65XBi6aAhYNP1njfgcMPOlrGDVDhbZ0GHlZGmo1xxC5zLkRZI
         PI/pXzK8yp2gz5mevR/QwyMwjfhr3ZX/Pq8nqtSF5/u+WVRbnrQf6nivT7EvftlK3P
         m5jd06BYs5MFMFErS+Xm+R1LDfl0yoeko86LtTZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 1123/1146] regulator: core: fix deadlock on regulator enable
Date:   Wed, 28 Dec 2022 15:44:22 +0100
Message-Id: <20221228144400.649742892@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
@@ -1002,7 +1002,7 @@ static int drms_uA_update(struct regulat
 		/* get input voltage */
 		input_uV = 0;
 		if (rdev->supply)
-			input_uV = regulator_get_voltage(rdev->supply);
+			input_uV = regulator_get_voltage_rdev(rdev->supply->rdev);
 		if (input_uV <= 0)
 			input_uV = rdev->constraints->input_uV;
 


