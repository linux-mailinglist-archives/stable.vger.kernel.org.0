Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F573A61BD
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhFNKvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234151AbhFNKtI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:49:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8610D613D9;
        Mon, 14 Jun 2021 10:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667088;
        bh=s3T6XzQrXmGtouIWXobmm95hU9ShL+Xes/nlsb2ufZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IChO9wNo2/iwYhfw8EO8zv8kBbNscVemZF2bzfYOL1jkJxE/lQ6gTj+lAhCOiVJWT
         IqLGRWOCkb8cgG/felnY0dd/GVE+FM+EH9Cm7ubjrcxn4gUvwS5+Ty51xz8xwuOr7T
         MPHcR+96uyu3vngZDLa2o/7f7ccoNE/rGip6/y04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/84] usb: cdns3: Fix runtime PM imbalance on error
Date:   Mon, 14 Jun 2021 12:26:43 +0200
Message-Id: <20210614102646.519593499@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



