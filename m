Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E682A394C1E
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 14:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhE2MII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 08:08:08 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:60037 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2MIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 08:08:07 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 41A60100D9419;
        Sat, 29 May 2021 14:06:29 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 07A4832395; Sat, 29 May 2021 14:06:29 +0200 (CEST)
Date:   Sat, 29 May 2021 14:06:29 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     gregkh@linuxfoundation.org
Cc:     broonie@kernel.org, miaoqinglang@huawei.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: mt7621: Disable clock in probe error
 path" failed to apply to 4.19-stable tree
Message-ID: <20210529120629.GA31339@wunner.de>
References: <1609153628110242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609153628110242@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 12:07:08PM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's the backport of 24f7033405ab to v4.19.192:

-- >8 --
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:13 +0100
Subject: [PATCH] spi: mt7621: Disable clock in probe error path

commit 24f7033405abe195224ec793dbc3d7a27dec0b98 upstream.

Commit 702b15cb9712 ("spi: mt7621: fix missing clk_disable_unprepare()
on error in mt7621_spi_probe") sought to disable the SYS clock on probe
errors, but only did so for 2 of 3 potentially failing calls:  The clock
needs to be disabled on failure of spi_register_master() as well.

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
[lukas: backport to v4.19.192]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/staging/mt7621-spi/spi-mt7621.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/mt7621-spi/spi-mt7621.c b/drivers/staging/mt7621-spi/spi-mt7621.c
index 33c747bc8320..ebfbe5ee479a 100644
--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -487,7 +487,11 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 
 	mt7621_spi_reset(rs, 0);
 
-	return spi_register_master(master);
+	ret = spi_register_master(master);
+	if (ret)
+		clk_disable_unprepare(clk);
+
+	return ret;
 }
 
 static int mt7621_spi_remove(struct platform_device *pdev)
-- 
2.31.1

