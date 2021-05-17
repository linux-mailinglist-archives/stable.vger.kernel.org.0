Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20639383845
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244703AbhEQPvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238526AbhEQPsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:48:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0B6461437;
        Mon, 17 May 2021 14:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262688;
        bh=Vg1h4/8J8wvPIdZl8ejo0BKFj8ednOpcj2Dpo2elCtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rxeOy7MGiH8Bvc11Lp3BqMBTIKBnQ7340kFwIvgoCwnH1zXXpZYUYTbBFcr5iZTqU
         L4vaG+SvlBpe0N9YF7ma3MD/56MheoHFChFDtOWJFxXA1dyc9W57zC3lxUb2gGnRMb
         5EYi2KNIZrF96qCwE6d+ZaOX8mPqNq3iacS07rNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/289] usb: musb: Fix an error message
Date:   Mon, 17 May 2021 16:02:33 +0200
Message-Id: <20210517140312.838938208@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d9ff1096a840dddea3d5cfa2149ff7da9f499fb2 ]

'ret' is known to be 0 here.
Initialize 'ret' with the expected error code before using it.

Fixes: 0990366bab3c ("usb: musb: Add support for MediaTek musb controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/69f514dc7134e3c917cad208e73cc650cb9e2bd6.1620159879.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/mediatek.c b/drivers/usb/musb/mediatek.c
index eebeadd26946..6b92d037d8fc 100644
--- a/drivers/usb/musb/mediatek.c
+++ b/drivers/usb/musb/mediatek.c
@@ -518,8 +518,8 @@ static int mtk_musb_probe(struct platform_device *pdev)
 
 	glue->xceiv = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
 	if (IS_ERR(glue->xceiv)) {
-		dev_err(dev, "fail to getting usb-phy %d\n", ret);
 		ret = PTR_ERR(glue->xceiv);
+		dev_err(dev, "fail to getting usb-phy %d\n", ret);
 		goto err_unregister_usb_phy;
 	}
 
-- 
2.30.2



