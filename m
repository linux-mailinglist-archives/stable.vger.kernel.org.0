Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA25621504
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbiKHOHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235133AbiKHOHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:07:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDE1748C0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81C2611B7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32ABC433C1;
        Tue,  8 Nov 2022 14:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916440;
        bh=4yE1MVS7AlY2X1X9s/Hdo6H9L2GTHOLKaxeTSIVKFg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GW1mebX01fT5CkdK0bmouT/Ez4szQdm/sh57eCY6RBsoVKyK/5xxPOTCPQ9PmtspE
         mOVQQhPqQWO9yQ/gXROl6gc3xhVGChH3DGeQoPUQiNzXv4t/GxWW+pV1JtiZuT5P0Y
         I+xuJDdjXFzrPp1nQpQB6aqfTD3UBri6sjTVJwq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 021/197] nfc: fdp: Fix potential memory leak in fdp_nci_send()
Date:   Tue,  8 Nov 2022 14:37:39 +0100
Message-Id: <20221108133355.740478245@linuxfoundation.org>
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

[ Upstream commit 8e4aae6b8ca76afb1fb64dcb24be44ba814e7f8a ]

fdp_nci_send() will call fdp_nci_i2c_write that will not free skb in
the function. As a result, when fdp_nci_i2c_write() finished, the skb
will memleak. fdp_nci_send() should free skb after fdp_nci_i2c_write()
finished.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/fdp/fdp.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index c6b3334f24c9..f12f903a9dd1 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -249,11 +249,19 @@ static int fdp_nci_close(struct nci_dev *ndev)
 static int fdp_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	struct fdp_nci_info *info = nci_get_drvdata(ndev);
+	int ret;
 
 	if (atomic_dec_and_test(&info->data_pkt_counter))
 		info->data_pkt_counter_cb(ndev);
 
-	return info->phy_ops->write(info->phy, skb);
+	ret = info->phy_ops->write(info->phy, skb);
+	if (ret < 0) {
+		kfree_skb(skb);
+		return ret;
+	}
+
+	consume_skb(skb);
+	return 0;
 }
 
 static int fdp_nci_request_firmware(struct nci_dev *ndev)
-- 
2.35.1



