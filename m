Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4184B48AE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343838AbiBNJ5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:57:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343955AbiBNJ5H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:57:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349A560D91;
        Mon, 14 Feb 2022 01:45:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE356B80DC4;
        Mon, 14 Feb 2022 09:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7DFC340EF;
        Mon, 14 Feb 2022 09:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831946;
        bh=FAOqEsMMUVuOXaN5cnfrSyFfLgufg71f4JFXjgvJIqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01a/fmc7NZIwi/4BCwbx81xcXb9Shh4sve8DtnmYaK00XXQddr098mP335Q+cvKSY
         3dYIxILw/yMuj++pw7ge0jE6uocWw9HoxZka1aOQwlIJ4rOwCe/nE+IUgoFvGUYRpF
         UPoeMXkh43InNvt7ymvhrU8TL4viBicfFqeUYmxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Skvortsov <andrej.skvortzov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 007/172] mmc: core: Wait for command setting Power Off Notification bit to complete
Date:   Mon, 14 Feb 2022 10:24:25 +0100
Message-Id: <20220214092506.609357198@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Skvortsov <andrej.skvortzov@gmail.com>

commit 379f56c24e698f14242f532b1d0a0f1747725e08 upstream.

SD card is allowed to signal busy on DAT0 up to 1s after the
CMD49. According to SD spec (version 6.0 section 5.8.1.3) first host
waits until busy of CMD49 is released and only then polls Power
Management Status register up to 1s until the card indicates ready to
power off.

Without waiting for busy before polling status register sometimes card
becomes unresponsive and system fails to suspend:

  [  205.907459] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
  [  206.421274] sunxi-mmc 1c0f000.mmc: data error, sending stop command
  [  206.421321] sunxi-mmc 1c0f000.mmc: send stop command failed
  [  206.421347] mmc0: error -110 reading status reg of PM func
  [  206.421366] PM: dpm_run_callback(): mmc_bus_suspend+0x0/0x74 returns -110
  [  206.421402] mmcblk mmc0:aaaa: PM: failed to suspend async: error -110
  [  206.437064] PM: Some devices failed to suspend, or early wake event detected

Tested with Sandisk Extreme PRO A2 64GB on Allwinner A64 system.

Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Fixes: 2c5d42769038 ("mmc: core: Add support for Power Off Notification for SD cards")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220115121447.641524-1-andrej.skvortzov@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -66,7 +66,7 @@ static const unsigned int sd_au_size[] =
 		__res & __mask;						\
 	})
 
-#define SD_POWEROFF_NOTIFY_TIMEOUT_MS 2000
+#define SD_POWEROFF_NOTIFY_TIMEOUT_MS 1000
 #define SD_WRITE_EXTR_SINGLE_TIMEOUT_MS 1000
 
 struct sd_busy_data {
@@ -1663,6 +1663,12 @@ static int sd_poweroff_notify(struct mmc
 		goto out;
 	}
 
+	/* Find out when the command is completed. */
+	err = mmc_poll_for_busy(card, SD_WRITE_EXTR_SINGLE_TIMEOUT_MS, false,
+				MMC_BUSY_EXTR_SINGLE);
+	if (err)
+		goto out;
+
 	cb_data.card = card;
 	cb_data.reg_buf = reg_buf;
 	err = __mmc_poll_for_busy(card, SD_POWEROFF_NOTIFY_TIMEOUT_MS,


