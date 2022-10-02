Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631F25F2264
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 11:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiJBJwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 05:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJBJwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 05:52:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38464BD35
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 02:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7036960EA3
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 09:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFBFC433C1;
        Sun,  2 Oct 2022 09:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664704356;
        bh=lAX0LAxgsv1u4qrdNzEdDyHimKRvGMoQdlKR7pgJNTc=;
        h=Subject:To:Cc:From:Date:From;
        b=d2FtnSEVW6rMAP9Ev38jVrnjWsV7mP9OtHxvEQJdPyBIQ40lV+X57rKf8VzDlYOoj
         QgYJyg2vaBu1q7moaiobaVgbmf6Q2shT1CjrHSU/0M43pAPzC+uccVU2CV2vdq1C5l
         v6m9uzemUKz9lzooWENn+BpL35xJNLi3d6yZ5KE8=
Subject: FAILED: patch "[PATCH] mmc: core: Terminate infinite loop in SD-UHS voltage switch" failed to apply to 4.14-stable tree
To:     briannorris@chromium.org, linux@roeck-us.net,
        stable@vger.kernel.org, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 02 Oct 2022 11:53:07 +0200
Message-ID: <1664704387177104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e9233917a7e5 ("mmc: core: Terminate infinite loop in SD-UHS voltage switch")
e42726646082 ("mmc: core: Replace with already defined values for readability")
09247e110b2e ("mmc: core: Allow UHS-I voltage switch for SDSC cards if supported")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e9233917a7e53980664efbc565888163c0a33c3f Mon Sep 17 00:00:00 2001
From: Brian Norris <briannorris@chromium.org>
Date: Tue, 13 Sep 2022 18:40:10 -0700
Subject: [PATCH] mmc: core: Terminate infinite loop in SD-UHS voltage switch

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

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 06aa62ce0ed1..3662bf5320ce 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -870,7 +870,8 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
+	if (!mmc_host_is_spi(host) && (ocr & SD_OCR_S18R) &&
+	    rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;

