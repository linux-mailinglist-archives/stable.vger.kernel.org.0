Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEAF62153A
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbiKHOJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbiKHOJ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:09:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263E81DA58
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:09:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B80C2615CD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4711C4314E;
        Tue,  8 Nov 2022 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916563;
        bh=d8NoVb5siINMkbm/2+Hz/btJW1tA7fbky4X/cfJY6lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjTC9rNZPS2sxaS5bJ2xlojYK/8sBcEIM0n1qQod4baLgESmxUdQXCsCZmsxRjp8f
         HC4QM72nca+Nz/0ReMGfQy/BUQL2fV/MHSUfTW6XLcpTsNZjXR/VVDxidXn8qGS+Ht
         atYbJ8fffwCzK/3GJxWTdMBfrCMBNJ/v8k46CD/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 022/197] nfc: nxp-nci: Fix potential memory leak in nxp_nci_send()
Date:   Tue,  8 Nov 2022 14:37:40 +0100
Message-Id: <20221108133355.787155199@linuxfoundation.org>
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

[ Upstream commit 7bf1ed6aff0f70434bd0cdd45495e83f1dffb551 ]

nxp_nci_send() will call nxp_nci_i2c_write(), and only free skb when
nxp_nci_i2c_write() failed. However, even if the nxp_nci_i2c_write()
run succeeds, the skb will not be freed in nxp_nci_i2c_write(). As the
result, the skb will memleak. nxp_nci_send() should also free the skb
when nxp_nci_i2c_write() succeeds.

Fixes: dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI chips")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/nxp-nci/core.c b/drivers/nfc/nxp-nci/core.c
index 7c93d484dc1b..580cb6ecffee 100644
--- a/drivers/nfc/nxp-nci/core.c
+++ b/drivers/nfc/nxp-nci/core.c
@@ -80,10 +80,13 @@ static int nxp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 		return -EINVAL;
 
 	r = info->phy_ops->write(info->phy_id, skb);
-	if (r < 0)
+	if (r < 0) {
 		kfree_skb(skb);
+		return r;
+	}
 
-	return r;
+	consume_skb(skb);
+	return 0;
 }
 
 static int nxp_nci_rf_pll_unlocked_ntf(struct nci_dev *ndev,
-- 
2.35.1



