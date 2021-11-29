Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762704627AD
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbhK2XIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236462AbhK2XID (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:08:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0285C048F4C;
        Mon, 29 Nov 2021 10:40:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74726B815DE;
        Mon, 29 Nov 2021 18:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11C1C53FAD;
        Mon, 29 Nov 2021 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211239;
        bh=/xuoV2F/c2nu/eu3hM5EyEvGu/4BjOSi/zCJH49NEwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmg5XA1XQcXA2YYRbYZkbpKuRyTWOuJ/+a44f1JhzG7IMlfh+y1avsgPDvSS+fgZK
         8AKW7SLq3gHQcOdWDqcecoGGqQ+UyKIN06qUfJhJFpw+A9LUB/6tCr5mP+WVYIeE8W
         Y9xv+FE93z0HFMZbjxyuR/CPttmDXst7Be35AY64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/179] net: hns3: fix VF RSS failed problem after PF enable multi-TCs
Date:   Mon, 29 Nov 2021 19:19:05 +0100
Message-Id: <20211129181723.927115521@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index 3b8bde58613a8..fee7d9e79f8c3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -703,9 +703,9 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
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



