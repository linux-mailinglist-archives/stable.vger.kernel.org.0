Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976DC2E3982
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388637AbgL1NYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388691AbgL1NYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:24:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B3D020728;
        Mon, 28 Dec 2020 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161816;
        bh=rGuSVwxJkHRGekfGMSmdNozwvjROPbEFrEBBJoHqFqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vy/5K33Wz8gx3UlFh1uYQ7BsH/0SIiA1Wzhy1/ONZ2Il+Kl8th8ez8v4akxb3dWix
         d42fveQf4xhaoFi4pczoERWYAZComHmDZHBnQYYxxpwMnS8JCxYlCY7wfFMeIoS61g
         /mx81CJOVmaUmdf8/JfRbP92IqYVmSkgRupVBNr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 061/346] can: softing: softing_netdev_open(): fix error handling
Date:   Mon, 28 Dec 2020 13:46:20 +0100
Message-Id: <20201228124922.745733929@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index e226961905830..bed5ffa75b276 100644
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



