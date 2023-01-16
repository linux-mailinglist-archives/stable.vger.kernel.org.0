Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7264F66C774
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbjAPQbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjAPQac (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:30:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22D33B0C0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:18:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EDFE61040
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C6FC433D2;
        Mon, 16 Jan 2023 16:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885929;
        bh=HmFwWceY8MtVtn10Vydj3WI6d2uxZBsjHLu/7tTDg0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRKsdBAYKZG4yRbQLT4idNhqL0c3woMS128Fjv2M3Oxfz1YzKqD7TgEhXUb8ows/i
         CzreZweGjjn1ns2x+KpN+Q5xqAjjbNqN2O+8Xq+J9L8p6CPmFsa3ep6Q8TwPLL8E9z
         F+UyWVqhIFzytkTNkmG0bFIW+UDSaub3uIbVCAI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 237/658] Bluetooth: hci_core: dont call kfree_skb() under spin_lock_irqsave()
Date:   Mon, 16 Jan 2023 16:45:25 +0100
Message-Id: <20230116154920.389174608@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 39c1eb6fcbae8ce9bb71b2ac5cb609355a2b181b ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 9238f36a5a50 ("Bluetooth: Add request cmd_complete and cmd_status functions")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 2ebb6480b6ec..e5e1c139f211 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4455,7 +4455,7 @@ void hci_req_cmd_complete(struct hci_dev *hdev, u16 opcode, u8 status,
 			*req_complete_skb = bt_cb(skb)->hci.req_complete_skb;
 		else
 			*req_complete = bt_cb(skb)->hci.req_complete;
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 	}
 	spin_unlock_irqrestore(&hdev->cmd_q.lock, flags);
 }
-- 
2.35.1



