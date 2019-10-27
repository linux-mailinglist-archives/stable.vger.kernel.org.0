Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7F5E689E
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbfJ0VSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731220AbfJ0VSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:07 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D97C321783;
        Sun, 27 Oct 2019 21:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211086;
        bh=gStethqOG4n+/ABM25A8Yq5Q/DFhR8MKCsnZvf4m0hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3dJR1auGjsjRGUTebgpZj+YmsY/u7NP3c+VrasAL6ActTAi/oi0LMFkoefBARl6D
         S+KMcL1iLGWNhK+1Q4Yh4LlabDLpDYfFHv3OGSSXQh5xuHWLjaSpmAP9dcxFHCDMhQ
         Ziz1DchnvKKXP8nJ91Z0Wern7iEBqhOaJky2FyT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 027/197] ieee802154: ca8210: prevent memory leak
Date:   Sun, 27 Oct 2019 21:59:05 +0100
Message-Id: <20191027203353.194087339@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 6402939ec86eaf226c8b8ae00ed983936b164908 ]

In ca8210_probe the allocated pdata needs to be assigned to
spi_device->dev.platform_data before calling ca8210_get_platform_data.
Othrwise when ca8210_get_platform_data fails pdata cannot be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20190917224713.26371-1-navid.emamdoost@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/ca8210.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index b188fce3f6410..658b399ac9eac 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3152,12 +3152,12 @@ static int ca8210_probe(struct spi_device *spi_device)
 		goto error;
 	}
 
+	priv->spi->dev.platform_data = pdata;
 	ret = ca8210_get_platform_data(priv->spi, pdata);
 	if (ret) {
 		dev_crit(&spi_device->dev, "ca8210_get_platform_data failed\n");
 		goto error;
 	}
-	priv->spi->dev.platform_data = pdata;
 
 	ret = ca8210_dev_com_init(priv);
 	if (ret) {
-- 
2.20.1



