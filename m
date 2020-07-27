Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F62722F092
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732479AbgG0OZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731876AbgG0OZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:25:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8421207FC;
        Mon, 27 Jul 2020 14:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859944;
        bh=aH9N2X8cK9yWknxgS/kGhUdLd4Tp5DOTt7iEgW0I6Q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xamtOT0S8Nwv2Wew5yJ23K4cw2cz6n9PQ6JLdTtynZDEWRG/p41TFNwwCrfTxG5Gl
         Gfivwlo3G3KMNzBX08DMkESfWX/43zC6WtQNNmhdCwhf1eJPKhP77hdNz0AnfrJaBH
         dro+dIntJzxKDKToopaLcDI8D71qdb4LqN2IPiyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.7 166/179] mmc: sdhci-of-aspeed: Fix clock divider calculation
Date:   Mon, 27 Jul 2020 16:05:41 +0200
Message-Id: <20200727134940.746906590@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
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


