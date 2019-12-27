Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0E212B7C9
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfL0RvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbfL0RnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DC4E24125;
        Fri, 27 Dec 2019 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468604;
        bh=w1xY86k7o2X3acrxEgJ49Coa7QPmcFApXCnQ410bYkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gII4N7y/AMMDBz+paF6LyzzfNHh5HTp4FUcYhRcz9P8++44E+fao8vFEmvCw35nBd
         Cv3xAtACqHji6RP5VbyjIVznzY039hyEkxeFSC5k3VEVwt9sqkvIoauuoVI16rzNIw
         Ou1TIeYdYcUExeOllQ1ToMd0qYrB8dg1R1q6Oe80=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 125/187] spi: nxp-fspi: Ensure width is respected in spi-mem operations
Date:   Fri, 27 Dec 2019 12:39:53 -0500
Message-Id: <20191227174055.4923-125-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 007773e16a6f3f49d1439554078c3ba8af131998 ]

Make use of a core helper to ensure the desired width is respected
when calling spi-mem operators.

Otherwise only the SPI controller will be matched with the flash chip,
which might lead to wrong widths. Also consider the width specified by
the user in the device tree.

Fixes: a5356aef6a90 ("spi: spi-mem: Add driver for NXP FlexSPI controller")
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20191211195730.26794-1-michael@walle.cc
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 501b923f2c27..28ae5229f889 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -439,7 +439,7 @@ static bool nxp_fspi_supports_op(struct spi_mem *mem,
 	    op->data.nbytes > f->devtype_data->txfifo)
 		return false;
 
-	return true;
+	return spi_mem_default_supports_op(mem, op);
 }
 
 /* Instead of busy looping invoke readl_poll_timeout functionality. */
-- 
2.20.1

