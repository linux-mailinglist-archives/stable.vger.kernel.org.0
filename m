Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AC32E42C6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392632AbgL1P1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:27:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406652AbgL1N5Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6AAD22AAA;
        Mon, 28 Dec 2020 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163803;
        bh=ohAf4PqIY0e3xX5N4dK2Ghc2vU/y1SbUlJb42ulvZmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fu9/qrJTdLYJ2T92ZfLnnJa+mHHsAM4K9mYuuwHLifVzmymPmhYsBqYQEYcnFIsEL
         KMiBPZVRyJye0H6rKjg352VvI5/2kt03ade4RMqXbvwM7HrfqLqiyJ4ZQSIsu3rdIY
         C9cHzkNBZiL87Nsw1BvlGqvd3RHemcPG5upDtfyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 413/453] spi: mt7621: Disable clock in probe error path
Date:   Mon, 28 Dec 2020 13:50:49 +0100
Message-Id: <20201228124957.091284992@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 24f7033405abe195224ec793dbc3d7a27dec0b98 upstream.

Commit 702b15cb9712 ("spi: mt7621: fix missing clk_disable_unprepare()
on error in mt7621_spi_probe") sought to disable the SYS clock on probe
errors, but only did so for 2 of 3 potentially failing calls:  The clock
needs to be disabled on failure of devm_spi_register_controller() as
well.

Moreover, the commit purports to fix a bug in commit cbd66c626e16 ("spi:
mt7621: Move SPI driver out of staging") but in reality the bug has
existed since the driver was first introduced.

Fixes: 1ab7f2a43558 ("staging: mt7621-spi: add mt7621 support")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.17+: 702b15cb9712: spi: mt7621: fix missing clk_disable_unprepare() on error in mt7621_spi_probe
Cc: <stable@vger.kernel.org> # v4.17+
Cc: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/36ad42760087952fb7c10aae7d2628547c26a7ec.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-mt7621.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -382,7 +382,11 @@ static int mt7621_spi_probe(struct platf
 		return ret;
 	}
 
-	return devm_spi_register_controller(&pdev->dev, master);
+	ret = devm_spi_register_controller(&pdev->dev, master);
+	if (ret)
+		clk_disable_unprepare(clk);
+
+	return ret;
 }
 
 static int mt7621_spi_remove(struct platform_device *pdev)


