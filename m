Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C63B62144B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbiKHN7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234842AbiKHN7q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:59:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610E053ECE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:59:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04DF7B81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A63EC433D6;
        Tue,  8 Nov 2022 13:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915982;
        bh=4yE1MVS7AlY2X1X9s/Hdo6H9L2GTHOLKaxeTSIVKFg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TpuQCnDmF3DvJF2nGlHR+Lwiz/dnfVMAxpCn2QliSLmqMq90I4PzjY2pZ1X9H2xHU
         GWoaPu5ft93AJz/WjniIMTDpUOTYBbzFx0btuUu/vUcTsxweJOOKPDCxCvJkugODq+
         Vd4TFvmbVwffPkMepoB/KFYN9UDLdSKmrocFadDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/144] nfc: fdp: Fix potential memory leak in fdp_nci_send()
Date:   Tue,  8 Nov 2022 14:38:25 +0100
Message-Id: <20221108133346.471564973@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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



