Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60F1CD485
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbfJFR0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:26:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:51916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbfJFR0k (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:26:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B8C2133F;
        Sun,  6 Oct 2019 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382800;
        bh=Ul1IQzv9UVldGMU3yhp2umsQMRA6lOxZbadI+W5eHfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gX4OoC8aFenJeKTeIwOJCWA/LKVAsYa9hOYm+8z9b2+7hU665UlpJ5TeAYUriapQS
         M86Xae3RlMYjePsgMtmxvNfcjCUR1JykTH97fdrM/zCH6nNgeXhXqsFzElPs3MlSXJ
         KjJQfo1/g+CpXeHnWA47xG34zLjuGkffdW8vmaa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <treding@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        linux-rockchip@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 37/68] PCI: rockchip: Propagate errors for optional regulators
Date:   Sun,  6 Oct 2019 19:21:13 +0200
Message-Id: <20191006171126.183069965@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 0e3ff0ac5f71bdb6be2a698de0ed0c7e6e738269 ]

regulator_get_optional() can fail for a number of reasons besides probe
deferral. It can for example return -ENOMEM if it runs out of memory as
it tries to allocate data structures. Propagating only -EPROBE_DEFER is
problematic because it results in these legitimately fatal errors being
treated as "regulator not specified in DT".

What we really want is to ignore the optional regulators only if they
have not been specified in DT. regulator_get_optional() returns -ENODEV
in this case, so that's the special case that we need to handle. So we
propagate all errors, except -ENODEV, so that real failures will still
cause the driver to fail probe.

Tested-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: linux-rockchip@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/host/pcie-rockchip.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/host/pcie-rockchip.c b/drivers/pci/host/pcie-rockchip.c
index 9051c6c8fea49..d3f9e7d247275 100644
--- a/drivers/pci/host/pcie-rockchip.c
+++ b/drivers/pci/host/pcie-rockchip.c
@@ -1129,29 +1129,29 @@ static int rockchip_pcie_parse_dt(struct rockchip_pcie *rockchip)
 
 	rockchip->vpcie12v = devm_regulator_get_optional(dev, "vpcie12v");
 	if (IS_ERR(rockchip->vpcie12v)) {
-		if (PTR_ERR(rockchip->vpcie12v) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
+		if (PTR_ERR(rockchip->vpcie12v) != -ENODEV)
+			return PTR_ERR(rockchip->vpcie12v);
 		dev_info(dev, "no vpcie12v regulator found\n");
 	}
 
 	rockchip->vpcie3v3 = devm_regulator_get_optional(dev, "vpcie3v3");
 	if (IS_ERR(rockchip->vpcie3v3)) {
-		if (PTR_ERR(rockchip->vpcie3v3) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
+		if (PTR_ERR(rockchip->vpcie3v3) != -ENODEV)
+			return PTR_ERR(rockchip->vpcie3v3);
 		dev_info(dev, "no vpcie3v3 regulator found\n");
 	}
 
 	rockchip->vpcie1v8 = devm_regulator_get_optional(dev, "vpcie1v8");
 	if (IS_ERR(rockchip->vpcie1v8)) {
-		if (PTR_ERR(rockchip->vpcie1v8) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
+		if (PTR_ERR(rockchip->vpcie1v8) != -ENODEV)
+			return PTR_ERR(rockchip->vpcie1v8);
 		dev_info(dev, "no vpcie1v8 regulator found\n");
 	}
 
 	rockchip->vpcie0v9 = devm_regulator_get_optional(dev, "vpcie0v9");
 	if (IS_ERR(rockchip->vpcie0v9)) {
-		if (PTR_ERR(rockchip->vpcie0v9) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
+		if (PTR_ERR(rockchip->vpcie0v9) != -ENODEV)
+			return PTR_ERR(rockchip->vpcie0v9);
 		dev_info(dev, "no vpcie0v9 regulator found\n");
 	}
 
-- 
2.20.1



