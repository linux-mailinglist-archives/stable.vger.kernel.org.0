Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860CF4575B8
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbhKSRlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236892AbhKSRlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA922611CC;
        Fri, 19 Nov 2021 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343524;
        bh=RHa+EJECPVD+w1NBVcyCxZvhpZKT73J2kZmeZBGAOB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Czu9W86cqgZk36O+DIkBJBMHaF0c1r29Qs1pxBWTmXBG60mfyg2L/ReRPRwWCYwmJ
         s8No0WQh+JK/o0f1VrbR1AQvcTKPlJ22MfbAS1f/3l3TNz2nG3ecEFclOMcZcJi1hd
         3NLF3aGqWlTmuxPIVXjx63LgYhA3z+XhpsnaGq4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Meng Li <Meng.Li@windriver.com>
Subject: [PATCH 5.10 06/21] net: stmmac: platform: fix build error with !CONFIG_PM_SLEEP
Date:   Fri, 19 Nov 2021 18:37:41 +0100
Message-Id: <20211119171444.094948631@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
References: <20211119171443.892729043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

commit 7ec05a6035480f3a5934b2b31222620b2e906163 upstream

Get rid of the CONFIG_PM_SLEEP ifdefery to fix the build error
and use __maybe_unused for the suspend()/resume() hooks to avoid
build warning:

drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:769:21:
 error: 'stmmac_runtime_suspend' undeclared here (not in a function); did you mean 'stmmac_suspend'?
  769 |  SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
      |                     ^~~~~~~~~~~~~~~~~~~~~~
./include/linux/pm.h:342:21: note: in definition of macro 'SET_RUNTIME_PM_OPS'
  342 |  .runtime_suspend = suspend_fn, \
      |                     ^~~~~~~~~~
drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:769:45:
 error: 'stmmac_runtime_resume' undeclared here (not in a function)
  769 |  SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
      |                                             ^~~~~~~~~~~~~~~~~~~~~
./include/linux/pm.h:343:20: note: in definition of macro 'SET_RUNTIME_PM_OPS'
  343 |  .runtime_resume = resume_fn, \
      |                    ^~~~~~~~~

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -720,7 +720,6 @@ int stmmac_pltfr_remove(struct platform_
 }
 EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
 
-#ifdef CONFIG_PM_SLEEP
 /**
  * stmmac_pltfr_suspend
  * @dev: device pointer
@@ -728,7 +727,7 @@ EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
  * call the main suspend function and then, if required, on some platform, it
  * can call an exit helper.
  */
-static int stmmac_pltfr_suspend(struct device *dev)
+static int __maybe_unused stmmac_pltfr_suspend(struct device *dev)
 {
 	int ret;
 	struct net_device *ndev = dev_get_drvdata(dev);
@@ -749,7 +748,7 @@ static int stmmac_pltfr_suspend(struct d
  * the main resume function, on some platforms, it can call own init helper
  * if required.
  */
-static int stmmac_pltfr_resume(struct device *dev)
+static int __maybe_unused stmmac_pltfr_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -761,7 +760,7 @@ static int stmmac_pltfr_resume(struct de
 	return stmmac_resume(dev);
 }
 
-static int stmmac_runtime_suspend(struct device *dev)
+static int __maybe_unused stmmac_runtime_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -771,14 +770,13 @@ static int stmmac_runtime_suspend(struct
 	return 0;
 }
 
-static int stmmac_runtime_resume(struct device *dev)
+static int __maybe_unused stmmac_runtime_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 
 	return stmmac_bus_clks_config(priv, true);
 }
-#endif /* CONFIG_PM_SLEEP */
 
 const struct dev_pm_ops stmmac_pltfr_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)


