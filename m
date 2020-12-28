Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950DB2E3F3C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504641AbgL1OcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504637AbgL1OcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD0620731;
        Mon, 28 Dec 2020 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165919;
        bh=aVRzW08YkAx8xT5rReD7QzmB1/2mc4eTf5Elk/gwka4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhDi2TtNJF1xoLmxrMkugrZOS2Kv+vwACDqeXxi84dA/lfuyCBJmiNez1vDAEktMJ
         m1unc5fqDoEBHEDtDbzFVTD64J+7XoyIRW8EJS/KTYwoZQSGnTaCGoEQkINnQechc/
         YPM6zyd44AsIdmBlAwmhIzWRivjNVtdtP2OnTogg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.10 701/717] memory: jz4780_nemc: Fix an error pointer vs NULL check in probe()
Date:   Mon, 28 Dec 2020 13:51:39 +0100
Message-Id: <20201228125054.567961515@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 96999c797ec1ef41259f00b4ddf9cf33b342cb78 upstream.

The devm_ioremap() function returns NULL on error, it doesn't return
error pointers.  This bug could lead to an Oops during probe.

Fixes: f046e4a3f0b9 ("memory: jz4780_nemc: Only request IO memory the driver will use")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Link: https://lore.kernel.org/r/20200803143607.GC346925@mwanda
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/jz4780-nemc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/memory/jz4780-nemc.c
+++ b/drivers/memory/jz4780-nemc.c
@@ -306,9 +306,9 @@ static int jz4780_nemc_probe(struct plat
 	}
 
 	nemc->base = devm_ioremap(dev, res->start, NEMC_REG_LEN);
-	if (IS_ERR(nemc->base)) {
+	if (!nemc->base) {
 		dev_err(dev, "failed to get I/O memory\n");
-		return PTR_ERR(nemc->base);
+		return -ENOMEM;
 	}
 
 	writel(0, nemc->base + NEMC_NFCSR);


