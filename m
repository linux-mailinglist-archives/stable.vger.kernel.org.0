Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6739601C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhEaOWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233033AbhEaORl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13363619AF;
        Mon, 31 May 2021 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468626;
        bh=Tw1m8lGwCOODsUpAjhAhIZd9AtVXP8hkFAvRZXBJgo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M16pAr8KmSRnDQCZAq6NvoZ0JQmFbPBpHANHg0bwQVS1i4mYIdS9NnDx6NQjNy1t6
         XOBBx5suwYOPaDR4YM1mIVyBzDSz6hEEueleinZHIUraW1BOo/RPLm4yMUdQ1Wrwme
         +Y98PvblLQVnGR8cYD1CM29up/POU3MJIDUOr8/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Girish Mahadevan <girishm@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 064/177] spi: spi-geni-qcom: Fix use-after-free on unbind
Date:   Mon, 31 May 2021 15:13:41 +0200
Message-Id: <20210531130650.118413088@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 8f96c434dfbc85ffa755d6634c8c1cb2233fcf24 upstream.

spi_geni_remove() accesses the driver's private data after calling
spi_unregister_master() even though that function releases the last
reference on the spi_master and thereby frees the private data.

Moreover, since commit 1a9e489e6128 ("spi: spi-geni-qcom: Use OPP API to
set clk/perf state"), spi_geni_probe() leaks the spi_master allocation
if the calls to dev_pm_opp_set_clkname() or dev_pm_opp_of_add_table()
fail.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound and also
avoids the spi_master leak on probe.

Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.20+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Rajendra Nayak <rnayak@codeaurora.org>
Cc: Girish Mahadevan <girishm@codeaurora.org>
Link: https://lore.kernel.org/r/dfa1d8c41b8acdfad87ec8654cd124e6e3cb3f31.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to v5.4.123]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-geni-qcom.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/spi/spi-geni-qcom.c
+++ b/drivers/spi/spi-geni-qcom.c
@@ -552,7 +552,7 @@ static int spi_geni_probe(struct platfor
 		return PTR_ERR(clk);
 	}
 
-	spi = spi_alloc_master(&pdev->dev, sizeof(*mas));
+	spi = devm_spi_alloc_master(&pdev->dev, sizeof(*mas));
 	if (!spi)
 		return -ENOMEM;
 
@@ -599,7 +599,6 @@ spi_geni_probe_free_irq:
 	free_irq(mas->irq, spi);
 spi_geni_probe_runtime_disable:
 	pm_runtime_disable(&pdev->dev);
-	spi_master_put(spi);
 	return ret;
 }
 


