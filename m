Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743D551A7B5
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353836AbiEDRH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356141AbiEDREz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E095044A;
        Wed,  4 May 2022 09:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00F90B8278E;
        Wed,  4 May 2022 16:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E20C385AA;
        Wed,  4 May 2022 16:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683230;
        bh=JrrDOlBVAfWDdjJZys8Nl/UqHDzlTicg1HmdZAOETbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0UOJwuRjgabAa8HNaLagH4gs9FqDJ/DHdXpgl0dChhifIupC7RR9xSzBTRmUqthL
         yq0LscY+OF/Vb5VorbSBfpfdDtE6rmLsGmP2rRSKsm45xR2XTwUQYANvUhbKsaVSSy
         OdmbGAHx7rooAXiMZGhphK2mWCXf0FjpyCCWq3+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/177] net: hns3: add validity check for message data length
Date:   Wed,  4 May 2022 18:44:48 +0200
Message-Id: <20220504153101.599292489@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 7d413735cb18ff73aaba3457b16b08332e8d3cc4 ]

Add validity check for message data length in function
hclge_send_mbx_msg(), avoid unexpected overflow.

Fixes: dde1a86e93ca ("net: hns3: Add mailbox support to PF driver")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index e30bf3027375..c256305a2212 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -93,6 +93,13 @@ static int hclge_send_mbx_msg(struct hclge_vport *vport, u8 *msg, u16 msg_len,
 	enum hclge_cmd_status status;
 	struct hclge_desc desc;
 
+	if (msg_len > HCLGE_MBX_MAX_MSG_SIZE) {
+		dev_err(&hdev->pdev->dev,
+			"msg data length(=%u) exceeds maximum(=%u)\n",
+			msg_len, HCLGE_MBX_MAX_MSG_SIZE);
+		return -EMSGSIZE;
+	}
+
 	resp_pf_to_vf = (struct hclge_mbx_pf_to_vf_cmd *)desc.data;
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_MBX_PF_TO_VF, false);
-- 
2.35.1



