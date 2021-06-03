Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2A639A6CB
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhFCRJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhFCRJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 641C9613F5;
        Thu,  3 Jun 2021 17:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740066;
        bh=NL94Eda93FKiReCtOh3P43zPsSlxx4Dey/R3uiRG24s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUxMOsiTqdR1+BbvukwIfE5Q/qQeJCox0lxsNVjGQoxUOMIYidCkJJ7F+WSZ1cbq9
         7TzP/3UCfQ+X6BmAxwZmyG5+TJ/0/1JCWKquyZQ2DXUTU990ZT48AICsNm/Dcs5mZm
         mUN1YjBi96nLWJoWhwWDDw6j+5h4IZIKTom8bQohAkE5rwBK+CyuaIMgQm8zt1MGa5
         tAhHGCMiHD28Tb/bHxiTjGLwb7FlbdAdTZO8HDrv+aOfVoUbe6n8JU1iTvlEvGwyOA
         19T9Ve288xpVe7mmBEylmt6TgSr0FF1FSMwN0dhOuieYP4NjV/FdJRL/IeoeLZBsxg
         2C/Ka8723jwWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 09/43] usb: cdns3: Fix runtime PM imbalance on error
Date:   Thu,  3 Jun 2021 13:06:59 -0400
Message-Id: <20210603170734.3168284-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 07adc0225484fc199e3dc15ec889f75f498c4fca ]

When cdns3_gadget_start() fails, a pairing PM usage counter
decrement is needed to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20210412054908.7975-1-dinghao.liu@zju.edu.cn
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdns3-gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 582bfeceedb4..a49fc68ec2ef 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -3255,8 +3255,10 @@ static int __cdns3_gadget_init(struct cdns *cdns)
 	pm_runtime_get_sync(cdns->dev);
 
 	ret = cdns3_gadget_start(cdns);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_sync(cdns->dev);
 		return ret;
+	}
 
 	/*
 	 * Because interrupt line can be shared with other components in
-- 
2.30.2

