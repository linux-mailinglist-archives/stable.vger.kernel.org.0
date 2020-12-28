Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C63F2E3EAE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503615AbgL1OaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503596AbgL1OaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC3B722583;
        Mon, 28 Dec 2020 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165798;
        bh=ohAf4PqIY0e3xX5N4dK2Ghc2vU/y1SbUlJb42ulvZmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQUNPoe/QQssnj70eO9Z0BYfCUkyI9+tM5mKiv1fvrblNRBnXJoaNPYXqgpnvj9o7
         yBWunW25OFNpqhQ4RtkvpVB1xb1sjpj/BRRvLn9de8flqg6H2evRDrXa0UeykHk1sQ
         DpajYX0c1bBCnYXcB2SaJVK3R7k1uJSOoK7zLNMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 659/717] spi: mt7621: Disable clock in probe error path
Date:   Mon, 28 Dec 2020 13:50:57 +0100
Message-Id: <20201228125052.533439362@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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


