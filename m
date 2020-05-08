Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE47C1CAF91
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728922AbgEHMmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727832AbgEHMmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:42:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BBFE21835;
        Fri,  8 May 2020 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941736;
        bh=8foEsAd8ZvHE4lrTzJO6XC2ENSyWkAlDrCd0/G3I4Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8OsKsf/HQ3DB2XmrR10+L3Mz70+xqfUj4x1c/zwe+ecn8cihgBOYN2LH5QKPFaRt
         Qw7ZEP9sOCXQSK6EMpttTJj3OZFC4LXAtbyq5+TOyHjQSy16yJVoNpmvR3dnMfanVs
         G00SSIJmp19YroXYvyYARWQ2FrgufqmadlsKCH3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.4 144/312] mmc: moxart: fix wait_for_completion_interruptible_timeout return variable type
Date:   Fri,  8 May 2020 14:32:15 +0200
Message-Id: <20200508123134.596227100@linuxfoundation.org>
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

From: Nicholas Mc Guire <hofrat@osadl.org>

commit 41f469cac2663a41a7b0c84cb94e8f7024385ae4 upstream.

wait_for_completion_timeout_interruptible returns long not unsigned long
so dma_time, which is used exclusively here, is changed to long.

Fixes: 1b66e94e6b99 ("mmc: moxart: Add MOXA ART SD/MMC driver")
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/moxart-mmc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -257,7 +257,7 @@ static void moxart_dma_complete(void *pa
 static void moxart_transfer_dma(struct mmc_data *data, struct moxart_host *host)
 {
 	u32 len, dir_data, dir_slave;
-	unsigned long dma_time;
+	long dma_time;
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *dma_chan;
 
@@ -397,7 +397,8 @@ static void moxart_prepare_data(struct m
 static void moxart_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	struct moxart_host *host = mmc_priv(mmc);
-	unsigned long pio_time, flags;
+	long pio_time;
+	unsigned long flags;
 	u32 status;
 
 	spin_lock_irqsave(&host->lock, flags);


