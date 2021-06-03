Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EEA39A790
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhFCRLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232377AbhFCRLJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1934D613F5;
        Thu,  3 Jun 2021 17:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740164;
        bh=s3T6XzQrXmGtouIWXobmm95hU9ShL+Xes/nlsb2ufZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhkYCe3w6E2P2SqTWgGVs3UHT168SlqKuwgPmb0cuv4/gRqnRJAlJ+pisFpVmpMMp
         TNLmVynorZ0oH269KlULl41l/YhtlNJyzKBhXxQ+ohS7bsVUKWHYysYcDzJOfJ7ici
         H/T0zTqyqu8FCmzbvxHMHfTrAdZb7Qf8IX8hiIG0GxxanflAniDwgf83K1e5iXZwH4
         aBgpOVcjWkUXsV/i6sevgWjOhb6jqF4fGE2n+N3R8oIwajlrQVQJ+UmBAIhVFgi+q7
         3zd9v+l0YjnCqNn5tCZ+7sr+4NnxRq3fL22rE5ghBGA7xTf9khuzHzhUdKxlTQcWt0
         EAXe5oKBPzmaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Peter Chen <peter.chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 04/31] usb: cdns3: Fix runtime PM imbalance on error
Date:   Thu,  3 Jun 2021 13:08:52 -0400
Message-Id: <20210603170919.3169112-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit e5b913496099527abe46e175e5e2c844367bded0 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced.

Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index c0c39cf30387..f32f00c49571 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2706,8 +2706,10 @@ static int __cdns3_gadget_init(struct cdns3 *cdns)
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

