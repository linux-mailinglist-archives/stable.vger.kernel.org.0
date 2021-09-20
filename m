Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3561B412569
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345798AbhITSpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382712AbhITSmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15AE61354;
        Mon, 20 Sep 2021 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159105;
        bh=4u+ZWAkctvO+7ZDjf8SrpXgAa0ebrQw8XJrUA3qCkh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSJSngMGQss2sIFk59ax0OnbQv+Fx70DMSQgdfp153PtMvE0aeReNg7ITZOPocbxD
         AvrHhKJnFHN0EEFZGVOAE1xNISBY177azlmffnijnTwlsAssxe9sPqh4GMG6EBS/hW
         b04qGG7vS29TJ5vQ/jyG7C99I03e0pIE5oEKii2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 079/168] net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP
Date:   Mon, 20 Sep 2021 18:43:37 +0200
Message-Id: <20210920163924.238014881@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

commit 2a48d96fd58a666ae231c3dd6fe4a458798ac645 upstream.

Use __maybe_unused for noirq_suspend()/noirq_resume() hooks to avoid
build warning with !CONFIG_PM_SLEEP:

>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:796:12: error: 'stmmac_pltfr_noirq_resume' defined but not used [-Werror=unused-function]
     796 | static int stmmac_pltfr_noirq_resume(struct device *dev)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:775:12: error: 'stmmac_pltfr_noirq_suspend' defined but not used [-Werror=unused-function]
     775 | static int stmmac_pltfr_noirq_suspend(struct device *dev)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: all warnings being treated as errors

Fixes: 276aae377206 ("net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -772,7 +772,7 @@ static int __maybe_unused stmmac_runtime
 	return stmmac_bus_clks_config(priv, true);
 }
 
-static int stmmac_pltfr_noirq_suspend(struct device *dev)
+static int __maybe_unused stmmac_pltfr_noirq_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -793,7 +793,7 @@ static int stmmac_pltfr_noirq_suspend(st
 	return 0;
 }
 
-static int stmmac_pltfr_noirq_resume(struct device *dev)
+static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);


