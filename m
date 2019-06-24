Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5C1506FA
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfFXKDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729518AbfFXKDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:03:06 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E00FA2146E;
        Mon, 24 Jun 2019 10:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370585;
        bh=CWZ/M4ZRIO5NyJYUo2xSisGgm4N/taf80NLhXzE4FHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8Q38DjtG9+51zeA5LuyyhC0VXAd8fmLxqQdZ77rfBm69fvR2gGfdrvQz6YCbukLB
         tivS3oy2lu/vE7Ar7UJkddKfYTUaWy2Nf+sP3BRwEzz5p/7Q44+6jzb/Q213i7YcLM
         bdqx7yYKcPeK6bnMgqmmo0VJUVDh3/Lu7BESKgss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 28/90] brcmfmac: sdio: Disable auto-tuning around commands expected to fail
Date:   Mon, 24 Jun 2019 17:56:18 +0800
Message-Id: <20190624092316.047563650@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 2de0b42da263c97d330d276f5ccf7c4470e3324f upstream.

There are certain cases, notably when transitioning between sleep and
active state, when Broadcom SDIO WiFi cards will produce errors on the
SDIO bus.  This is evident from the source code where you can see that
we try commands in a loop until we either get success or we've tried
too many times.  The comment in the code reinforces this by saying
"just one write attempt may fail"

Unfortunately these failures sometimes end up causing an "-EILSEQ"
back to the core which triggers a retuning of the SDIO card and that
blocks all traffic to the card until it's done.

Let's disable retuning around the commands we expect might fail.

Cc: stable@vger.kernel.org #v4.18+
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -667,6 +667,8 @@ brcmf_sdio_kso_control(struct brcmf_sdio
 
 	brcmf_dbg(TRACE, "Enter: on=%d\n", on);
 
+	sdio_retune_crc_disable(bus->sdiodev->func1);
+
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
 	brcmf_sdiod_writeb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, wr_val, &err);
@@ -719,6 +721,8 @@ brcmf_sdio_kso_control(struct brcmf_sdio
 	if (try_cnt > MAX_KSO_ATTEMPTS)
 		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
 
+	sdio_retune_crc_enable(bus->sdiodev->func1);
+
 	return err;
 }
 


