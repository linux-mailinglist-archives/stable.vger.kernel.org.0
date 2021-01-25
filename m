Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7FE303376
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbhAZEyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730827AbhAYSsm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 089F12083E;
        Mon, 25 Jan 2021 18:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600479;
        bh=mSyYz7o+5VCrYCB8JhJKofsluDqZot6dmzURsiJwzNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUHUVFXuuS6yD34wmAo0KjerW5HHDgXCF7TD9EUFcezKJ7nWbPK5ZxuiGv5ePom9H
         b/N5uBt19eOXSDZ8fXEnY9lEQkhBk0rIbbOpNCDAHQkKMcAil3HTlhUc6D6MsiJ6x3
         cNNM2lYcbgpJrx79UPb8/v8YIGTD24noan3Gop0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Leibovich <alexl@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 023/199] mmc: sdhci-xenon: fix 1.8v regulator stabilization
Date:   Mon, 25 Jan 2021 19:37:25 +0100
Message-Id: <20210125183217.234093365@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
 


