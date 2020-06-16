Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA771FB910
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbgFPQAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732787AbgFPPwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:52:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEEC0208D5;
        Tue, 16 Jun 2020 15:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322756;
        bh=ImD1zoy+Fx0CsZrmk+QIEfgyjaPXOBH8d6zBqOiEGqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCNvlJT1j+sEKy+nd47kQpf9iOMiuXkVFWzdTMZ5ik78JLm5+wv08xzAYhnhjFUyh
         Z6jjdfz9j4KgTZJjFjl328ZyP22ZWo6iJm1GtUZgmPs06TTQIYzIXif4FywjFsjKPh
         WefNDB0w+xA92IfZbYfSIETHPdzN89Xb9dI74NlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Kamal Dasu <kdasu.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 091/161] spi: bcm-qspi: Handle clock probe deferral
Date:   Tue, 16 Jun 2020 17:34:41 +0200
Message-Id: <20200616153110.713624489@linuxfoundation.org>
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

From: Florian Fainelli <f.fainelli@gmail.com>

commit 0392727c261bab65a35cd4f82ee9459bc237591d upstream.

The clock provider may not be ready by the time spi-bcm-qspi gets
probed, handle probe deferral using devm_clk_get_optional().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200420190853.45614-2-kdasu.kdev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm-qspi.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1222,6 +1222,11 @@ int bcm_qspi_probe(struct platform_devic
 	}
 
 	qspi = spi_master_get_devdata(master);
+
+	qspi->clk = devm_clk_get_optional(&pdev->dev, NULL);
+	if (IS_ERR(qspi->clk))
+		return PTR_ERR(qspi->clk);
+
 	qspi->pdev = pdev;
 	qspi->trans_pos.trans = NULL;
 	qspi->trans_pos.byte = 0;
@@ -1335,13 +1340,6 @@ int bcm_qspi_probe(struct platform_devic
 		qspi->soc_intc = NULL;
 	}
 
-	qspi->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(qspi->clk)) {
-		dev_warn(dev, "unable to get clock\n");
-		ret = PTR_ERR(qspi->clk);
-		goto qspi_probe_err;
-	}
-
 	ret = clk_prepare_enable(qspi->clk);
 	if (ret) {
 		dev_err(dev, "failed to prepare clock\n");


