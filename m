Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4310551E57
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbiFTOUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351115AbiFTOSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 10:18:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2490938D93;
        Mon, 20 Jun 2022 06:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 427B4CE1394;
        Mon, 20 Jun 2022 13:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E093C3411B;
        Mon, 20 Jun 2022 13:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730465;
        bh=P9YpZFue1tW+UBDOFxFwfnTgZzInENd113+wr2whioA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVwGh1DDG7rLM4weRD4EMLBGTmJtjBHSSDliPbpXu5c9bbGYoZwRAWBfFT3yZtZ2p
         C/7VsOmnoIQvxMOWcP5XiKKlwIBpsgXJ/sk7l/o/IuarGyaI7fDCmleAmbpXQRsuet
         ybE/t/qsBQus6TBGVD8/49eVQWfMIm9kDG3kigfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/106] net: hns3: set port base vlan tbl_sta to false before removing old vlan
Date:   Mon, 20 Jun 2022 14:51:20 +0200
Message-Id: <20220620124726.205777811@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
References: <20220620124724.380838401@linuxfoundation.org>
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

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 9eda7d8bcbdb6909f202edeedff51948f1cad1e5 ]

When modify port base vlan, the port base vlan tbl_sta needs to set to
false before removing old vlan, to indicate this operation is not finish.

Fixes: c0f46de30c96 ("net: hns3: fix port base vlan add fail when concurrent with reset")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index cdd1d2ebdde2..15098570047b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10411,6 +10411,7 @@ static int hclge_modify_port_base_vlan_tag(struct hclge_vport *vport,
 	if (ret)
 		return ret;
 
+	vport->port_base_vlan_cfg.tbl_sta = false;
 	/* remove old VLAN tag */
 	if (old_info->vlan_tag == 0)
 		ret = hclge_set_vf_vlan_common(hdev, vport->vport_id,
-- 
2.35.1



