Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE11F2E3F58
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503547AbgL1OjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503488AbgL1O35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:29:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8326B221F0;
        Mon, 28 Dec 2020 14:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165782;
        bh=2Bklf9DCJXUl3thJCI/qgi4JWKZUxw/j6HvbSQKMAW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBNRQEXoINT3MAJ9Tu6pt8E6aYCV26WykJ/fIWjFVLWT2mRQRSMBrDnkdnaHeXZR7
         +iINHngTD5RVviaRQ6vhARw90vaWr7cgqHI97vBoBrQjyNcN0LO7xQ+3uC85FZ8dS0
         FvYKoD/4QpfyMkD0DpBUanpoAQQyzkrkbCwbyTDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Sergei Shtylyov <s.shtylyov@omprussia.ru>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 653/717] spi: rpc-if: Fix use-after-free on unbind
Date:   Mon, 28 Dec 2020 13:50:51 +0100
Message-Id: <20201228125052.229988513@linuxfoundation.org>
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

commit 393f981ca5f797b58b882d42b7621fb6e43c7f5b upstream.

rpcif_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master() helper which
keeps the private data accessible until the driver has unbound.

Fixes: eb8d6d464a27 ("spi: add Renesas RPC-IF driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v5.9+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v5.9+
Cc: Sergei Shtylyov <s.shtylyov@omprussia.ru>
Link: https://lore.kernel.org/r/c5da472c28021da2f6517441685cef033d40b140.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-rpc-if.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -134,7 +134,7 @@ static int rpcif_spi_probe(struct platfo
 	struct rpcif *rpc;
 	int error;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*rpc));
+	ctlr = devm_spi_alloc_master(&pdev->dev, sizeof(*rpc));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -159,13 +159,8 @@ static int rpcif_spi_probe(struct platfo
 	error = spi_register_controller(ctlr);
 	if (error) {
 		dev_err(&pdev->dev, "spi_register_controller failed\n");
-		goto err_put_ctlr;
+		rpcif_disable_rpm(rpc);
 	}
-	return 0;
-
-err_put_ctlr:
-	rpcif_disable_rpm(rpc);
-	spi_controller_put(ctlr);
 
 	return error;
 }


