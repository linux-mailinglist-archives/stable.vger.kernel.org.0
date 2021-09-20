Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F15411D66
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344409AbhITRUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347045AbhITRRe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:17:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E9DA61A0B;
        Mon, 20 Sep 2021 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157163;
        bh=pBIjgQLHeQD6MTuP7M1n6ho9bKq42x79T3f0jQJGQOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuUsXBEe7Nhyxs8yiTImCJg5Yak92n2E06iVr+/cABzyacYoqWgcJi5neVGSqjjyk
         ZhKgNH7wNuA6TZhkYjeo87AQmdekNcMisL8LRlciJOA2l1P+rv0HCe42Keh41LlAcM
         +2oolDzTy08FDIWA8f5tL8Il1ugzSZCXrHvWXVg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 083/217] usb: bdc: Fix an error handling path in bdc_probe() when no suitable DMA config is available
Date:   Mon, 20 Sep 2021 18:41:44 +0200
Message-Id: <20210920163927.446308660@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d2f42e09393c774ab79088d8e3afcc62b3328fc9 ]

If no suitable DMA configuration is available, a previous 'bdc_phy_init()'
call must be undone by a corresponding 'bdc_phy_exit()' call.

Branch to the existing error handling path instead of returning
directly.

Fixes: cc29d4f67757 ("usb: bdc: Add support for USB phy")
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0c5910979f39225d5d8fe68c9ab1c147c68ddee1.1629314734.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bdc/bdc_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/bdc/bdc_core.c b/drivers/usb/gadget/udc/bdc/bdc_core.c
index 58ba04d858ba..23a27eb33c42 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -573,7 +573,8 @@ static int bdc_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(dev,
 				"No suitable DMA config available, abort\n");
-			return -ENOTSUPP;
+			ret = -ENOTSUPP;
+			goto phycleanup;
 		}
 		dev_dbg(dev, "Using 32-bit address\n");
 	}
-- 
2.30.2



