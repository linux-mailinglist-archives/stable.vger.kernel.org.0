Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4642A5662
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgKCV1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:27:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732408AbgKCVBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:01:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69A6D21534;
        Tue,  3 Nov 2020 21:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437263;
        bh=UcQyCLTgQwryco3Bwhib+f4CDyGs+CCQGb+72ObgDws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8U74sAQf803XeeRA6sTMOA7kZfgNBSroS+CyW5Rr/Lnm4IeoPb5riQdrr/1kUnM7
         nu0bej6CzPbUM1wwNRqJzBDOFf9+gjHPAyMFu7Guhx19b77J+0nta4o2BTxHWiPvIc
         55ANezPziRhUHJZCoBLGD+DDEEzMKHCdcFNZSObs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 198/214] mmc: sdhci: Use Auto CMD Auto Select only when v4_mode is true
Date:   Tue,  3 Nov 2020 21:37:26 +0100
Message-Id: <20201103203309.204457298@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

commit b3e1ea16fb39fb6e1a1cf1dbdd6738531de3dc7d upstream.

sdhci-of-dwcmshc meets an eMMC read performance regression with below
command after commit 427b6514d095 ("mmc: sdhci: Add Auto CMD Auto
Select support"):

dd if=/dev/mmcblk0 of=/dev/null bs=8192 count=100000

Before the commit, the above command gives 120MB/s
After the commit, the above command gives 51.3 MB/s

So it looks like sdhci-of-dwcmshc expects Version 4 Mode for Auto
CMD Auto Select. Fix the performance degradation by ensuring v4_mode
is true to use Auto CMD Auto Select.

Fixes: 427b6514d095 ("mmc: sdhci: Add Auto CMD Auto Select support")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201015174115.4cf2c19a@xhacker.debian
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1162,9 +1162,11 @@ static inline void sdhci_auto_cmd_select
 	/*
 	 * In case of Version 4.10 or later, use of 'Auto CMD Auto
 	 * Select' is recommended rather than use of 'Auto CMD12
-	 * Enable' or 'Auto CMD23 Enable'.
+	 * Enable' or 'Auto CMD23 Enable'. We require Version 4 Mode
+	 * here because some controllers (e.g sdhci-of-dwmshc) expect it.
 	 */
-	if (host->version >= SDHCI_SPEC_410 && (use_cmd12 || use_cmd23)) {
+	if (host->version >= SDHCI_SPEC_410 && host->v4_mode &&
+	    (use_cmd12 || use_cmd23)) {
 		*mode |= SDHCI_TRNS_AUTO_SEL;
 
 		ctrl2 = sdhci_readw(host, SDHCI_HOST_CONTROL2);


