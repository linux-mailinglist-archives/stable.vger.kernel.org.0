Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1564F3021
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbiDEI3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239562AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D912C2649;
        Tue,  5 Apr 2022 01:16:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A210B81BAC;
        Tue,  5 Apr 2022 08:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E847DC385A0;
        Tue,  5 Apr 2022 08:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146583;
        bh=RLzp6IHuID3mzhqEJtLY+w8ussU7Yh0sM1fOo8fLpbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dnn4CYK8DxP0hTlvRIbXn5AQC1oWcpsZWD1ZO25+7T3ruQu+BQXUtHxeYKA/cEFPd
         WRNWH0sMkvZgVV/6iOmj4Ok9bu3/Jhjwl/JeT4LlvhAzzqUOADiOazz90QUBy9gqDH
         1sdvP9S50lyKHPBERX/df80ZkQU5AFOa63pOmfM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0816/1126] net: hns3: add max order judgement for tx spare buffer
Date:   Tue,  5 Apr 2022 09:26:03 +0200
Message-Id: <20220405070431.514219688@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit a89cbb16995bf15582e0d1bdb922ad1a54a2fa8c ]

Add max order judgement for tx spare buffer to avoid triggering
call trace, print related fail information instead, when user
set tx spare buf size to a large value which causes order
exceeding 10.

Fixes: e445f08af2b1 ("net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver")
Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 49943775713f..214d88cd8dbb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1038,6 +1038,12 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 		return;
 
 	order = get_order(alloc_size);
+	if (order >= MAX_ORDER) {
+		if (net_ratelimit())
+			dev_warn(ring_to_dev(ring), "failed to allocate tx spare buffer, exceed to max order\n");
+		return;
+	}
+
 	tx_spare = devm_kzalloc(ring_to_dev(ring), sizeof(*tx_spare),
 				GFP_KERNEL);
 	if (!tx_spare) {
-- 
2.34.1



