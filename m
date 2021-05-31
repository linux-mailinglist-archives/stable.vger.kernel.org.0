Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2809395C7E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhEaNdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232388AbhEaNbc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFD1B61432;
        Mon, 31 May 2021 13:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467427;
        bh=nnoVf5A9vs+dxKUhBfxsHFDLJkya+4vCJ8gyjvA8ur8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4cXBhsKuC69O1xHnCsaF2I2F8YqGKssXkfLGt98yNhcXTs1cuB3pRNg4oL4bQUq2
         zOFd7uNe0UynEJ+kVKCZOY+vIrv/Y2otXRUjWgBX+73wIVMIvq5WRuVGEX0VNNjXI9
         tHIMYjXDzxdPRD01XV0IpQEHcAKoXKOkVgcJJVs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 060/116] spi: mt7621: Disable clock in probe error path
Date:   Mon, 31 May 2021 15:13:56 +0200
Message-Id: <20210531130642.207493188@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
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
[lukas: backport to v4.19.192]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-spi/spi-mt7621.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -487,7 +487,11 @@ static int mt7621_spi_probe(struct platf
 
 	mt7621_spi_reset(rs, 0);
 
-	return spi_register_master(master);
+	ret = spi_register_master(master);
+	if (ret)
+		clk_disable_unprepare(clk);
+
+	return ret;
 }
 
 static int mt7621_spi_remove(struct platform_device *pdev)


