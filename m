Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D602F313
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfE3DOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729899AbfE3DOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:33 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D0724502;
        Thu, 30 May 2019 03:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186072;
        bh=ZxoC2ZaChE0LSaUH//IepsBvmghb26/EDzC/WkcZoNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/FKJ7Ksp0cYUojTkdti/H+HRfd8O9XKfdcHEYj1YtXuUe6qwVznL5bnylXCtpt+Z
         i6+PIhRJx7XjZN/k7lLpoZWOOANtfyJ1h2L+CZH2Et2IIKMFyleqpM2rRjXSl4tT73
         AoZwvMUaaQOdYrxfQWFImcsmvKanC+FzTcr4EIcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 187/346] mmc_spi: add a status check for spi_sync_locked
Date:   Wed, 29 May 2019 20:04:20 -0700
Message-Id: <20190530030550.560021646@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 611025983b7976df0183390a63a2166411d177f1 ]

In case spi_sync_locked fails, the fix reports the error and
returns the error code upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mmc_spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 8ade14fb2148d..3410e21515795 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -819,6 +819,10 @@ mmc_spi_readblock(struct mmc_spi_host *host, struct spi_transfer *t,
 	}
 
 	status = spi_sync_locked(spi, &host->m);
+	if (status < 0) {
+		dev_dbg(&spi->dev, "read error %d\n", status);
+		return status;
+	}
 
 	if (host->dma_dev) {
 		dma_sync_single_for_cpu(host->dma_dev,
-- 
2.20.1



