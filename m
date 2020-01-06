Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DD3130E2A
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 08:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgAFHrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 02:47:10 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41341 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgAFHrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 02:47:10 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so35753388lfp.8
        for <stable@vger.kernel.org>; Sun, 05 Jan 2020 23:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pZkSelzc0Z6TX6CKXvWhPXekmLTBpqguNoU57F7A+GA=;
        b=D2P9z/BPXZn6KyiOHzxczxi4DTI9BTRxdmjjtw7LOWGC6t2Kq+HTPP7zeAh8ILC0nV
         T2oUVBmE8BDd/GXNmjV8oyYS7N2m42GldSEoe7xYuFzCMISKU3SxgVrPvXBSFtMhI49c
         eEm6Jr9hXst6cjRpyO59ooBITwmy5JEyFURiSSedhxBWXEtAYzrM19tkGp3Qd8pm28y+
         JX7DhPzGqBcCkisb3OdpXcyNYt1f09wVjHQn9Wm+eGgy/iYfVK46laSgUCUwCmfQfqb7
         kmn0bi6EIINPvu4+g18TYrDrdLMiQ82CUJ/MqG/yMv7AWe+Hp5iXoQ1kQLZSZ8wYHAuA
         JXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pZkSelzc0Z6TX6CKXvWhPXekmLTBpqguNoU57F7A+GA=;
        b=corKRdkBvgA4v4RORutlIfop3hzD3t1um0VIxb3qYUdgXPO4d37zLDunC9zGB/zN6r
         JMG881mj3vWSfDeOi4C4kTqdYjn7JxHtxbagtOYm5YZ/tdRBazYf3BI4ak9jVONdLMoS
         xypmQp9olu8cA4RuPOIMG4s5zAfj7Wdo1WBsj/wc2xnMAoDoKF1cgdpIwCYv7TdM2/NS
         C3pdUAEE8L+SK3Ai60yksaaT9WtOzm3PkBYkvVoKW16swpA/VjLHjocqg6FyCIHp2rIA
         zBANhB94T++vdV3XkWNAa+z7l244iTniPuWTK+cOKWkASZ1bW3D0gOZfKf9IDV7+WDmi
         rXJA==
X-Gm-Message-State: APjAAAVQ2ZRjD//zHkFhg+nNhuZvmbka5zBUVhHnA3PLTMilC+T95sBV
        oq/jzBvIkseNDvjlyYx8vrwA0Q==
X-Google-Smtp-Source: APXvYqyBkg7TtyongEWfBKu8wyxi6vPPGGP16wEhTzhU6emQm/Qe7a/fk4pDswtAStV7UuIyfZKfGA==
X-Received: by 2002:ac2:489b:: with SMTP id x27mr57009748lfc.130.1578296827684;
        Sun, 05 Jan 2020 23:47:07 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id n14sm28625551lfe.5.2020.01.05.23.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 23:47:07 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH net-next 9/9 v3] net: ethernet: ixp4xx: Use parent dev for DMA pool
Date:   Mon,  6 Jan 2020 08:46:47 +0100
Message-Id: <20200106074647.23771-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200106074647.23771-1-linus.walleij@linaro.org>
References: <20200106074647.23771-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the netdevice struct device .parent field when calling
dma_pool_create(): the .dma_coherent_mask and .dma_mask
pertains to the bus device on the hardware (platform)
bus in this case, not the struct device inside the network
device. This makes the pool allocation work.

Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChanegLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Rebase with the rest of the series.
- Tag for stable, this is pretty serious.
- I have no real idea when this stopped working.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index ee45215c4ba4..269596c15133 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1086,7 +1086,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
+		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
-- 
2.21.0

