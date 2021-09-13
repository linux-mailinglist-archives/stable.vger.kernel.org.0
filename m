Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECF1408E36
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242844AbhIMNal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241300AbhIMNXs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:23:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A05B6103B;
        Mon, 13 Sep 2021 13:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539290;
        bh=0lVwB8LeeWG1TuWOl4NbDznDnKpNRHATvtpucMkWxFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ROGNlVwgGZaLBlCMDwOytcQGdcy+3KKdp7AWXeS+/uJjqTQkuz1a/DNmkuGpAOvb
         Se4vubo5i2btJYT0m0cQv5XoyxkRBM2wK3ZBOIEgo2u99ttGSR3QK7wJzYtnM1P1yy
         8ZwisaF5kpPSLOHNvHWccmGLZ5NjT9s0272MFT7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/144] usb: bdc: Fix an error handling path in bdc_probe() when no suitable DMA config is available
Date:   Mon, 13 Sep 2021 15:14:54 +0200
Message-Id: <20210913131051.716101545@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index 3d33499db50b..845aead48d85 100644
--- a/drivers/usb/gadget/udc/bdc/bdc_core.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_core.c
@@ -565,7 +565,8 @@ static int bdc_probe(struct platform_device *pdev)
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



