Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF393B602B
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhF1OWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhF1OV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 654C161C93;
        Mon, 28 Jun 2021 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889962;
        bh=46qakYsBuV8NRmvos3gw/mKbjcS14jl4gU6VCHt36Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3xwgHA0t3ybyCKcTmbVneZHkOJ2QPEmavbQnlfbPkCZ3N5J/SMwSwX+OkRjScD3g
         7zrib4TYpiG96T2bKbxVmP5Q1Irq5eVCE8YnYaWaeC1eIFhBjFCUjut/4dlwF7whrl
         43IjSqsPRlCp18YR8cCmXpdlv/PNdw2aT9wURs/aZVTAJ6UFg92+egzzWGDIVFLHwF
         epUu/YAnUi1so28hy6Cpw2fwn1WHoWgqNJm96oqY8mEE3zQd6KFVIkG7m4s+L5KLUW
         GBUN16ayWTZvPxbBipNIstVZPALD9OLRCvMYIgdT6uIvzR3/gyZJJ3qg7FB7kTjNu4
         bncGGcCn/KwpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 062/110] pinctrl: microchip-sgpio: Put fwnode in error case during ->probe()
Date:   Mon, 28 Jun 2021 10:17:40 -0400
Message-Id: <20210628141828.31757-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 76b7f8fae30a9249f820e019f1e62eca992751a2 ]

device_for_each_child_node() bumps a reference counting of a returned variable.
We have to balance it whenever we return to the caller.

Fixes: 7e5ea974e61c ("pinctrl: pinctrl-microchip-sgpio: Add pinctrl driver for Microsemi Serial GPIO")
Cc: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210606191940.29312-1-andy.shevchenko@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-microchip-sgpio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-microchip-sgpio.c b/drivers/pinctrl/pinctrl-microchip-sgpio.c
index c12fa57ebd12..165cb7a59715 100644
--- a/drivers/pinctrl/pinctrl-microchip-sgpio.c
+++ b/drivers/pinctrl/pinctrl-microchip-sgpio.c
@@ -845,8 +845,10 @@ static int microchip_sgpio_probe(struct platform_device *pdev)
 	i = 0;
 	device_for_each_child_node(dev, fwnode) {
 		ret = microchip_sgpio_register_bank(dev, priv, fwnode, i++);
-		if (ret)
+		if (ret) {
+			fwnode_handle_put(fwnode);
 			return ret;
+		}
 	}
 
 	if (priv->in.gpio.ngpio != priv->out.gpio.ngpio) {
-- 
2.30.2

