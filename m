Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2A9623FA
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfGHPjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:39:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbfGHP3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99393204EC;
        Mon,  8 Jul 2019 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599793;
        bh=s1k1F5quKTgHa+VggIV+0M3Yj0ny8zHIvRpb5ldtwvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5GM5kmXoArawUKlKVTaHarnFeqMP56o/py2k26fobtjcmGyotqerXLX9xQ1ysVRi
         CCcMCLttYwYS29sHWzKhjpDGa7XKLPKKuAAllpr472DtpOeFeZcqiHecS90/CQrWS2
         +96MZZKndloChd8LKtCBsldgAPezO8LYxFMFJooM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mukesh Ojha <mojha@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 79/90] net: hns: fix unsigned comparison to less than zero
Date:   Mon,  8 Jul 2019 17:13:46 +0200
Message-Id: <20190708150526.356784871@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ea401685a20b5d631957f024bda86e1f6118eb20 ]

Currently mskid is unsigned and hence comparisons with negative
error return values are always false. Fix this by making mskid an
int.

Fixes: f058e46855dc ("net: hns: fix ICMP6 neighbor solicitation messages discard problem")
Addresses-Coverity: ("Operands don't affect result")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
index f5ff07cb2b72..f2b0b587a1be 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c
@@ -2777,7 +2777,7 @@ static void set_promisc_tcam_enable(struct dsaf_device *dsaf_dev, u32 port)
 	struct hns_mac_cb *mac_cb;
 	u8 addr[ETH_ALEN] = {0};
 	u8 port_num;
-	u16 mskid;
+	int mskid;
 
 	/* promisc use vague table match with vlanid = 0 & macaddr = 0 */
 	hns_dsaf_set_mac_key(dsaf_dev, &mac_key, 0x00, port, addr);
-- 
2.20.1



