Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61018304B3F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbhAZEsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:48:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729855AbhAYSp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:45:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB8BF20719;
        Mon, 25 Jan 2021 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600286;
        bh=mSyYz7o+5VCrYCB8JhJKofsluDqZot6dmzURsiJwzNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZSxL8H0SW56z8UhhUpKt/MxxNJKjEubWb4WQf5ZerXCw0cMPPw7hdOH3cqtabEHR
         elt0NpZ1+QnrAuNWCyRAeUkWJoEr6v5YR3dSD9wYdkf7G9G5RLcQ3C52Gm1e5kzwZi
         artG72zZh6xCUq6AII27q0MReyfgUpkXX2tncHA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Leibovich <alexl@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 12/86] mmc: sdhci-xenon: fix 1.8v regulator stabilization
Date:   Mon, 25 Jan 2021 19:38:54 +0100
Message-Id: <20210125183201.557581602@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
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
@@ -167,7 +167,12 @@ static void xenon_reset_exit(struct sdhc
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
 


