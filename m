Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B76360B89C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiJXTv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiJXTvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:51:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C3D68CF7;
        Mon, 24 Oct 2022 11:17:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32284B8113E;
        Mon, 24 Oct 2022 11:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881ACC433D6;
        Mon, 24 Oct 2022 11:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612048;
        bh=fmEfxgR2XiP4itflL2YB4yqVWS0agT7IBfMJR4Hzlro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXBp99J/8X/ESOp/53QuKkxEWT63+P/1JDW0kUOOdYMCfHla9NGlsgSJtR3GxTXzR
         r3rRRfZNpF8SwcXsc/dmobXkXO2032Pl5mXvzhHPVRzsuU8Sz9N8XpsfYxrOSiX5/+
         1V4z4LCPVo7OreDJkRiRcuznMKOyfgRMmRYoQtCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 033/210] mmc: core: Terminate infinite loop in SD-UHS voltage switch
Date:   Mon, 24 Oct 2022 13:29:10 +0200
Message-Id: <20221024112958.037368570@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

commit e9233917a7e53980664efbc565888163c0a33c3f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -793,7 +793,8 @@ try_again:
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
+	if (!mmc_host_is_spi(host) && (ocr & SD_OCR_S18R) &&
+	    rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;


