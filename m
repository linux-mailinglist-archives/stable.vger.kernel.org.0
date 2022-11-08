Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C3262150F
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiKHOH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiKHOHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:07:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D4F70566
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:07:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C7DB615AF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898ACC433D7;
        Tue,  8 Nov 2022 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916469;
        bh=8iG3gZbAJzyY/Ibfu7meHeqS0JhG5FB4IHS++RxZwIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alz9wr2bGQ6eIbGhMOuIQPvOOizTyjn5Mo02jjebqFbWJSQ7J3tbxoMVhkr2+4LjK
         ULqkwJH0iT8YzDe19KmMH3r2tsNcFpJ3C4YHGgPklmKyAAc5R/fW2a35VeIkAT6i3k
         lwb4aBid6Zw48xAUnQTkJg17jQ4CZaCbpFb+dT6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 023/197] nfc: s3fwrn5: Fix potential memory leak in s3fwrn5_nci_send()
Date:   Tue,  8 Nov 2022 14:37:41 +0100
Message-Id: <20221108133355.837171459@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

[ Upstream commit 3a146b7e3099dc7cf3114f627d9b79291e2d2203 ]

s3fwrn5_nci_send() will call s3fwrn5_i2c_write() or s3fwrn82_uart_write(),
and free the skb if write() failed. However, even if the write() run
succeeds, the skb will not be freed in write(). As the result, the skb
will memleak. s3fwrn5_nci_send() should also free the skb when write()
succeeds.

Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index 1c412007fabb..0270e05b68df 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -110,11 +110,15 @@ static int s3fwrn5_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	}
 
 	ret = s3fwrn5_write(info, skb);
-	if (ret < 0)
+	if (ret < 0) {
 		kfree_skb(skb);
+		mutex_unlock(&info->mutex);
+		return ret;
+	}
 
+	consume_skb(skb);
 	mutex_unlock(&info->mutex);
-	return ret;
+	return 0;
 }
 
 static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
-- 
2.35.1



