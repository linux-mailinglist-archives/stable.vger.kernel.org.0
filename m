Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CFA5011D9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343921AbiDNNoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244635AbiDNNfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:35:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B789939C8;
        Thu, 14 Apr 2022 06:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F71B8296A;
        Thu, 14 Apr 2022 13:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A7AC385AC;
        Thu, 14 Apr 2022 13:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943068;
        bh=9bImAcmj4A53oHrgEvLh7UEsskyu85oh1R6Ve/FzEG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f02FoCSMjSHMUmh9W2RiC541fQtogfn4kL/fF0hbSy8lLke3FVRSgv6AQQhGOK6G+
         /BxekjG9doV3WwY+7U++lDHpeNJuhPAhHu6bSJzb/QFaOFXD4HGw0st1UJURC41TzI
         jaqxR1Ns8a5zoKhetIrIYgDLaCIKFS12vfTMpVAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Clark <james.clark@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.4 023/475] coresight: Fix TRCCONFIGR.QE sysfs interface
Date:   Thu, 14 Apr 2022 15:06:48 +0200
Message-Id: <20220414110855.801859259@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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


