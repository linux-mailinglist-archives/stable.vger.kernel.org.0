Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE1E41258F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354468AbhITSqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382709AbhITSmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60F0F63343;
        Mon, 20 Sep 2021 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159100;
        bh=CvchOUNTHdjar7sBjL9a72C3sS6vFes1cyYXWl3zJXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DF+qj7K7HZF8/ZIukPtYF/GML99yxrH2sh4ro6C1H1ntOy3Pfh2X4UR2p57NqRQm7
         b0qrlVdGuh+q7cQWiickrlNDn/RIPTg5svgsj5TGwHMLLhgZeJ+EuOdMVNPsGViJHT
         gtzwOqhhIUOKLiBjGfhG28Mns5C08Ev/RO9fSv10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 077/168] net: hns3: disable mac in flr process
Date:   Mon, 20 Sep 2021 18:43:35 +0200
Message-Id: <20210920163924.172756238@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
@@ -8120,11 +8120,12 @@ static void hclge_ae_stop(struct hnae3_h
 	hclge_clear_arfs_rules(hdev);
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


