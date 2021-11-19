Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA654575B7
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbhKSRlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:41:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236902AbhKSRls (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:41:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4115A60D42;
        Fri, 19 Nov 2021 17:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343526;
        bh=bY7dYMjiGheoTzxgKjJV3bVzFnh0kfWd1j/nmzobosI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/arK7cmIhOUS23wEZgfi6j1SxG+zqvu3CjKZehSWMxiPst1HcZ2MWsQWRn10io/0
         yONjyq5tMe3SEFPOQq8RIkZVFLNob4J2L47Ntk/C8AYXfCtxLj03iPKkzJuINC5rQ3
         oGdXbvdZ1Wx/33/bcd4JpKGMKDJ/JeRaCBMMo+Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Meng Li <Meng.Li@windriver.com>
Subject: [PATCH 5.10 07/21] net: stmmac: fix missing unlock on error in stmmac_suspend()
Date:   Fri, 19 Nov 2021 18:37:42 +0100
Message-Id: <20211119171444.125083013@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 30f347ae7cc1178c431f968a89d4b4a375bc0d39 upstream

Add the missing unlock before return from stmmac_suspend()
in the error handling case.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5275,8 +5275,10 @@ int stmmac_suspend(struct device *dev)
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->plat->clk_ptp_ref);
 		ret = pm_runtime_force_suspend(dev);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&priv->lock);
 			return ret;
+		}
 	}
 	mutex_unlock(&priv->lock);
 


