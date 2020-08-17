Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17168246B51
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387875AbgHQPws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:52:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387863AbgHQPwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:52:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8867E2063A;
        Mon, 17 Aug 2020 15:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679565;
        bh=gHmsU+XG61m0rQS0oJmH2tnjbgwl5bnj4xGsCcFs6/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kblmOYq/O30Riv8Q9QBUl8wtnCB2c9WWZ4dCw8CEuBb67Is37bEEZlPhZb4Hx9ZRW
         P4A2ga9FeBLvsmth+CZgjhhweoPRSPIOitwOqqE2VL5qeV8E43jtmKzexajnA7Z9NO
         ck2PFc4sXGJvJVm/Z3RYnEhqvfvBtX1NEfxdqIyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 227/393] thermal: ti-soc-thermal: Fix reversed condition in ti_thermal_expose_sensor()
Date:   Mon, 17 Aug 2020 17:14:37 +0200
Message-Id: <20200817143830.634521543@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 0f348db01fdf128813fdd659fcc339038fb421a4 ]

This condition is reversed and will cause breakage.

Fixes: 7440f518dad9 ("thermal/drivers/ti-soc-thermal: Avoid dereferencing ERR_PTR")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200616091949.GA11940@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 85776db4bf346..2ce4b19f312ac 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -169,7 +169,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
 
-	if (!IS_ERR_OR_NULL(data))
+	if (IS_ERR_OR_NULL(data))
 		data = ti_thermal_build_data(bgp, id);
 
 	if (!data)
-- 
2.25.1



