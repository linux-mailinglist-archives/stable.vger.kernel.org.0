Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450083CA64A
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238339AbhGOSrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:47:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237791AbhGOSq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B88B613D6;
        Thu, 15 Jul 2021 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626374645;
        bh=KGXHF1xbr0Aylxb/eeKc3uUdt4Hmi9xZWmf7GSbYj50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEugFtCc1t9JwFxTHRM344ZjzorgIITsqov2Tius8SQ2UEvjgL7zYHztqS2Gs9sIv
         k8inCdwIXbnJZ2KxJ3giw5H/X7/DxS4k6Z5Yi8/W/dZDP6X6gsTni9nn6wYUZZVKVR
         ycHUosDRHzkhmSxzVdr1RVtbfF1D6IvP8aUSmvvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Loehle <cloehle@hyperstone.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 088/122] mmc: core: Allow UHS-I voltage switch for SDSC cards if supported
Date:   Thu, 15 Jul 2021 20:38:55 +0200
Message-Id: <20210715182514.041284951@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182448.393443551@linuxfoundation.org>
References: <20210715182448.393443551@linuxfoundation.org>
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
@@ -793,11 +793,13 @@ try_again:
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


