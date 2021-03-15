Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279A233B730
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhCON7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231764AbhCON6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBFD964F21;
        Mon, 15 Mar 2021 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816707;
        bh=3Xtx1xluerSHb2MuXtSuO+2Aui405FGB83xaJuhkix4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRTeWn1YlDquiCewCzY63OwNMn3vK648Pcm1h0Vg5WW90v+GGXFKM3ZH1zCLk0Hdj
         eePwIsslwD5Qv7TC7KiuP3odkqlmUYk03JIkymF1BfiHo7l0ASrXNsAw7WN0yZMLWH
         LtHfRUBuwCrsri2cKtRUHMMgMoKjkvalx3N3nQKU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/168] net: hns3: fix error mask definition of flow director
Date:   Mon, 15 Mar 2021 14:54:51 +0100
Message-Id: <20210315135552.299941159@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit ae85ddda0f1b341b2d25f5a5e0eff1d42b6ef3df ]

Currently, some bit filed definitions of flow director TCAM
configuration command are incorrect. Since the wrong MSB is
always 0, and these fields are assgined in order, so it still works.

Fix it by redefine them.

Fixes: 117328680288 ("net: hns3: Add input key and action config support for flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 1426eb5ddf3d..e34e0854635c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1018,16 +1018,16 @@ struct hclge_fd_tcam_config_3_cmd {
 #define HCLGE_FD_AD_DROP_B		0
 #define HCLGE_FD_AD_DIRECT_QID_B	1
 #define HCLGE_FD_AD_QID_S		2
-#define HCLGE_FD_AD_QID_M		GENMASK(12, 2)
+#define HCLGE_FD_AD_QID_M		GENMASK(11, 2)
 #define HCLGE_FD_AD_USE_COUNTER_B	12
 #define HCLGE_FD_AD_COUNTER_NUM_S	13
 #define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(20, 13)
 #define HCLGE_FD_AD_NXT_STEP_B		20
 #define HCLGE_FD_AD_NXT_KEY_S		21
-#define HCLGE_FD_AD_NXT_KEY_M		GENMASK(26, 21)
+#define HCLGE_FD_AD_NXT_KEY_M		GENMASK(25, 21)
 #define HCLGE_FD_AD_WR_RULE_ID_B	0
 #define HCLGE_FD_AD_RULE_ID_S		1
-#define HCLGE_FD_AD_RULE_ID_M		GENMASK(13, 1)
+#define HCLGE_FD_AD_RULE_ID_M		GENMASK(12, 1)
 
 struct hclge_fd_ad_config_cmd {
 	u8 stage;
-- 
2.30.1



