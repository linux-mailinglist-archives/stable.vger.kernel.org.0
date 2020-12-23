Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9ED2E16C8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgLWDCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728718AbgLWCTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B922A2335A;
        Wed, 23 Dec 2020 02:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689949;
        bh=vV9MMIYH+ELfgDnsBD8akCClNheICoQv5tZB0uZtvNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7tRQD3a8HUX5O2/lkFAEO8u6AxvAXxH5Ktgqqj99ZpRIVYrozCGikWgi5TZk65aI
         KRnCTBc25XoLWIdPL5z34Kl2XfaljBlU2hOhIzANbvWe/ekmXS0VkTZTDNZ8tjm4Vd
         sZgtTGsDLJweFGw+3mFDjcyTLa2OWHtkJOaMZFw7hISJYWhi8CJT/5787lMvU1lHuy
         7409arn4FTuQ6dHUyjiy+6CkqMi0P/Ph2g1YOJSi0Vj4jygIW5Fmf23f3MfodLmRbR
         mjmtw2HbqqsFeNWjA5jj47Vznn3C/olXAkG2VH/HG/DM8E0S6IwWwKk6ou9qwLAqC2
         jxdxOU0SJrxCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 043/130] media: usb: dvb-usb-v2: zd1301: fix missing platform_device_unregister()
Date:   Tue, 22 Dec 2020 21:16:46 -0500
Message-Id: <20201223021813.2791612-43-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit ee50d6e60d9a8e110e984cdd9e788d93eff540ba ]

Add the missing platform_device_unregister() before return
from zd1301_frontend_attach in the error handling case when
pdev->dev.driver is empty.

There's an error handling route named err_platform_device_unregister,
so just reuse it.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/zd1301.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/zd1301.c b/drivers/media/usb/dvb-usb-v2/zd1301.c
index 63b66b207b64d..815ae1e8dc03e 100644
--- a/drivers/media/usb/dvb-usb-v2/zd1301.c
+++ b/drivers/media/usb/dvb-usb-v2/zd1301.c
@@ -150,7 +150,7 @@ static int zd1301_frontend_attach(struct dvb_usb_adapter *adap)
 	}
 	if (!pdev->dev.driver) {
 		ret = -ENODEV;
-		goto err;
+		goto err_platform_device_unregister;
 	}
 	if (!try_module_get(pdev->dev.driver->owner)) {
 		ret = -ENODEV;
-- 
2.27.0

