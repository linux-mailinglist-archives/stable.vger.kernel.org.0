Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FFA274189
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 13:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgIVLt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 07:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgIVLtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 07:49:45 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D67C061755;
        Tue, 22 Sep 2020 04:49:45 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k14so11730213pgi.9;
        Tue, 22 Sep 2020 04:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJwpKrbgqo/Jc/SWHvyAGB9CrpkZ5L1Hzq9tInFHTYk=;
        b=Gtqp4rrTgM1+bYxfUQXe+lfPcgHRW6GccdN42Iszl6ozMbezvftl1BUcKE22S6eFW3
         Vs+lcKZN9Eh9C53YAAd0cuZYhJ2GqlfGNLA/9SyB7s/gIwHqO9Cuu17YpB9dAFfEUxoS
         825uUcTeRe6BTagZAh2/MBluiMY3TszRi94MbOftxUg+wSqp0wMAPe9RN0gAEc/l2xgK
         8PhXbZv3uItI4QqoKYiz93vrF/zYhj+oGTI44g2li2fpAgCNL7lXCpSE2C9NsEe+YqTw
         aO5A3W8t4jvp8oCJEvr/MWY1ZZLd1fVJ17W3aGXoDi/7EUcAvX9G5Ee7U68UXGMtty/d
         z5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EJwpKrbgqo/Jc/SWHvyAGB9CrpkZ5L1Hzq9tInFHTYk=;
        b=CirDpApw6V0KgdZwYCAq+JCz7W1Htd1skOBUBXMH/Wr4Sq/FgOmuclnfJYgZib8wdV
         Jso2NcecUFfGtVsjv1iwBrY6XzBHYRpx35EoI+T/kr7dDk6Wgid50/NAQX6XDnB+ykoW
         /qQRRU8UmFpxzT5T3U26E69cloymc2w5JI2zS5/q7RdyOzyNLM+8UFYLOUUzC3r3TweH
         YzF0b5ezfDUHTXqoDt0a1kQP50FH/TpRfCOfYxMXR5RzOsFunRO7p5i6wtm03rgWyiWs
         1XdAEwpbcqtscU4hF3n6AZQ+TBjvk52S9MAPYMZKeexoTG562mZfqBPjLaA4d0G32Jos
         vq+A==
X-Gm-Message-State: AOAM532zZPkjUWHXbNLS55XKfaON8sTIZf0EcfEPxXLxfmBiALCdiepu
        Ezg8f5eHEX0fGxK9RmW0BwCt4/ZN6q8OfA==
X-Google-Smtp-Source: ABdhPJx36OliaaLkiX3ZeZNNWgd/qSKiRor2X0eeHScDrjMSi5bTiEzAfX5j7hkQgqz8ZUT0qqLRNA==
X-Received: by 2002:a63:1863:: with SMTP id 35mr3131307pgy.413.1600775385014;
        Tue, 22 Sep 2020 04:49:45 -0700 (PDT)
Received: from guoguo-omen.lan ([156.96.148.94])
        by smtp.gmail.com with ESMTPSA id r4sm2223750pjf.4.2020.09.22.04.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 04:49:44 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     linux-spi@vger.kernel.org
Cc:     bayi.cheng@mediatek.com, Chuanhong Guo <gch981213@gmail.com>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] spi: spi-mtk-nor: fix timeout calculation overflow
Date:   Tue, 22 Sep 2020 19:49:02 +0800
Message-Id: <20200922114905.2942859-1-gch981213@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CLK_TO_US macro is used to calculate potential transfer time for various
timeout handling. However it overflows on transfer bigger than 512 bytes
because it first did (len * 8 * 1000000).
This controller typically operates at 45MHz. This patch did 2 things:
1. calculate clock / 1000000 first
2. add a 4M transfer size cap so that the final timeout in DMA reading
   doesn't overflow

Fixes: 881d1ee9fe81f ("spi: add support for mediatek spi-nor controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
---

Change since v1: fix transfer size cap to 4M

 drivers/spi/spi-mtk-nor.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mtk-nor.c b/drivers/spi/spi-mtk-nor.c
index 6e6ca2b8e6c82..62f5ff2779884 100644
--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -89,7 +89,7 @@
 // Buffered page program can do one 128-byte transfer
 #define MTK_NOR_PP_SIZE			128
 
-#define CLK_TO_US(sp, clkcnt)		((clkcnt) * 1000000 / sp->spi_freq)
+#define CLK_TO_US(sp, clkcnt)		DIV_ROUND_UP(clkcnt, sp->spi_freq / 1000000)
 
 struct mtk_nor {
 	struct spi_controller *ctlr;
@@ -177,6 +177,10 @@ static int mtk_nor_adjust_op_size(struct spi_mem *mem, struct spi_mem_op *op)
 	if ((op->addr.nbytes == 3) || (op->addr.nbytes == 4)) {
 		if ((op->data.dir == SPI_MEM_DATA_IN) &&
 		    mtk_nor_match_read(op)) {
+			// limit size to prevent timeout calculation overflow
+			if (op->data.nbytes > 0x400000)
+				op->data.nbytes = 0x400000;
+
 			if ((op->addr.val & MTK_NOR_DMA_ALIGN_MASK) ||
 			    (op->data.nbytes < MTK_NOR_DMA_ALIGN))
 				op->data.nbytes = 1;
-- 
2.26.2

