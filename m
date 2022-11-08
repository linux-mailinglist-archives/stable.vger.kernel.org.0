Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32B56213B6
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiKHNxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiKHNwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:52:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ABC1D0DE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:52:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15623B81AE8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456EAC433C1;
        Tue,  8 Nov 2022 13:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915566;
        bh=sRXa636NSa1Y0MHd3SWUVykoJ3oK4byAT86igUH8/cA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8OnoAu2vBBtwbYhxfGZNrnWBD/KvDt2FTYqhibtd3PoOpvev+1sjK50RSZfyokLi
         7Hxd8E85roG0D6n4V4Z1bAYnjFzPtvfPEBnxCBuAD5eDasQ25ac8fOkRmJLsbagmqj
         ODLN9i61IDjBVsdgA73/xHoPCuVFiVS4pJmqqxvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/118] nfc: nfcmrvl: Fix potential memory leak in nfcmrvl_i2c_nci_send()
Date:   Tue,  8 Nov 2022 14:38:25 +0100
Message-Id: <20221108133341.836879145@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 93d904a734a74c54d945a9884b4962977f1176cd ]

nfcmrvl_i2c_nci_send() will be called by nfcmrvl_nci_send(), and skb
should be freed in nfcmrvl_i2c_nci_send(). However, nfcmrvl_nci_send()
will only free skb when i2c_master_send() return >=0, which means skb
will memleak when i2c_master_send() failed. Free skb no matter whether
i2c_master_send() succeeds.

Fixes: b5b3e23e4cac ("NFC: nfcmrvl: add i2c driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nfcmrvl/i2c.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index f81f1cae9324..41f27e1cac20 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -151,10 +151,15 @@ static int nfcmrvl_i2c_nci_send(struct nfcmrvl_private *priv,
 			ret = -EREMOTEIO;
 		} else
 			ret = 0;
+	}
+
+	if (ret) {
 		kfree_skb(skb);
+		return ret;
 	}
 
-	return ret;
+	consume_skb(skb);
+	return 0;
 }
 
 static void nfcmrvl_i2c_nci_update_config(struct nfcmrvl_private *priv,
-- 
2.35.1



