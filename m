Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E891CAB3F
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgEHMlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728856AbgEHMls (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B9521835;
        Fri,  8 May 2020 12:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941707;
        bh=OMmNip9BnoLZPq0jiHGPhR04qi7HfK9veE0CbFs2HDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPSt/teeoWK07RSUf7/H0J4NQZrAXFKTSGY9bAeYWcuHWtJT2JOEkRuKUH0AiYVzS
         TagZlDyoQOEU5nycqqWjK5OBAvrRNS0PwRVkMofU6T/K/oD9hOy8SjA+jsfldFnm7Y
         grT5y+HG8GYMVCFUAbr+nFoOTBDOpu+kbDizg6Wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 139/312] mmc: sd: limit SD card power limit according to cards capabilities
Date:   Fri,  8 May 2020 14:32:10 +0200
Message-Id: <20200508123134.265101036@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit d9812780a020bcec44565b5950b2a8b31afb5545 upstream.

The SD card specification allows cards to error out a SWITCH command
where the requested function in a group is not supported.  The spec
provides for a set of capabilities which indicate which functions are
supported.

In the case of the power limit, requesting an unsupported power level
via the SWITCH command fails, resulting in the power level remaining at
the power-on default of 0.72W, even though the host and card may support
higher powers levels.

This has been seen with SanDisk 8GB cards, which support the default
0.72W and 1.44W (200mA and 400mA) in combination with an iMX6 host,
supporting up to 2.88W (800mA).  This currently causes us to try to set
a power limit function value of '3' (2.88W) which the card errors out
on, and thereby causes the power level to remain at 0.72W rather than
the desired 1.44W.

Arrange to limit the selected current limit by the capabilities reported
by the card to avoid the SWITCH command failing.  Select the highest
current limit that the host and card combination support.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Fixes: a39ca6ae0a08 ("mmc: core: Simplify and fix for SD switch processing")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sd.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -337,6 +337,7 @@ static int mmc_read_switch(struct mmc_ca
 		card->sw_caps.sd3_bus_mode = status[13];
 		/* Driver Strengths supported by the card */
 		card->sw_caps.sd3_drv_type = status[9];
+		card->sw_caps.sd3_curr_limit = status[7] | status[6] << 8;
 	}
 
 out:
@@ -553,14 +554,25 @@ static int sd_set_current_limit(struct m
 	 * when we set current limit to 200ma, the card will draw 200ma, and
 	 * when we set current limit to 400/600/800ma, the card will draw its
 	 * maximum 300ma from the host.
+	 *
+	 * The above is incorrect: if we try to set a current limit that is
+	 * not supported by the card, the card can rightfully error out the
+	 * attempt, and remain at the default current limit.  This results
+	 * in a 300mA card being limited to 200mA even though the host
+	 * supports 800mA. Failures seen with SanDisk 8GB UHS cards with
+	 * an iMX6 host. --rmk
 	 */
-	if (max_current >= 800)
+	if (max_current >= 800 &&
+	    card->sw_caps.sd3_curr_limit & SD_MAX_CURRENT_800)
 		current_limit = SD_SET_CURRENT_LIMIT_800;
-	else if (max_current >= 600)
+	else if (max_current >= 600 &&
+		 card->sw_caps.sd3_curr_limit & SD_MAX_CURRENT_600)
 		current_limit = SD_SET_CURRENT_LIMIT_600;
-	else if (max_current >= 400)
+	else if (max_current >= 400 &&
+		 card->sw_caps.sd3_curr_limit & SD_MAX_CURRENT_400)
 		current_limit = SD_SET_CURRENT_LIMIT_400;
-	else if (max_current >= 200)
+	else if (max_current >= 200 &&
+		 card->sw_caps.sd3_curr_limit & SD_MAX_CURRENT_200)
 		current_limit = SD_SET_CURRENT_LIMIT_200;
 
 	if (current_limit != SD_SET_CURRENT_NO_CHANGE) {


