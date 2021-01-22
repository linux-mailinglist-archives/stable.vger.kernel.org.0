Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F7B300B6A
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbhAVSUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbhAVOXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FFD123A03;
        Fri, 22 Jan 2021 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325025;
        bh=cG9JyASyOeTvySf38gpC0E17w5y4mK5r8LNBvZZPkk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhAzHZCgjlR+hFKKpL7cg6i4n7JnK7m87smfaaKJKL6MFLGXsV6zwhk5emnL5HLDh
         9M3uuEW6Dcmsiw/uK78tR2ECBbSd2Dxkf6KevDwnpOvsOkXIYG+w49XBh+MtWwGf36
         0G3mlc8gw0LwaRbCEAgdcpqOa4FaYlBve7ehnyIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 08/33] spi: npcm-fiu: Disable clock in probe error path
Date:   Fri, 22 Jan 2021 15:12:24 +0100
Message-Id: <20210122135733.902351505@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 234266a5168bbe8220d263e3aa7aa80cf921c483 upstream

If the call to devm_spi_register_master() fails on probe of the NPCM FIU
SPI driver, the clock "fiu->clk" is erroneously not unprepared and
disabled.  Fix it.

Fixes: ace55c411b11 ("spi: npcm-fiu: add NPCM FIU controller driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Tomer Maimon <tmaimon77@gmail.com>
Link: https://lore.kernel.org/r/9ae62f4e1cfe542bec57ac2743e6fca9f9548f55.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-npcm-fiu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-npcm-fiu.c
+++ b/drivers/spi/spi-npcm-fiu.c
@@ -677,7 +677,7 @@ static int npcm_fiu_probe(struct platfor
 	struct npcm_fiu_spi *fiu;
 	void __iomem *regbase;
 	struct resource *res;
-	int id;
+	int id, ret;
 
 	ctrl = devm_spi_alloc_master(dev, sizeof(*fiu));
 	if (!ctrl)
@@ -735,7 +735,11 @@ static int npcm_fiu_probe(struct platfor
 	ctrl->num_chipselect = fiu->info->max_cs;
 	ctrl->dev.of_node = dev->of_node;
 
-	return devm_spi_register_master(dev, ctrl);
+	ret = devm_spi_register_master(dev, ctrl);
+	if (ret)
+		clk_disable_unprepare(fiu->clk);
+
+	return ret;
 }
 
 static int npcm_fiu_remove(struct platform_device *pdev)


