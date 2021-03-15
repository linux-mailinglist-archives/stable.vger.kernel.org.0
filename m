Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4683033B7FA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCOOBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232781AbhCON74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 321EF64EEF;
        Mon, 15 Mar 2021 13:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816776;
        bh=6oitWgIH5mIY2SE+wNaQ6r+GtKwh0skbfozHpeWqKuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwdakz/8Gn7JJUy8nasTpPbAa9LtHMStKQNnecFdvqaeReUaVuUoqUvW6pSQmhhrv
         XNlsFSB+UVwLWsdr+uq8w3de0J9zxVuFVcuP2vsdsDpQXRmPh/xbBVqjl54v8Ebd/n
         YKV0YAn8TZtMwWuc88ZiXLIRBMV9pF8+6V7jO73w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/290] net: hns3: fix error mask definition of flow director
Date:   Mon, 15 Mar 2021 14:53:21 +0100
Message-Id: <20210315135545.553699274@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
index 096e26a2e16b..36690fc5c1af 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1031,16 +1031,16 @@ struct hclge_fd_tcam_config_3_cmd {
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



