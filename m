Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26989461DAB
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349972AbhK2S1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:27:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347797AbhK2SZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:25:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 341B9B815D7;
        Mon, 29 Nov 2021 18:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA66C53FAD;
        Mon, 29 Nov 2021 18:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210137;
        bh=QpY4bwW0UtOrWSiJMZmh8eus6yMNRf+zdSLeLu3VpD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1N/sR/nUoVaJo1k0HrTm9hXO1t0rw7Q3zEZKMuGC5ckGuQafiTM808G7FVZSdelPC
         9QkEpYq3lWIKXOzv3PEGeMJixS5c8E15q2iMDVpsKNW4gqJ4OU5qpOcDxxqFrSHiYh
         YJOy9XwO4SibJ2SQ7Vjh1YCluRf2M2byM/sIGX5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/69] net: hns3: fix VF RSS failed problem after PF enable multi-TCs
Date:   Mon, 29 Nov 2021 19:18:36 +0100
Message-Id: <20211129181705.408456754@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 8d2ad993aa05c0768f00c886c9d369cd97a337ac ]

When PF is set to multi-TCs and configured mapping relationship between
priorities and TCs, the hardware will active these settings for this PF
and its VFs.

In this case when VF just uses one TC and its rx packets contain priority,
and if the priority is not mapped to TC0, as other TCs of VF is not valid,
hardware always put this kind of packets to the queue 0. It cause this kind
of packets of VF can not be used RSS function.

To fix this problem, set tc mode of all unused TCs of VF to the setting of
TC0, then rx packet with priority which map to unused TC will be direct to
TC0.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index fd5375b5991bb..a257bf635bc24 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -451,9 +451,9 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 	roundup_size = ilog2(roundup_size);
 
 	for (i = 0; i < HCLGEVF_MAX_TC_NUM; i++) {
-		tc_valid[i] = !!(hdev->hw_tc_map & BIT(i));
+		tc_valid[i] = 1;
 		tc_size[i] = roundup_size;
-		tc_offset[i] = rss_size * i;
+		tc_offset[i] = (hdev->hw_tc_map & BIT(i)) ? rss_size * i : 0;
 	}
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_TC_MODE, false);
-- 
2.33.0



