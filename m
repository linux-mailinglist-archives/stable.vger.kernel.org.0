Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D542D77A4
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 15:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405924AbgLKOSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 09:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405931AbgLKOSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 09:18:10 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDB3C0613D3
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 06:17:29 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a12so13533215lfl.6
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 06:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11tRxXmcRL83hT4n8MDtkMiTQdUv9JJoYgN481wECQI=;
        b=k0kUp77H54YOwO3WS2omVR2voAv6qo8ArgdgCMds49n1YSaD7GuIp8Kp7JYvox+ClU
         DR2B+zlfdwqMuJbwVnlT3UYxRTQVPbCT/1IudphcxguNGX0XfRvxUGX+lJHHqRxxWvve
         VhfKecBaBaOFnzng8IdpkNxVTUzQn2gOfzl8QF0ntIlEZ/Eqj0DujouJUjbXEizlXkrM
         LrHOaJroY+22897sBE3zIQk/FuAhf3rUjjUc65Byd7Ss3LciH+mxsh3O5ikkk9hmSzyK
         VjEBpqF8er+25VhF6ZJJ1i7cder4kvsywh+1ihQLjaekPzWFoBFaDtM5CA/ea1XLGoIS
         yGCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11tRxXmcRL83hT4n8MDtkMiTQdUv9JJoYgN481wECQI=;
        b=ZHqxRqwB1A4gUpBB3GsyuLgtDNBiRrBRTuMVhGc76Jh4SrDqtgvK3Kya4WGU+788XM
         wRZjp2JIYv7r+iuGNcL3r7l+4LML2OLwvXbgYHgPB1PGXZNV04yrkrX8hIpb0hZr3DD7
         L9WvafcxLVCaxlv0ThYqU2m+tREOTOUcaqeHeWuSr9C70gYQNmgZN5N61V+/I9YPqnOp
         rv7bOTnOv6Cr5VkigzqfilqlGeF9hRvbSEfySWc5HguFHyBcnEd1rm/VF8e4yL/01e/U
         Jpr3wmzRNRlcrhCY3v2iwpj3LUbOvvDiqSCwpg2386q+BSd6d643DQt9lKVXC8KLczT3
         SQnQ==
X-Gm-Message-State: AOAM531ky1S6P6Sai7dLVX4ov3j5lXoKfbSXik++1AMLteDM1ubKj0xj
        r8P7s/FwD4aJLtNl7DAtIdSxAg==
X-Google-Smtp-Source: ABdhPJwtKCFc4Mm8+N3WHfMuoJAo+6NALou7GDnjewzGye7r3r4uJGEcXCbgK6gp0u5VMiYIWQ+l4w==
X-Received: by 2002:ac2:48b2:: with SMTP id u18mr4917512lfg.313.1607696248053;
        Fri, 11 Dec 2020 06:17:28 -0800 (PST)
Received: from gilgamesh.semihalf.com (193-106-246-138.noc.fibertech.net.pl. [193.106.246.138])
        by smtp.gmail.com with ESMTPSA id q16sm903019lfb.8.2020.12.11.06.17.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Dec 2020 06:17:27 -0800 (PST)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Cc:     ulf.hansson@linaro.org, huziji@marvell.com,
        adrian.hunter@intel.com, jaz@semihalf.com, tn@semihalf.com,
        kostap@marvell.com, Alex Leibovich <alexl@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, stable@vger.kernel.org
Subject: [PATCH] mmc: sdhci-xenon: fix 1.8v regulator stabilization
Date:   Fri, 11 Dec 2020 15:16:56 +0100
Message-Id: <20201211141656.24915-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Leibovich <alexl@marvell.com>

Automatic Clock Gating is a feature used for the power
consumption optimisation. It turned out that
during early init phase it may prevent the stable voltage
switch to 1.8V - due to that on some platfroms an endless
printout in dmesg can be observed:
"mmc1: 1.8V regulator output did not became stable"
Fix the problem by disabling the ACG at very beginning
of the sdhci_init and let that be enabled later.

Fixes: 3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
Signed-off-by: Alex Leibovich <alexl@marvell.com>
Signed-off-by: Marcin Wojtas <mw@semihalf.com>
Cc: stable@vger.kernel.org
---
 drivers/mmc/host/sdhci-xenon.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
index c67611fdaa8a..4b05f6fdefb4 100644
--- a/drivers/mmc/host/sdhci-xenon.c
+++ b/drivers/mmc/host/sdhci-xenon.c
@@ -168,7 +168,12 @@ static void xenon_reset_exit(struct sdhci_host *host,
 	/* Disable tuning request and auto-retuning again */
 	xenon_retune_setup(host);
 
-	xenon_set_acg(host, true);
+	/*
+	 * The ACG should be turned off at the early init time, in order
+	 * to solve a possile issues with the 1.8V regulator stabilization.
+	 * The feature is enabled in later stage.
+	 */
+	xenon_set_acg(host, false);
 
 	xenon_set_sdclk_off_idle(host, sdhc_id, false);
 
-- 
2.29.0

