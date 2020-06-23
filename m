Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9D1206397
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390897AbgFWU2m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:28:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390879AbgFWU2l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:28:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 261AF2064B;
        Tue, 23 Jun 2020 20:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944120;
        bh=+73I7vWXVrTetzQ0y7R5LJJ6FtiHa/xYfWMACVzJKdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNu5F2LunOUwTevaij/qdEAz+Y54M49GlivB9yBb5LJmrCAB6+6LpqtZCFKa8n/uD
         FMl7tU6AnyA2lV7ZUNSBxVl2zOjyORVoFuxkUiZ3pY2ZevCRAj7LUOOGcuRgi4o2lZ
         cjOuag0HGkZNCyKBUs97jZ6Km6ekNxG99IRAIwMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 163/314] firmware: imx: scu: Fix possible memory leak in imx_scu_probe()
Date:   Tue, 23 Jun 2020 21:55:58 +0200
Message-Id: <20200623195346.645463110@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 89f12d6509bff004852c51cb713a439a86816b24 ]

'chan_name' is malloced in imx_scu_probe() and should be freed
before leaving from the error handling cases, otherwise it will
cause memory leak.

Fixes: edbee095fafb ("firmware: imx: add SCU firmware driver support")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index e48d971ffb617..a3b11bc71dcb8 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -300,6 +300,7 @@ static int imx_scu_probe(struct platform_device *pdev)
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "Failed to request mbox chan %s ret %d\n",
 					chan_name, ret);
+			kfree(chan_name);
 			return ret;
 		}
 
-- 
2.25.1



