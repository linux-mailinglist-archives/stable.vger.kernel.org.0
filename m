Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893DBE694A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729231AbfJ0VHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729224AbfJ0VHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:07:40 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 925E320873;
        Sun, 27 Oct 2019 21:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210460;
        bh=RsWxyvsNqS4MVQex/5Iit5lyMZbtGMxsHGAwjyXuaNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYx7fFsw3xO7w6a5EyauqsSFUfwUYz/yp7zdUTWFefq4XRvhgYTcSGM/uaiGm2Zd8
         WYnha4mf3sx/s2kLF5IwOYfV+OzO8n45pbHGrPZp/KlMI7NiGgvA8psnn3L77NJmdV
         P8SFx8b+yw7+6aYH8Sa9JF5D8IpXhYHaA1V3hldo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 005/119] ieee802154: ca8210: prevent memory leak
Date:   Sun, 27 Oct 2019 21:59:42 +0100
Message-Id: <20191027203300.947731233@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
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
index dcd10dba08c72..3a58962babd41 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -3153,12 +3153,12 @@ static int ca8210_probe(struct spi_device *spi_device)
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



