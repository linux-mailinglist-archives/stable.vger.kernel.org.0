Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EEB443487
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 18:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbhKBR2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 13:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhKBR2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Nov 2021 13:28:45 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E94FC061714;
        Tue,  2 Nov 2021 10:26:09 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id j21so107405edt.11;
        Tue, 02 Nov 2021 10:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OdaxtB4LssE4g+n1VNEzexPIrO9OAMoPZzNOdCXvKY=;
        b=D1hjG4k2rBHwrOqHw0wA0eXdXQDI2BQN6griH4YjxUHpAPZa4lOBz1Z8h8MV6iAF91
         QIt0/fjNJVY4YJs/xgIzw9Ra/yCn9aB9fkEaDmTeR73Xs7YGi7v5KF0veLVLoIva203S
         EYxZ+/yQXnrko3WCHSbQodZaLqvn4DibqUvrBrydUQYvOIWXz1SZEvtUBu9tFOauIRsr
         0IeOe43PsOOz7F8z65/f+nsvqYDx8T5BZ4a9SQGlFvmpjxbElqC+QVVCh0y2SoEMmY/H
         vOpLLVrqnQdodcC/nmDCMluDiLBqrvtOwPqdlyjs+ciQjTtXiGL1lx5SChibTEp1hzq/
         V1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1OdaxtB4LssE4g+n1VNEzexPIrO9OAMoPZzNOdCXvKY=;
        b=riRcU+lmji59DzJe9BxrlUxfoHE42QPsXEdE5UJf1NY+mB14wSknpUfmdfqUwQ8ZCT
         PJUwoYjwwet+sy8Pf7cqOVfzBRfoTHNw0pyNer6qTCdSfh0PFqBRjMYAOVDsrpHVOZfE
         3y+2AXXwke/5H2dTWBYKw8eaxSkobyjJJCZDNGjtMD0CQyIYGd7W690IKGwb9EirhdRP
         OZEDseHqvdUIDssxfyIKLbyiMu2m3ZuBl4hPtdiRCfFlE6LfU8qjRmy2e7lDobYT6lQj
         XRRxrliulGzJVeBdKvQibZacrXM1aDaerH5CwO3Iag2smPlfWzSUdo/LCRWOQtXoh1U+
         ye3A==
X-Gm-Message-State: AOAM5314S4P1wR3DPCnArMCZ/HllBgjud1yjqPelFFww8VvjgtsNXxg0
        sTYYrwISTemgQSMm5MmV3UsQkjDpxTw=
X-Google-Smtp-Source: ABdhPJxBNZe6+SXory3SW2EaJ0Q55CqSM6F40MCnVFQf5Lm6LwbjSvgWVKf8lR5vxNCMHV6MjEMaJA==
X-Received: by 2002:aa7:cc96:: with SMTP id p22mr52797018edt.91.1635873967737;
        Tue, 02 Nov 2021 10:26:07 -0700 (PDT)
Received: from md2k7s8c.fritz.box ([2a02:810d:9040:4c1f:e0b6:d0e7:64d2:f3a0])
        by smtp.gmail.com with ESMTPSA id ho17sm2954008ejc.111.2021.11.02.10.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 10:26:07 -0700 (PDT)
From:   Andreas Oetken <ennoerlangen@gmail.com>
X-Google-Original-From: Andreas Oetken <andreas.oetken@siemens-energy.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Andreas Oetken <ennoerlangen@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andreas Oetken <andreas.oetken@siemens-energy.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] drivers: mtd: Fixed breaking list in __mtd_del_partition.
Date:   Tue,  2 Nov 2021 18:26:04 +0100
Message-Id: <20211102172604.2921065-1-andreas.oetken@siemens-energy.com>
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

