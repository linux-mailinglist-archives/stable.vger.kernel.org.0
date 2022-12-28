Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF89E657AB6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbiL1PO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiL1POC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:14:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4D213E3C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAD98B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FCAC433EF;
        Wed, 28 Dec 2022 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240438;
        bh=PCWzEaybhJ4ZtyWCSo+H0GuBY9Q8YxgUjAqg68gIfYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qa5hrvseBWuMYjdJFrNt2ArBfs35JRAc6rbU3CIGGHtEH3Zi+2uzWKgyZKfyrZ+jO
         yf0rne/8JqgO2yeuVU4xXepq74eQe2VbR4HvXOSMlT39upiKhCBaUn4PHqHxYi2VL6
         MN1C92oVisvWqG8K70JRz7YlQa9MrJmJ1kNEiU9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/731] Bluetooth: hci_core: dont call kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:37:40 +0100
Message-Id: <20221228144306.796212799@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index bb84ff5fb98a..a41b4dcf1a7a 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -5101,7 +5101,7 @@ void hci_req_cmd_complete(struct hci_dev *hdev, u16 opcode, u8 status,
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



