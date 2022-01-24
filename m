Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2791F499507
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392070AbiAXUuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357891AbiAXUmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:42:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B28C04964B;
        Mon, 24 Jan 2022 11:52:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF45A60FE3;
        Mon, 24 Jan 2022 19:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4922C340E5;
        Mon, 24 Jan 2022 19:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053948;
        bh=mcKoFe4cII9r12R2i3LDH/U9FReDIMVglxL+peuZ7gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RemwROgUeNsFt0gcdtKoc3VmiBfi9NCdq+R8GUy46DKWLmvfRvBNMb2wq+U1Jd1xf
         w2bQ21P9SzcGKvYuKGvHsvQP71S04DuyA5oFguMZXyrNVRRy7RXOgjUo4LyqGY0hVN
         aEVoq30kQxRISeRdMSJVflAfv88aZrPIpNiqbujA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/563] Bluetooth: hci_bcm: Check for error irq
Date:   Mon, 24 Jan 2022 19:39:37 +0100
Message-Id: <20220124184031.779476763@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 8ea5ca8d71d6d..259a643377c24 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1164,7 +1164,12 @@ static int bcm_probe(struct platform_device *pdev)
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



