Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA9C657FD4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiL1QKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiL1QKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:10:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8043A193D5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C89F7B81889
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B7BC433EF;
        Wed, 28 Dec 2022 16:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243715;
        bh=K3rmuZX1b5lD6E0U3TzoMByv+RHDICatYQ0mM9IeOLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpe1Fx07dwRv0Ow3FST/N1A/aVUXJp86QsTDqMMfmUgDSiJRjcAQsp0cGJNHmQ/1I
         APEW+bOnXgdylZ22JCl8eUqKBOC7BwwlK7qVC0br+PPbhmkiptrkVPTFrwnIAhtZLA
         qpOOkOyLF7as/ZXrWxzLt/dBKtj4yGWAJDw8cqT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0543/1073] Bluetooth: btusb: dont call kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:35:31 +0100
Message-Id: <20221228144342.804939707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 882b5893f910..a132e7aba605 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -788,13 +788,13 @@ static inline void btusb_free_frags(struct btusb_data *data)
 
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



