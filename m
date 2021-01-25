Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55B6304B7B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbhAZEpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:45:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbhAYSmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 405BD22DFB;
        Mon, 25 Jan 2021 18:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600096;
        bh=wIHh+KQjrVFmOelSb4V1rqtzZbowfP2OvdFwfFONFTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ft6dQrPKZfACo98dL1/wUYTvRMOPDISWcPfNw3yn1o8Kx26S4Utedtu6h2YprVAh0
         6yNg4xagZ+59+sKPKeq78ASRRs+2N97qkjLER/taYJr+zIJ0ZfH0jjiZxAFTo1TJ7k
         ZflntvJtOaGMVC+dPncxaprhw77PP5Gw6DzrbT1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Leibovich <alexl@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 07/58] mmc: sdhci-xenon: fix 1.8v regulator stabilization
Date:   Mon, 25 Jan 2021 19:39:08 +0100
Message-Id: <20210125183157.018313665@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Leibovich <alexl@marvell.com>

commit 1a3ed0dc3594d99ff341ec63865a40519ea24b8d upstream.

Automatic Clock Gating is a feature used for the power consumption
optimisation. It turned out that during early init phase it may prevent the
stable voltage switch to 1.8V - due to that on some platforms an endless
printout in dmesg can be observed: "mmc1: 1.8V regulator output did not
became stable" Fix the problem by disabling the ACG at very beginning of
the sdhci_init and let that be enabled later.

Fixes: 3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
Signed-off-by: Alex Leibovich <alexl@marvell.com>
Signed-off-by: Marcin Wojtas <mw@semihalf.com>
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20201211141656.24915-1-mw@semihalf.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-xenon.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-xenon.c
+++ b/drivers/mmc/host/sdhci-xenon.c
@@ -170,7 +170,12 @@ static void xenon_reset_exit(struct sdhc
 	/* Disable tuning request and auto-retuning again */
 	xenon_retune_setup(host);
 
-	xenon_set_acg(host, true);
+	/*
+	 * The ACG should be turned off at the early init time, in order
+	 * to solve a possible issues with the 1.8V regulator stabilization.
+	 * The feature is enabled in later stage.
+	 */
+	xenon_set_acg(host, false);
 
 	xenon_set_sdclk_off_idle(host, sdhc_id, false);
 


