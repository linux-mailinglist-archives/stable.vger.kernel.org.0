Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4A657F88
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234354AbiL1QGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbiL1QFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:05:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6422D321
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED5636156B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C07C433D2;
        Wed, 28 Dec 2022 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243544;
        bh=r48e+VeTR/hxrK1UUoTkSGSSWUWJtuCwiMNWgRFVuaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdDp53obu0plkBSGsxrvUsy014b72oDpplYym7lyyCMY+M2URVo8gU8P67sSfbuGw
         eid4nf99qo5JFEZlL6jQGlvcNkzgPXI4F0Uo19Ex5PloB9nI6Ejd049lVn9+6eUxO1
         CtuN/05IMtSQKKB9+ACLs0y+3b6YGFsV0sSUof/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0545/1073] Bluetooth: hci_ll: dont call kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:35:33 +0100
Message-Id: <20221228144342.859027632@linuxfoundation.org>
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

[ Upstream commit 8f458f783dfbb19c1f1cb58ed06eeb701f52091b ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 166d2f6a4332 ("[Bluetooth] Add UART driver for Texas Instruments' BRF63xx chips")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index 4eb420a9ed04..5abc01a2acf7 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -345,7 +345,7 @@ static int ll_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 	default:
 		BT_ERR("illegal hcill state: %ld (losing packet)",
 		       ll->hcill_state);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		break;
 	}
 
-- 
2.35.1



