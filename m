Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E565C44348B
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 18:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhKBR3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 13:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhKBR3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 13:29:51 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E483C061714;
        Tue,  2 Nov 2021 10:27:16 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w1so134259edd.10;
        Tue, 02 Nov 2021 10:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OdaxtB4LssE4g+n1VNEzexPIrO9OAMoPZzNOdCXvKY=;
        b=mdU0U8go0ySDUlWCxLU1AzstBNRGwhKDX900iZOIN6UnsNA0AA/oAbCX71K7X0NfuM
         oPPhYZwjM+8WzEqudWqL6w/uibOHtKJKzGOdod/KLm6/RajNfrxw+arQVDguduOGFIHH
         kxYLILQOrQcCimkzUiBUlv7pYINRGLtyc4vzp+rHohqW0R6styn1Mr3uTfQjRYX1TeH7
         XgTi5fKJCjxHhETF4DF09C8CeW3GEGaRNmF2j6LxPHr44ioS7C9STeDPKJcmvNRBsp5o
         NbUHHTU6hxAxJqk4DC7Vkxg/JcUxxHEurtWThcNXd2J1PQvo+GzkjtteiYqZsB9NW/mc
         xXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OdaxtB4LssE4g+n1VNEzexPIrO9OAMoPZzNOdCXvKY=;
        b=FxzzwmrQ7XV4Yl7QL+8Cp5Mqi0r2BVDBtjXVR5Ey656R4Yu+uY4YZxxHZ6nNwnd+rM
         hFrO9RewazEjJA+CJtgTYNoBuxeFQzccFBwTnB3SUcDoTyxEi5izkZok4uCpyeTbAMdZ
         ZPFi3V7EKB0N/NreVDvgmsyvvrRHYfjARD4oy316dkk8U74WbafZ6hXQ41x6i6QcwPSt
         V9bVmTeYatSk2wGqk2tIfsJnSmYHDWwpqhz2gSdGkaw4nY+KABJL5eCY+7k5eQp9nvhc
         a0Es0vEFa+Db4sopQgKLrf4HmbBw3eQ0erL6kb5OS++dPNlzfgXtwpVnmKjJf9dRsPhG
         WgKg==
X-Gm-Message-State: AOAM532a6Bl5y5Eq9Q5JZCW7NcpJ71X9WSm70pQ3e/WWhjdjE9D6Cxwf
        rz26n1zuQeEWasmvpOGASk2+1a4reCo=
X-Google-Smtp-Source: ABdhPJwAVmlP9bDQGX4Sjh/CtxgelisUtOodlrNzHt6mtFxJZuuUYoIBjfqq982xFydqLrvjAXTAYA==
X-Received: by 2002:a50:cbc2:: with SMTP id l2mr24754089edi.89.1635874034854;
        Tue, 02 Nov 2021 10:27:14 -0700 (PDT)
Received: from md2k7s8c.fritz.box ([2a02:810d:9040:4c1f:e0b6:d0e7:64d2:f3a0])
        by smtp.gmail.com with ESMTPSA id nd36sm8580753ejc.17.2021.11.02.10.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 10:27:14 -0700 (PDT)
From:   Andreas Oetken <ennoerlangen@gmail.com>
X-Google-Original-From: Andreas Oetken <andreas.oetken@siemens-energy.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Andreas Oetken <ennoerlangen@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andreas Oetken <andreas.oetken@siemens-energy.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] drivers: mtd: Fixed breaking list in __mtd_del_partition.
Date:   Tue,  2 Nov 2021 18:27:10 +0100
Message-Id: <20211102172710.2933885-1-andreas.oetken@siemens-energy.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Not the child partition should be removed from the partition list
but the partition itself. Otherwise the partition list gets broken
and any subsequent remove operations leads to a kernel panic.

Fixes: 46b5889cc2c5 ("mtd: implement proper partition handling")
Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/mtdpart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 95d47422bbf20..5725818fa199f 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -313,7 +313,7 @@ static int __mtd_del_partition(struct mtd_info *mtd)
 	if (err)
 		return err;
 
-	list_del(&child->part.node);
+	list_del(&mtd->part.node);
 	free_partition(mtd);
 
 	return 0;
-- 
2.30.2

