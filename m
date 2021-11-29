Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF00461EA5
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379282AbhK2Sis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:38:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41506 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379684AbhK2Sgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:36:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F16EBB815CC;
        Mon, 29 Nov 2021 18:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B75AC53FCD;
        Mon, 29 Nov 2021 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210798;
        bh=c3ce2bmgb9OiApJG2pe6Szm2cIfU/f+F3XVB+Qnp9Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/zjPGvPJjzHM4XHIoflAkNLK8W5c6MFzjDZ80idffOqfu1VjYeuMg9BMa7lMB//y
         AmOI4glwzYovtghMQB8TssZ012ChtW9iDXmhWjj+UfFDdHmBUpS4yEP+WHbe+PWc40
         1WXcb877rW44TjjzJn8XoyGmCJAai+Tr95wGF/IM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 120/121] net: stmmac: platform: fix build warning when with !CONFIG_PM_SLEEP
Date:   Mon, 29 Nov 2021 19:19:11 +0100
Message-Id: <20211129181715.699211611@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
@@ -779,7 +779,7 @@ static int __maybe_unused stmmac_runtime
 	return stmmac_bus_clks_config(priv, true);
 }
 
-static int stmmac_pltfr_noirq_suspend(struct device *dev)
+static int __maybe_unused stmmac_pltfr_noirq_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -800,7 +800,7 @@ static int stmmac_pltfr_noirq_suspend(st
 	return 0;
 }
 
-static int stmmac_pltfr_noirq_resume(struct device *dev)
+static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);


