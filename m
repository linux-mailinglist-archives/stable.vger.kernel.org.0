Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A414F3A60
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245086AbiDELo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354637AbiDEKO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC554993C;
        Tue,  5 Apr 2022 03:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43AEFB81B7A;
        Tue,  5 Apr 2022 10:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821A1C385A2;
        Tue,  5 Apr 2022 10:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152910;
        bh=9bImAcmj4A53oHrgEvLh7UEsskyu85oh1R6Ve/FzEG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zNTwFzyUdTp7MGc07TaZbR5mBuvM3mulhAexXPM0i+nEW6a5AHSzFkpW72VfLPrB4
         6cy2sW8XzgeDDqG0fzyYSTBheIFHV+aS4ozK6WTMqTQvHpM8ZDqbXUd27hRHhWmHIR
         x+82wREYBNjFoh3unUW3Fi++fUqEtvl/S4rsWfcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.10 032/599] coresight: Fix TRCCONFIGR.QE sysfs interface
Date:   Tue,  5 Apr 2022 09:25:26 +0200
Message-Id: <20220405070259.777351752@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <james.clark@arm.com>

commit ea75a342aed5ed72c87f38fbe0df2f5df7eae374 upstream.

It's impossible to program a valid value for TRCCONFIGR.QE
when TRCIDR0.QSUPP==0b10. In that case the following is true:

  Q element support is implemented, and only supports Q elements without
  instruction counts. TRCCONFIGR.QE can only take the values 0b00 or 0b11.

Currently the low bit of QSUPP is checked to see if the low bit of QE can
be written to, but as you can see when QSUPP==0b10 the low bit is cleared
making it impossible to ever write the only valid value of 0b11 to QE.
0b10 would be written instead, which is a reserved QE value even for all
values of QSUPP.

The fix is to allow writing the low bit of QE for any non zero value of
QSUPP.

This change also ensures that the low bit is always set, even when the
user attempts to only set the high bit.

Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Fixes: d8c66962084f ("coresight-etm4x: Controls pertaining to the reset, mode, pe and events")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220120113047.2839622-2-james.clark@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-sysfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
@@ -364,8 +364,12 @@ static ssize_t mode_store(struct device
 	mode = ETM_MODE_QELEM(config->mode);
 	/* start by clearing QE bits */
 	config->cfg &= ~(BIT(13) | BIT(14));
-	/* if supported, Q elements with instruction counts are enabled */
-	if ((mode & BIT(0)) && (drvdata->q_support & BIT(0)))
+	/*
+	 * if supported, Q elements with instruction counts are enabled.
+	 * Always set the low bit for any requested mode. Valid combos are
+	 * 0b00, 0b01 and 0b11.
+	 */
+	if (mode && drvdata->q_support)
 		config->cfg |= BIT(13);
 	/*
 	 * if supported, Q elements with and without instruction


