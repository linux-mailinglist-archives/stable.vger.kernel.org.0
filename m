Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A742E695C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgL1Mxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgL1Mxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:53:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 653F72245C;
        Mon, 28 Dec 2020 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609159947;
        bh=pgLXocH2vJ9te5HZy5zwbwL6P1bRMwPOKZSh4VVgUUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVShaxSCn1yw36t3USQNoqSl2GpIqmeWS2LgO+CsJut2EDL6P+/3XiS1MTeujU29m
         fv4pFmzb1nimyLp5ifEFqV38afr3FbG1ILTURa6AKETk2aBreGFnLWiWQyJdYkvJ4Q
         mZ4f43IYDVv2sH/eUPV/ocWMaX7vzswsLREDhih8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 023/132] can: softing: softing_netdev_open(): fix error handling
Date:   Mon, 28 Dec 2020 13:48:27 +0100
Message-Id: <20201228124847.531480524@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 4d1be581ec6b92a338bb7ed23e1381f45ddf336f ]

If softing_netdev_open() fails, we should call close_candev() to avoid
reference leak.

Fixes: 03fd3cf5a179d ("can: add driver for Softing card")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Link: https://lore.kernel.org/r/20201202151632.1343786-1-zhangqilong3@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20201204133508.742120-2-mkl@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/softing/softing_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index 7621f91a8a209..fd48770ba7920 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -393,8 +393,13 @@ static int softing_netdev_open(struct net_device *ndev)
 
 	/* check or determine and set bittime */
 	ret = open_candev(ndev);
-	if (!ret)
-		ret = softing_startstop(ndev, 1);
+	if (ret)
+		return ret;
+
+	ret = softing_startstop(ndev, 1);
+	if (ret < 0)
+		close_candev(ndev);
+
 	return ret;
 }
 
-- 
2.27.0



