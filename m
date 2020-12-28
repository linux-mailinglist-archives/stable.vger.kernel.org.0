Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA652E3D7D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391714AbgL1OQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440832AbgL1OQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B70229C5;
        Mon, 28 Dec 2020 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164924;
        bh=ihsXcEa9n5M2aHrh3MXbtTM9E6I+p8DzGiQOyupVSI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxGRdp58GSBMbNU2w26zABmbqgjhNtRhowR6hmFfp5OOfFjS9HduVZNflzDRLW+VD
         o34M2QXkSSMlz0sqI3wwWy2QpvhL6OJb9/8ldnJ3xsYpAmmhUC5K909CGA5uPhtYiA
         8KCplnpEkgr7fdPyYSX8s+sKfoxsXehHpbm1/qQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Li <wangli74@huawei.com>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 316/717] phy: renesas: rcar-gen3-usb2: disable runtime pm in case of failure
Date:   Mon, 28 Dec 2020 13:45:14 +0100
Message-Id: <20201228125036.172285784@linuxfoundation.org>
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

From: Wang Li <wangli74@huawei.com>

[ Upstream commit 51e339deab1e51443f6ac3b1bd5cd6cc8e8fe1d9 ]

pm_runtime_enable() will decrease power disable depth. Thus a pairing
increment is needed on the error handling path to keep it balanced.

Fixes: 5d8042e95fd4 ("phy: rcar-gen3-usb2: Add support for r8a77470")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Li <wangli74@huawei.com>
Link: https://lore.kernel.org/r/20201126024412.4046845-1-wangli74@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/renesas/phy-rcar-gen3-usb2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index e34e4475027ca..2cb949f931b69 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -656,8 +656,10 @@ static int rcar_gen3_phy_usb2_probe(struct platform_device *pdev)
 	 */
 	pm_runtime_enable(dev);
 	phy_usb2_ops = of_device_get_match_data(dev);
-	if (!phy_usb2_ops)
-		return -EINVAL;
+	if (!phy_usb2_ops) {
+		ret = -EINVAL;
+		goto error;
+	}
 
 	mutex_init(&channel->lock);
 	for (i = 0; i < NUM_OF_PHYS; i++) {
-- 
2.27.0



