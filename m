Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B828B412376
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352125AbhITSZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377708AbhITSW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:22:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF924632C2;
        Mon, 20 Sep 2021 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158667;
        bh=01A7hg0luvvHutHgUdAsWYsGXGS2biR/gkZDFPQxexo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNq2rzpvzFnJGm/PqEKh26mwwg6+AhPrxkTPmNFpLoTsoFCucYCL2qQG4ebpi5+zX
         gK5snh38MRDhyj7wjHZ/IOrHxHRej4peomL+CeNCEMINESKiEDDgNVJ5e+y5IqBAOg
         x+t2MHVdnxCS6Iid5zGdcRZWRH87gh97yMBI8NOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 230/260] net: hns3: disable mac in flr process
Date:   Mon, 20 Sep 2021 18:44:08 +0200
Message-Id: <20210920163938.932240118@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

commit b81d8948746520f989e86d66292ff72b5056114a upstream.

The firmware will not disable mac in flr process. Therefore, the driver
needs to proactively disable mac during flr, which is the same as the
function reset.

Fixes: 35d93a30040c ("net: hns3: adjust the process of PF reset")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6685,11 +6685,12 @@ static void hclge_ae_stop(struct hnae3_h
 	hclge_clear_arfs_rules(handle);
 	spin_unlock_bh(&hdev->fd_rule_lock);
 
-	/* If it is not PF reset, the firmware will disable the MAC,
+	/* If it is not PF reset or FLR, the firmware will disable the MAC,
 	 * so it only need to stop phy here.
 	 */
 	if (test_bit(HCLGE_STATE_RST_HANDLING, &hdev->state) &&
-	    hdev->reset_type != HNAE3_FUNC_RESET) {
+	    hdev->reset_type != HNAE3_FUNC_RESET &&
+	    hdev->reset_type != HNAE3_FLR_RESET) {
 		hclge_mac_stop_phy(hdev);
 		hclge_update_link_status(hdev);
 		return;


