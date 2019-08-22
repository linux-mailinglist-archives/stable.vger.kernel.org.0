Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2233D99C83
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391639AbfHVRe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391839AbfHVRZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:25:15 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A4242064A;
        Thu, 22 Aug 2019 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494714;
        bh=L8KNJQqZq4g+oYpcWRJKSAmbT9LsK86v1HqLWj25K2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zET46HfAtL4Z0CoFoFlB387D4AbfTPDvzlbGkah9KuZ3WQ3i/kxpYIt+sX9FzZ5Gq
         TsmF1b7QaBAdViU1r5EJuNBoQAMl//inW7fGEnUGg4u3Ng8Mi3P15v6Jazt037NCHq
         XK9l1A3lDkwwAMu5Jxe6g+rpLgK2WOl1rWJm7H0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 70/71] mmc: sdhci-of-arasan: Do now show error message in case of deffered probe
Date:   Thu, 22 Aug 2019 10:19:45 -0700
Message-Id: <20190822171730.744747146@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171726.131957995@linuxfoundation.org>
References: <20190822171726.131957995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

commit 60208a267208c27fa3f23dfd36cbda180471fa98 upstream.

When mmc-pwrseq property is passed mmc_pwrseq_alloc() can return
-EPROBE_DEFER because driver for power sequence provider is not probed
yet. Do not show error message when this situation happens.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-of-arasan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-of-arasan.c
+++ b/drivers/mmc/host/sdhci-of-arasan.c
@@ -638,7 +638,8 @@ static int sdhci_arasan_probe(struct pla
 
 	ret = mmc_of_parse(host->mmc);
 	if (ret) {
-		dev_err(&pdev->dev, "parsing dt failed (%d)\n", ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "parsing dt failed (%d)\n", ret);
 		goto unreg_clk;
 	}
 


