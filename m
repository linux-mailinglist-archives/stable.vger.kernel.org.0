Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C685AADED
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 13:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiIBL6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 07:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbiIBL6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 07:58:53 -0400
X-Greylist: delayed 488 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Sep 2022 04:58:52 PDT
Received: from gofer.mess.org (gofer.mess.org [88.97.38.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14252B5320;
        Fri,  2 Sep 2022 04:58:51 -0700 (PDT)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 4E0F1100073; Fri,  2 Sep 2022 12:50:38 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mess.org; s=2020;
        t=1662119438; bh=2zCl1lkjL0BCxyj5maeC6T9+7irhOLKH7/LLQN8b9Rs=;
        h=From:To:Cc:Subject:Date:From;
        b=pcSqeGYHoHmhH8APJdMwLm/MDNRXOsh+RkZVmyZ3JBFEyQ6B3j0xCBvvnjBlpynU+
         ERYYvo4vit0VIhMmHedxntQATQteyVhC3nGcTxm9yqJuFQMEhl9JbSynWT47JGGAt6
         9At41A7f0rElvTLgao3EBbSjq6aQ2XPIGZj9JTxvnSQjf8+me5UI7jDFYW4f/fKitW
         HE9ejjlD71aVzJS7hkea2vuHPUbkTVJy/3umnOUjp6WBrSb5BKultnsfdodGTF2yX+
         A6R/pNNdWp6/SKqriLLUK9KAzQs9gBBR7IZc53aGFgZpuiGMUn4rUwH9AUiwjFF8/u
         rxldq+FbkO4yg==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] media: mceusb: set timeout to at least timeout provided
Date:   Fri,  2 Sep 2022 12:50:38 +0100
Message-Id: <20220902115038.1061394-1-sean@mess.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By rounding down, we can set a timeout value which reports spaces less
than the timeout as a timeout rather than a space.

Fixes: 877f1a7cee3f ("media: rc: mceusb: allow the timeout to be configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 39d2b03e2631..c76ba24c1f55 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1077,7 +1077,7 @@ static int mceusb_set_timeout(struct rc_dev *dev, unsigned int timeout)
 	struct mceusb_dev *ir = dev->priv;
 	unsigned int units;
 
-	units = DIV_ROUND_CLOSEST(timeout, MCE_TIME_UNIT);
+	units = DIV_ROUND_UP(timeout, MCE_TIME_UNIT);
 
 	cmdbuf[2] = units >> 8;
 	cmdbuf[3] = units;
-- 
2.37.2

