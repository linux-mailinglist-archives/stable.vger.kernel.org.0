Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E48F1FB852
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731976AbgFPPzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733057AbgFPPzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:55:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E3BE21527;
        Tue, 16 Jun 2020 15:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322908;
        bh=xYS3Tx+6c+n0PX+mjHLsEGNYvp72fAS6iv1Z56pfdd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sz85KmjgQOop/348UlRfVaJS+manF5QLR2t7xG8Fkck1aEfsRgVXIKwacjeAPNX5H
         Ah5nU6rb78Cvmx3IjK15rktnMh6yYtPr+/cTB0FKbCFSYHt6R7Es5Uand/L9SgLdP7
         7Ce5Fk+5y4NPlaCLH4a//O3307rQi9cII4yZEF+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ludovic Barre <ludovic.barre@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.6 150/161] mmc: mmci_sdmmc: fix DMA API warning overlapping mappings
Date:   Tue, 16 Jun 2020 17:35:40 +0200
Message-Id: <20200616153113.486051214@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Barre <ludovic.barre@st.com>

commit fe8d33bd33d527dee3155d2bccd714a655f37334 upstream.

Turning on CONFIG_DMA_API_DEBUG_SG results in the following warning:
WARNING: CPU: 1 PID: 20 at kernel/dma/debug.c:500 add_dma_entry+0x16c/0x17c
DMA-API: exceeded 7 overlapping mappings of cacheline 0x031d2645
Modules linked in:
CPU: 1 PID: 20 Comm: kworker/1:1 Not tainted 5.5.0-rc2-00021-gdeda30999c2b-dirty #49
Hardware name: STM32 (Device Tree Support)
Workqueue: events_freezable mmc_rescan
[<c03138c0>] (unwind_backtrace) from [<c030d760>] (show_stack+0x10/0x14)
[<c030d760>] (show_stack) from [<c0f2eb28>] (dump_stack+0xc0/0xd4)
[<c0f2eb28>] (dump_stack) from [<c034a14c>] (__warn+0xd0/0xf8)
[<c034a14c>] (__warn) from [<c034a530>] (warn_slowpath_fmt+0x94/0xb8)
[<c034a530>] (warn_slowpath_fmt) from [<c03bca0c>] (add_dma_entry+0x16c/0x17c)
[<c03bca0c>] (add_dma_entry) from [<c03bdf54>] (debug_dma_map_sg+0xe4/0x3d4)
[<c03bdf54>] (debug_dma_map_sg) from [<c0d09244>] (sdmmc_idma_prep_data+0x94/0xf8)
[<c0d09244>] (sdmmc_idma_prep_data) from [<c0d05a2c>] (mmci_prep_data+0x2c/0xb0)
[<c0d05a2c>] (mmci_prep_data) from [<c0d073ec>] (mmci_start_data+0x134/0x2f0)
[<c0d073ec>] (mmci_start_data) from [<c0d078d0>] (mmci_request+0xe8/0x154)
[<c0d078d0>] (mmci_request) from [<c0cecb44>] (mmc_start_request+0x94/0xbc)

DMA api debug brings to light leaking dma-mappings, dma_map_sg and
dma_unmap_sg are not correctly balanced.

If a request is prepared, the dma_map/unmap are done in asynchronous call
pre_req (prep_data) and post_req (unprep_data). In this case the
dma-mapping is right balanced.

But if the request was not prepared, the data->host_cookie is define to
zero and the dma_map/unmap must be done in the request.  The dma_map is
called by mmci_dma_start (prep_data), but there is no dma_unmap in this
case.

This patch adds dma_unmap_sg when the dma is finalized and the data cookie
is zero (request not prepared).

Signed-off-by: Ludovic Barre <ludovic.barre@st.com>
Link: https://lore.kernel.org/r/20200526155103.12514-2-ludovic.barre@st.com
Fixes: 46b723dd867d ("mmc: mmci: add stm32 sdmmc variant")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/mmci_stm32_sdmmc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -162,6 +162,9 @@ static int sdmmc_idma_start(struct mmci_
 static void sdmmc_idma_finalize(struct mmci_host *host, struct mmc_data *data)
 {
 	writel_relaxed(0, host->base + MMCI_STM32_IDMACTRLR);
+
+	if (!data->host_cookie)
+		sdmmc_idma_unprep_data(host, data, 0);
 }
 
 static void mmci_sdmmc_set_clkreg(struct mmci_host *host, unsigned int desired)


