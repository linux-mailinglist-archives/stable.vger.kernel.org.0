Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BBC66CCCC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbjAPR3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjAPR2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:28:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C1C2C658
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:06:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC575B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4611AC433EF;
        Mon, 16 Jan 2023 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888778;
        bh=QVFppkz8YElOBuI8Ii5pcnZE0Gcp4HTiHiAAFLF01MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDdGt951baHv0RHaZtd7HzinAnWul7Ph7vb7r2WzGV268tkbYrJ2G4jyhK3mhqsjF
         ibcOi4nTAA9d/R04UTCrAyON+QioADrGMIHH4l8Yj9t9Lhx0BGuFLO6JwnrH6btn2G
         cLJl6n7zqdxgwdBrsqSVt4A5ktVs1xB5cIMZOhio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 135/338] Bluetooth: hci_qca: dont call kfree_skb() under spin_lock_irqsave()
Date:   Mon, 16 Jan 2023 16:50:08 +0100
Message-Id: <20230116154826.704935933@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

[ Upstream commit df4cfc91208e0a98f078223793f5871b1a82cc54 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 0ff252c1976d ("Bluetooth: hciuart: Add support QCA chipset for UART")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index a6173ddfb5a7..b802c012b495 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -715,7 +715,7 @@ static int qca_enqueue(struct hci_uart *hu, struct sk_buff *skb)
 	default:
 		BT_ERR("Illegal tx state: %d (losing packet)",
 		       qca->tx_ibs_state);
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		break;
 	}
 
-- 
2.35.1



