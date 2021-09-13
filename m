Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6960D409261
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343771AbhIMOLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243278AbhIMOJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:09:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F393613E8;
        Mon, 13 Sep 2021 13:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540469;
        bh=jRPCEKKYWg+2r3Q55PnmcsHoHzvghlYmIOUah78fWJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMS9SvlJWh452zZ7QB27Z97oGtcHlbAUlWmDMREBABPfJK8gVpuiacRqeyBaP1Rvo
         UokRY0LQ5PUMxOsqcjHpbkcjc0bH5Jj+9m1pjBDOqjZKRWFB6sKmgwesYIGtmU/8ol
         BCO+FTbxGAIK1lkWxR2ZdORl16yQp9k3HVvkpZUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 207/300] firmware: raspberrypi: Fix a leak in rpi_firmware_get()
Date:   Mon, 13 Sep 2021 15:14:28 +0200
Message-Id: <20210913131116.361498755@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 09cbd1df7d2615c19e40facbe31fdcb5f1ebfa96 ]

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.

Add the corresponding 'put_device()' in the normal and error handling
paths.

Fixes: 4e3d60656a72 ("ARM: bcm2835: Add the Raspberry Pi firmware driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/5e17e5409b934cd08bf6f9279c73be5c1cb11cce.1628232242.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/raspberrypi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/raspberrypi.c b/drivers/firmware/raspberrypi.c
index 250e01680742..4b8978b254f9 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -329,12 +329,18 @@ struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node)
 
 	fw = platform_get_drvdata(pdev);
 	if (!fw)
-		return NULL;
+		goto err_put_device;
 
 	if (!kref_get_unless_zero(&fw->consumers))
-		return NULL;
+		goto err_put_device;
+
+	put_device(&pdev->dev);
 
 	return fw;
+
+err_put_device:
+	put_device(&pdev->dev);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(rpi_firmware_get);
 
-- 
2.30.2



