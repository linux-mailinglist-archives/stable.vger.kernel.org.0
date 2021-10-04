Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD14420ECE
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhJDN2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236591AbhJDN0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:26:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FFBA61248;
        Mon,  4 Oct 2021 13:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353103;
        bh=CoIpvyKWAZY8veJGO7LiT/FctQhzFTjiuoU5LBIlB5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qs3QegKDc5GoD+ghd/oM4k7eQJBor6PwuX4P7jYBORIZEarRpYgzAq7cgsV6kq7kK
         Xr9HGDR/k2h0FUvg7oVrfyQgz4+CBue+zUe30Y9fXYu5bdCyLGoQmUF3aDppa27I9f
         7gLX125sLur/QtrIppSBdY4qT4Uvlc6twXvOnckc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 57/93] net: hns3: keep MAC pause mode when multiple TCs are enabled
Date:   Mon,  4 Oct 2021 14:52:55 +0200
Message-Id: <20211004125036.453176787@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit d78e5b6a6764cb6e83668806b63d74566db36399 ]

Bellow HNAE3_DEVICE_VERSION_V3, MAC pause mode just support one
TC, when enabled multiple TCs, force enable PFC mode.

HNAE3_DEVICE_VERSION_V3 can support MAC pause mode on multiple
TCs, so when enable multiple TCs, just keep MAC pause mode,
and enable PFC mode just according to the user settings.

Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index e8495f58a1a8..42e82bf69b8e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -682,7 +682,7 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 	}
 }
 
-static void hclge_pfc_info_init(struct hclge_dev *hdev)
+static void hclge_update_fc_mode_by_dcb_flag(struct hclge_dev *hdev)
 {
 	if (!(hdev->flag & HCLGE_FLAG_DCB_ENABLE)) {
 		if (hdev->fc_mode_last_time == HCLGE_FC_PFC)
@@ -700,6 +700,27 @@ static void hclge_pfc_info_init(struct hclge_dev *hdev)
 	}
 }
 
+static void hclge_update_fc_mode(struct hclge_dev *hdev)
+{
+	if (!hdev->tm_info.pfc_en) {
+		hdev->tm_info.fc_mode = hdev->fc_mode_last_time;
+		return;
+	}
+
+	if (hdev->tm_info.fc_mode != HCLGE_FC_PFC) {
+		hdev->fc_mode_last_time = hdev->tm_info.fc_mode;
+		hdev->tm_info.fc_mode = HCLGE_FC_PFC;
+	}
+}
+
+static void hclge_pfc_info_init(struct hclge_dev *hdev)
+{
+	if (hdev->ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3)
+		hclge_update_fc_mode(hdev);
+	else
+		hclge_update_fc_mode_by_dcb_flag(hdev);
+}
+
 static void hclge_tm_schd_info_init(struct hclge_dev *hdev)
 {
 	hclge_tm_pg_info_init(hdev);
-- 
2.33.0



