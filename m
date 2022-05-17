Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39C8529EA0
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 12:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbiEQJ7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 05:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242714AbiEQJ6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 05:58:53 -0400
Received: from m12-17.163.com (m12-17.163.com [220.181.12.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B893837BEC;
        Tue, 17 May 2022 02:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=mwRPMcpRJBg0cThT4d
        /ZOCT/9+uiGKioVu/+NOmemiw=; b=ME977hJpwhsd7gNJCn+WB+010iHdUhYc9J
        sm3vw7O1/09voYrD/MK3/qQj9K3PB6aOU+YeScwzEXSOkwzGrDH34Ajn4U9z3keJ
        DuM2zkTM8d5KfONtdQF+dye1qYrLYoEPZPP1UiFgDpAzCZ4Q/UkLnY9YbXQPwV6D
        CbWlxhv2Y=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp13 (Coremail) with SMTP id EcCowADnvJiycYNigpkBDA--.38973S4;
        Tue, 17 May 2022 17:58:21 +0800 (CST)
From:   Yuanjun Gong <ruc_gongyuanjun@163.com>
To:     Yuanjun Gong <ruc_gongyuanjun@163.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/1] staging: fix a potential infinite loop
Date:   Tue, 17 May 2022 17:58:09 +0800
Message-Id: <20220517095809.7791-1-ruc_gongyuanjun@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EcCowADnvJiycYNigpkBDA--.38973S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFyfuFyUWrWDJr1fJr17GFg_yoWftwc_GF
        yxKwn7XrnxCr1xtrs7GF48XrWSqrWxuw4vyF1Yqa98Way8try5Cw1DXr1DX34xJFWxGr9x
        CayxKr9YyFySgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sR_dWrJUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: 5uxfsw5rqj53pdqm30i6rwjhhfrp/xtbBex0E5WAY-ehOmgAAs+
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gong Yuanjun <ruc_gongyuanjun@163.com>

In the for-loop in _rtl92e_update_rxcounts(),
i is a u8 counter while priv->rtllib->LinkDetectInfo.SlotNum is
a u16 num, there is a potential infinite loop if SlotNum is larger
than u8_max.

Change the u8 loop counter i into u16.

Signed-off-by: Gong Yuanjun <ruc_gongyuanjun@163.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index b9ce71848023..3c5082abc583 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -1342,7 +1342,7 @@ static void _rtl92e_update_rxcounts(struct r8192_priv *priv, u32 *TotalRxBcnNum,
 				    u32 *TotalRxDataNum)
 {
 	u16	SlotIndex;
-	u8	i;
+	u16	i;
 
 	*TotalRxBcnNum = 0;
 	*TotalRxDataNum = 0;
-- 
2.17.1

