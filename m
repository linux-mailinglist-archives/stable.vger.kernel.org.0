Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 335EA50787
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbfFXKHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730352AbfFXKHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:07:43 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E806C205C9;
        Mon, 24 Jun 2019 10:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370862;
        bh=ECy2ZQeCJqHP2x9qvZA0fKlRWNpSNPyicrZYRdLcbmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nqlRvO3xFUUr+QklLaJ3HB5mJUM0j+nH46AZcXdc/WJ/Tld6fczHyDW3j5CSuhYp
         nafBh3U91WvDEkScu10p6f2A5//KMB4p0qRX45jge1MmcHP3ya3nP21/bBJh5BeXwq
         fBYRNbmICUuycK2L0Uay4HLQXR7JsGgTMaX1v1BI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wright Feng <wright.feng@cypress.com>,
        Double Lo <double.lo@cypress.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Douglas Anderson <dianders@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.1 028/121] Revert "brcmfmac: disable command decode in sdio_aos"
Date:   Mon, 24 Jun 2019 17:56:00 +0800
Message-Id: <20190624092322.193778572@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit abdd5dcc00207e7c38680f3754d1bfffafff1093 upstream.

This reverts commit 29f6589140a10ece8c1d73f58043ea5b3473ab3e.

After that patch landed I find that my kernel log on
rk3288-veyron-minnie and rk3288-veyron-speedy is filled with:
brcmfmac: brcmf_sdio_bus_sleep: error while changing bus sleep state -110

This seems to happen every time the Broadcom WiFi transitions out of
sleep mode.  Reverting the commit fixes the problem for me, so that's
what this patch does.

Note that, in general, the justification in the original commit seemed
a little weak.  It looked like someone was testing on a SD card
controller that would sometimes die if there were CRC errors on the
bus.  This used to happen back in early days of dw_mmc (the controller
on my boards), but we fixed it.  Disabling a feature on all boards
just because one SD card controller is broken seems bad.

Fixes: 29f6589140a1 ("brcmfmac: disable command decode in sdio_aos")
Cc: Wright Feng <wright.feng@cypress.com>
Cc: Double Lo <double.lo@cypress.com>
Cc: Madhan Mohan R <madhanmohan.r@cypress.com>
Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Cc: stable@vger.kernel.org
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3373,11 +3373,7 @@ err:
 
 static bool brcmf_sdio_aos_no_decode(struct brcmf_sdio *bus)
 {
-	if (bus->ci->chip == CY_CC_43012_CHIP_ID ||
-	    bus->ci->chip == CY_CC_4373_CHIP_ID ||
-	    bus->ci->chip == BRCM_CC_4339_CHIP_ID ||
-	    bus->ci->chip == BRCM_CC_4345_CHIP_ID ||
-	    bus->ci->chip == BRCM_CC_4354_CHIP_ID)
+	if (bus->ci->chip == CY_CC_43012_CHIP_ID)
 		return true;
 	else
 		return false;


