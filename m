Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B71D22EFA9
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgG0OSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731170AbgG0OSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:18:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA4DB2070A;
        Mon, 27 Jul 2020 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859486;
        bh=aH9N2X8cK9yWknxgS/kGhUdLd4Tp5DOTt7iEgW0I6Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktsnJ8EqCkXMVOH7MpGQGjU5iDSvQq/PaKWJM0df9Dtymt4etSHLP4cIs6muT9J50
         ep9C5IyTYeogaaH5I37deqOftU0CriliBY3XeBwZp8StL/5K7cyi1U62mmUwctjAsF
         mvHg0oG/7Mz5YUx2M7pxr6HunLcS9Tix9ginayZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 127/138] mmc: sdhci-of-aspeed: Fix clock divider calculation
Date:   Mon, 27 Jul 2020 16:05:22 +0200
Message-Id: <20200727134931.778827641@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie James <eajames@linux.ibm.com>

commit ebd4050c6144b38098d8eed34df461e5e3fa82a9 upstream.

When calculating the clock divider, start dividing at 2 instead of 1.
The divider is divided by two at the end of the calculation, so starting
at 1 may result in a divider of 0, which shouldn't happen.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Andrew Jeffery <andrew@aj.id.au>
Acked-by: Joel Stanley <joel@jms.id.au>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200709195706.12741-3-eajames@linux.ibm.com
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-aspeed.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-aspeed.c
+++ b/drivers/mmc/host/sdhci-of-aspeed.c
@@ -68,7 +68,7 @@ static void aspeed_sdhci_set_clock(struc
 	if (WARN_ON(clock > host->max_clk))
 		clock = host->max_clk;
 
-	for (div = 1; div < 256; div *= 2) {
+	for (div = 2; div < 256; div *= 2) {
 		if ((parent / div) <= clock)
 			break;
 	}


