Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD5713FFB1
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgAPXXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729898AbgAPXXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E502072B;
        Thu, 16 Jan 2020 23:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217020;
        bh=4F1x+1e9MlodvRYbFLGlfon2lSXYRDNTh0lT5u9gFfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYJ7/w2IlYzRf46+M8LiekP7txru2/0I5V69g9JyzwyiDLVaGWdqdBR/kbz1vgAtJ
         gc6//sv8a/ayNu2P3Eaqc126qN4sU7AnHopR0g7CjtiafHbuyFOnRwds1x3yjhUP7L
         Zv7Pdk66lDXIHpjeRT6P4rxHhl91pWhWa4V45uCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.4 115/203] dmaengine: dw: platform: Mark hclk clock optional
Date:   Fri, 17 Jan 2020 00:17:12 +0100
Message-Id: <20200116231755.463864006@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit f27c22736d133baff0ab3fdc7b015d998267d817 upstream.

On some platforms the clock can be fixed rate, always running one and
there is no need to do anything with it.

In order to support those platforms, switch to use optional clock.

Fixes: f8d9ddbc2851 ("dmaengine: dw: platform: Enable iDMA 32-bit on Intel Elkhart Lake")
Depends-on: 60b8f0ddf1a9 ("clk: Add (devm_)clk_get_optional() functions")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://lore.kernel.org/r/20190924085116.83683-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dw/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -66,7 +66,7 @@ static int dw_probe(struct platform_devi
 
 	data->chip = chip;
 
-	chip->clk = devm_clk_get(chip->dev, "hclk");
+	chip->clk = devm_clk_get_optional(chip->dev, "hclk");
 	if (IS_ERR(chip->clk))
 		return PTR_ERR(chip->clk);
 	err = clk_prepare_enable(chip->clk);


