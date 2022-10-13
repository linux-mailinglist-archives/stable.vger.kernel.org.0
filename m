Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6E45FE1BD
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJMSoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbiJMSnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:43:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671A932BA0;
        Thu, 13 Oct 2022 11:41:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 828A9B82033;
        Thu, 13 Oct 2022 17:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB858C433D6;
        Thu, 13 Oct 2022 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683729;
        bh=bG6X3+WJsB9jgX3tUXAaHu7yd9226itCgN/0YmmAHgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFIiQv+ZReVZmSZOBVOLJoXtmsMExTrBVeIZQt973nZCfXO8jkvq5bYldBxlmhqtW
         1XHPAq2/kXHF5CJkt4vKCwKzeiOzgG7BxU+/lyQkXFtcc3X4TZ5qaARIqIPIWBObTj
         DZeJI2aVdfv49DXvgJCISRg5zeYwdwa9HX9LCK2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/54] mmc: core: Terminate infinite loop in SD-UHS voltage switch
Date:   Thu, 13 Oct 2022 19:52:24 +0200
Message-Id: <20221013175148.084994323@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit e9233917a7e53980664efbc565888163c0a33c3f ]

This loop intends to retry a max of 10 times, with some implicit
termination based on the SD_{R,}OCR_S18A bit. Unfortunately, the
termination condition depends on the value reported by the SD card
(*rocr), which may or may not correctly reflect what we asked it to do.

Needless to say, it's not wise to rely on the card doing what we expect;
we should at least terminate the loop regardless. So, check both the
input and output values, so we ensure we will terminate regardless of
the SD card behavior.

Note that SDIO learned a similar retry loop in commit 0797e5f1453b
("mmc: core: Fixup signal voltage switch"), but that used the 'ocr'
result, and so the current pre-terminating condition looks like:

    rocr & ocr & R4_18V_PRESENT

(i.e., it doesn't have the same bug.)

This addresses a number of crash reports seen on ChromeOS that look
like the following:

    ... // lots of repeated: ...
    <4>[13142.846061] mmc1: Skipping voltage switch
    <4>[13143.406087] mmc1: Skipping voltage switch
    <4>[13143.964724] mmc1: Skipping voltage switch
    <4>[13144.526089] mmc1: Skipping voltage switch
    <4>[13145.086088] mmc1: Skipping voltage switch
    <4>[13145.645941] mmc1: Skipping voltage switch
    <3>[13146.153969] INFO: task halt:30352 blocked for more than 122 seconds.
    ...

Fixes: f2119df6b764 ("mmc: sd: add support for signal voltage switch procedure")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220914014010.2076169-1-briannorris@chromium.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index e2c34aa390f1..868b121ce4f3 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -853,7 +853,8 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
+	if (!mmc_host_is_spi(host) && (ocr & SD_OCR_S18R) &&
+	    rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;
-- 
2.35.1



