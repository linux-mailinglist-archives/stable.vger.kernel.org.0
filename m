Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8C650F64E
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiDZIzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346911AbiDZIux (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:50:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B501E16FAEE;
        Tue, 26 Apr 2022 01:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EC1160A67;
        Tue, 26 Apr 2022 08:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57732C385B0;
        Tue, 26 Apr 2022 08:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962349;
        bh=qmlk7RokZF/lJHMgXkXxFzwtYZ21SxX7MjgtQRqnqr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2W1HFwTcL3rGskj3pGtryjabPqvF/aVnjBfTpxDZz09hEGTHRbqBL+BQ3sGx/72Do
         ss+lyln0ubeNAwUjIZHK7mkId05Cqbulv2R+u+0BMqb8AvN9TSPvO30DOke0L6kJtf
         eoqlTuNAjhC+LX+wxxvH0J4alu5ILwvl3nbojbaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Lv Ruyi <lv.ruyi@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/124] dpaa_eth: Fix missing of_node_put in dpaa_get_ts_info()
Date:   Tue, 26 Apr 2022 10:21:06 +0200
Message-Id: <20220426081749.149686263@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

[ Upstream commit 1a7eb80d170c28be2928433702256fe2a0bd1e0f ]

Both of of_get_parent() and of_parse_phandle() return node pointer with
refcount incremented, use of_node_put() on it to decrease refcount
when done.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 763d2c7b5fb1..5750f9a56393 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -489,11 +489,15 @@ static int dpaa_get_ts_info(struct net_device *net_dev,
 	info->phc_index = -1;
 
 	fman_node = of_get_parent(mac_node);
-	if (fman_node)
+	if (fman_node) {
 		ptp_node = of_parse_phandle(fman_node, "ptimer-handle", 0);
+		of_node_put(fman_node);
+	}
 
-	if (ptp_node)
+	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
+	}
 
 	if (ptp_dev)
 		ptp = platform_get_drvdata(ptp_dev);
-- 
2.35.1



