Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EE03A6352
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhFNLL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235380AbhFNLJy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:09:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F0046193B;
        Mon, 14 Jun 2021 10:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667622;
        bh=NL94Eda93FKiReCtOh3P43zPsSlxx4Dey/R3uiRG24s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDsnGZ0w9HriUj4SyJc3Qc/iy1e56lekf7T4h2fLnkVfJvk0ZbtEEik/j1gEE0pxB
         0PqZWpxikHNVK2PxnG/j34dUQ7ygUXGzCLlps8hGSYs5wxJwoL2LpRpiDkpIckRF9n
         usI8m4p8bJs+21WgwGyafIWM+hQrW5PQPTHrHfBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 010/173] usb: cdns3: Fix runtime PM imbalance on error
Date:   Mon, 14 Jun 2021 12:25:42 +0200
Message-Id: <20210614102658.499139165@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



