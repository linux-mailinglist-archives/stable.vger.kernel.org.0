Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24EB99BF4
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390590AbfHVR3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404697AbfHVR0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:26:19 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7FB423400;
        Thu, 22 Aug 2019 17:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494779;
        bh=y/o8gR2vvWI7XQe4CdqvH2MvoSSYXk9D2PFtuVz2B2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2b8MmEQlJWiccxkPJ3HCE2zrITcpWZcFG6Tr2iS4vsxpPUQVJ421BtUh0VT1wrZ6Z
         heKAknghn7HCgaEgS5PwUvudWfDKOgrUgXj2XlyYuXippT8A4+5y14F0IvtnragNqF
         kJ+XFHR79OuFSjHEn89URBpJbcHRJQYQnkkTqhD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.19 85/85] mmc: sdhci-of-arasan: Do now show error message in case of deffered probe
Date:   Thu, 22 Aug 2019 10:19:58 -0700
Message-Id: <20190822171734.734466747@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171731.012687054@linuxfoundation.org>
References: <20190822171731.012687054@linuxfoundation.org>
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
@@ -788,7 +788,8 @@ static int sdhci_arasan_probe(struct pla
 
 	ret = mmc_of_parse(host->mmc);
 	if (ret) {
-		dev_err(&pdev->dev, "parsing dt failed (%d)\n", ret);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "parsing dt failed (%d)\n", ret);
 		goto unreg_clk;
 	}
 


