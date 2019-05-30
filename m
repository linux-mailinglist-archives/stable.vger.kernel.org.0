Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90472F5C3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfE3DLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbfE3DLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:06 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90DC5244C0;
        Thu, 30 May 2019 03:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185865;
        bh=3Ug7Ye9KIhsCFYIiXw0whWZlxMXT/aOV+cnPRg6I/Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tg6m+DvshamAxGEzfHk+diqbqNmrHxLhWetNt97bcWKkQvvgDaG8r17f7uql/3hE6
         qt1dEAzbKkYI5G6/2xShDpZa6MiFQULq+yS3nCLLBpqWGpa8rTy+oZuUdX1KTDVVvp
         fPXsn3QqiAKD+FMObe10qJjBVx6F3s7HlQ0t7Mic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 204/405] mmc_spi: add a status check for spi_sync_locked
Date:   Wed, 29 May 2019 20:03:22 -0700
Message-Id: <20190530030551.474918592@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 1b1498805972c..a3533935e282b 100644
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



