Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEDB92A52B9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbgKCUwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732109AbgKCUwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 537E92053B;
        Tue,  3 Nov 2020 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436756;
        bh=TQuy0xxKzG1kB4DX7dwlEHjNfxPdFAfGr6t5XhepVyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PptA5sJGX7+coA+rNZqkPODNikKETx8aOuUV0J45iqrQhVSEn1lAC2m/rvURfRHzB
         yRBHW2DJJtTRxwSL47YN4MFydc6wxah/NaKpAmf7Rz7lPipO+8ShbMOqsynkOTxFVb
         BFX3Zl7vBRu/eyoIBIRc4X7j/b34NmqPlApzaHts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.9 351/391] mmc: sdhci-of-esdhc: set timeout to max before tuning
Date:   Tue,  3 Nov 2020 21:36:42 +0100
Message-Id: <20201103203410.822522977@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit 0add6e9b88d0632a25323aaf4987dbacb0e4ae64 upstream.

On rare occations there is the following error:

  mmc0: Tuning timeout, falling back to fixed sampling clock

There are SD cards which takes a significant longer time to reply to the
first CMD19 command. The eSDHC takes the data timeout value into account
during the tuning period. The SDHCI core doesn't explicitly set this
timeout for the tuning procedure. Thus on the slow cards, there might be
a spurious "Buffer Read Ready" interrupt, which in turn triggers a wrong
sequence of events. In the end this will lead to an unsuccessful tuning
procedure and to the above error.

To workaround this, set the timeout to the maximum value (which is the
best we can do) and the SDHCI core will take care of the proper timeout
handling.

Fixes: ba49cbd0936e ("mmc: sdhci-of-esdhc: add tuning support")
Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201022222337.19857-1-michael@walle.cc
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-esdhc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -1069,6 +1069,17 @@ static int esdhc_execute_tuning(struct m
 
 	esdhc_tuning_block_enable(host, true);
 
+	/*
+	 * The eSDHC controller takes the data timeout value into account
+	 * during tuning. If the SD card is too slow sending the response, the
+	 * timer will expire and a "Buffer Read Ready" interrupt without data
+	 * is triggered. This leads to tuning errors.
+	 *
+	 * Just set the timeout to the maximum value because the core will
+	 * already take care of it in sdhci_send_tuning().
+	 */
+	sdhci_writeb(host, 0xe, SDHCI_TIMEOUT_CONTROL);
+
 	hs400_tuning = host->flags & SDHCI_HS400_TUNING;
 
 	do {


