Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D9D3C4575
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbhGLGZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235291AbhGLGYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C077D61130;
        Mon, 12 Jul 2021 06:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070915;
        bh=VBXp8bkpQKtErkRiT4+CgRLs848UG0QGmGyzaxyX1eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyIk2N8beL2uHuIIjIuo51pZWpvcE/F+/FgxPHWcH9Zbdqznds3/nSMNj34UkklyQ
         Hzgb69WIdrrMjpE4T/Ze5pbHMOTtV7JrmmRf1aWndHoaIk+pkxELFDVPTZwaPQcICy
         UEDFqKXVrHueNhS/wRBpo6xMR/YoQ2U8uvKz+dT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 194/348] ehea: fix error return code in ehea_restart_qps()
Date:   Mon, 12 Jul 2021 08:09:38 +0200
Message-Id: <20210712060726.896919595@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 015dbf5662fd689d581c0bc980711b073ca09a1a ]

Fix to return -EFAULT from the error handling case instead of 0, as done
elsewhere in this function.

By the way, when get_zeroed_page() fails, directly return -ENOMEM to
simplify code.

Fixes: 2c69448bbced ("ehea: DLPAR memory add fix")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20210528085555.9390-1-thunder.leizhen@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 13e30eba5349..1fd2b84e2e91 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -2617,10 +2617,8 @@ static int ehea_restart_qps(struct net_device *dev)
 	u16 dummy16 = 0;
 
 	cb0 = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!cb0) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!cb0)
+		return -ENOMEM;
 
 	for (i = 0; i < (port->num_def_qps); i++) {
 		struct ehea_port_res *pr =  &port->port_res[i];
@@ -2640,6 +2638,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					    cb0);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "query_ehea_qp failed (1)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -2652,6 +2651,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					     &dummy64, &dummy16, &dummy16);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "modify_ehea_qp failed (1)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
@@ -2660,6 +2660,7 @@ static int ehea_restart_qps(struct net_device *dev)
 					    cb0);
 		if (hret != H_SUCCESS) {
 			netdev_err(dev, "query_ehea_qp failed (2)\n");
+			ret = -EFAULT;
 			goto out;
 		}
 
-- 
2.30.2



