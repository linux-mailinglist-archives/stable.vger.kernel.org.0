Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9BB657F92
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbiL1QHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiL1QGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:06:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3442601
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:06:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A41ADB81710
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A75C433EF;
        Wed, 28 Dec 2022 16:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243568;
        bh=bktM29YH+mPA5FP70SplWDHXMJ7rWJmJi2Y4vZ8tldo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAF7nynKbvkhu0An/wLGkyCcn5pC9XECAE/DSQaohR4UR4y+L9iqNAUP3LrTOLYU9
         ZAUJmx8O+lIKX9mtTZEBrwc2bunpv7dvDnA0drTtEgt0SrhEUTtPaAD2sDOUF++T8N
         yd5VQ/RKxybsodNJ8/gJlVOxAYqGgRElqPJ2os5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0549/1073] Bluetooth: RFCOMM: dont call kfree_skb() under spin_lock_irqsave()
Date:   Wed, 28 Dec 2022 15:35:37 +0100
Message-Id: <20221228144342.966353068@linuxfoundation.org>
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

[ Upstream commit 0ba18967d4544955b2eff2fbc4f2a8750c4df90a ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled. So replace kfree_skb()
with dev_kfree_skb_irq() under spin_lock_irqsave().

Fixes: 81be03e026dc ("Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/rfcomm/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 7324764384b6..8d6fce9005bd 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -590,7 +590,7 @@ int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 
 		ret = rfcomm_dlc_send_frag(d, frag);
 		if (ret < 0) {
-			kfree_skb(frag);
+			dev_kfree_skb_irq(frag);
 			goto unlock;
 		}
 
-- 
2.35.1



