Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD225499380
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355446AbiAXUeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382612AbiAXU0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:26:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1E20B80FA1;
        Mon, 24 Jan 2022 20:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C70C340E5;
        Mon, 24 Jan 2022 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055957;
        bh=hMS3Pfo/RADStheTOI07FspzNnegx1/g9BH7Y01uFTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Og2RYtCo8K+sybJg1dJVVtXUT0lt9DJEyNCuEpNoQa3Vi9FB9rNeImVBV0x2MVG74
         Lvwd+1r2/Cg+qb7cxo2MM7HcQ94gdLW1mfxLcXDiOY4AH/p3Eb9Bd/npa8OVu/shSq
         mRdYZcx7l445YsFDFb/zjhGeh4IYueNkwykTl/B8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/846] Bluetooth: hci_bcm: Check for error irq
Date:   Mon, 24 Jan 2022 19:37:18 +0100
Message-Id: <20220124184111.973101950@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit b38cd3b42fba66cc538edb9cf77e07881f43f8e2 ]

For the possible failure of the platform_get_irq(), the returned irq
could be error number and will finally cause the failure of the
request_irq().
Consider that platform_get_irq() can now in certain cases return
-EPROBE_DEFER, and the consequences of letting request_irq() effectively
convert that into -EINVAL, even at probe time rather than later on.
So it might be better to check just now.

Fixes: 0395ffc1ee05 ("Bluetooth: hci_bcm: Add PM for BCM devices")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index ef54afa293574..7abf99f0ee399 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1188,7 +1188,12 @@ static int bcm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	dev->dev = &pdev->dev;
-	dev->irq = platform_get_irq(pdev, 0);
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
+
+	dev->irq = ret;
 
 	/* Initialize routing field to an unused value */
 	dev->pcm_int_params[0] = 0xff;
-- 
2.34.1



