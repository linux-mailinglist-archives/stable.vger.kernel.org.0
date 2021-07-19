Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642CA3CDE62
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343559AbhGSPCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243447AbhGSPAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18AE360FE9;
        Mon, 19 Jul 2021 15:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709278;
        bh=bPwJDCKfWoR0IDXqGkDAnaIMMdlnEtfGPPsuGDmehUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRedARlCeb481WmlCpNdUHvd2X9VDmGNHa9Aw2JkZlFFDR6WOCYXqZ3kD11Seo5Ug
         7GjrnPT+cZ08JjKFuKN1+EFoTBX5/Xye39HhAqW59Cp3VZts5mBuXIdR61Xt/Lg72C
         lA6ba/UKaXy37JdHLifOfEf/dyvXGV9EA+1G+vVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Loehle <cloehle@hyperstone.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 292/421] mmc: core: Allow UHS-I voltage switch for SDSC cards if supported
Date:   Mon, 19 Jul 2021 16:51:43 +0200
Message-Id: <20210719144956.446741203@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Löhle <CLoehle@hyperstone.com>

commit 09247e110b2efce3a104e57e887c373e0a57a412 upstream.

While initializing an UHS-I SD card, the mmc core first tries to switch to
1.8V I/O voltage, before it continues to change the settings for the bus
speed mode.

However, the current behaviour in the mmc core is inconsistent and doesn't
conform to the SD spec. More precisely, an SD card that supports UHS-I must
set both the SD_OCR_CCS bit and the SD_OCR_S18R bit in the OCR register
response. When switching to 1.8V I/O the mmc core correctly checks both of
the bits, but only the SD_OCR_S18R bit when changing the settings for bus
speed mode.

Rather than actually fixing the code to confirm to the SD spec, let's
deliberately deviate from it by requiring only the SD_OCR_S18R bit for both
parts. This enables us to support UHS-I for SDSC cards (outside spec),
which is actually being supported by some existing SDSC cards. Moreover,
this fixes the inconsistent behaviour.

Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
Link: https://lore.kernel.org/r/CWXP265MB26803AE79E0AD5ED083BF2A6C4529@CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM
Cc: stable@vger.kernel.org
[Ulf: Rewrote commit message and comments to clarify the changes]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sd.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -781,11 +781,13 @@ try_again:
 		return err;
 
 	/*
-	 * In case CCS and S18A in the response is set, start Signal Voltage
-	 * Switch procedure. SPI mode doesn't support CMD11.
+	 * In case the S18A bit is set in the response, let's start the signal
+	 * voltage switch procedure. SPI mode doesn't support CMD11.
+	 * Note that, according to the spec, the S18A bit is not valid unless
+	 * the CCS bit is set as well. We deliberately deviate from the spec in
+	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr &&
-	   ((*rocr & 0x41000000) == 0x41000000)) {
+	if (!mmc_host_is_spi(host) && rocr && (*rocr & 0x01000000)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;


