Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9493667589
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbjALOWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbjALOWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:22:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A2059500
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:13:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFBDC6202B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A02C433D2;
        Thu, 12 Jan 2023 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532788;
        bh=4kbemMex2oVRLLSm+HzMkJrdnvmPiKeNLAQ/wxEIytI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSAS+BCLotzBIkoHnZhvd9rLI+Yo6dteWChd4UVgos/VaAmjlD0iWeDkFSJMvXUdY
         UI0164taHrTNSohJRtinSQy4aFgbS59wD7nAGn+1Rw3n3HRptFgxtctCc/23mbe5JG
         EkVpLUStll5uzcFSboq9ipu8NaVvYnoSyw4GBgwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/783] Bluetooth: btusb: dont call kfree_skb() under spin_lock_irqsave()
Date:   Thu, 12 Jan 2023 14:49:45 +0100
Message-Id: <20230112135536.885550789@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b15a6bd3c80c77faec8317319b97f976b1a08332 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 803b58367ffb ("Bluetooth: btusb: Implement driver internal packet reassembly")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 54001ad5de9f..3d905fda9b29 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -661,13 +661,13 @@ static inline void btusb_free_frags(struct btusb_data *data)
 
 	spin_lock_irqsave(&data->rxlock, flags);
 
-	kfree_skb(data->evt_skb);
+	dev_kfree_skb_irq(data->evt_skb);
 	data->evt_skb = NULL;
 
-	kfree_skb(data->acl_skb);
+	dev_kfree_skb_irq(data->acl_skb);
 	data->acl_skb = NULL;
 
-	kfree_skb(data->sco_skb);
+	dev_kfree_skb_irq(data->sco_skb);
 	data->sco_skb = NULL;
 
 	spin_unlock_irqrestore(&data->rxlock, flags);
-- 
2.35.1



