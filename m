Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FF5627F20
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbiKNMzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237526AbiKNMzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:55:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B21C27915
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16C3F61154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D4FC433D6;
        Mon, 14 Nov 2022 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430544;
        bh=+S0RPAf2LPMkvGDklv6G3cvrjnGsmZjcOIYy3Px+yK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uB75+psIw2V3exhDND/NQZO++sLOp1rVefwMjiRCgvrSzEwJdN/8rnJAXHkZZklJh
         ZUaLC9UV+yBzQEZ0oDAKlloV3Wxyaa6QYV0KIHsGGvjEWnSC3iqFYDj191YuayZcw+
         w65E9QepOvcZHqidk7mJAeCJk//uB4+qdxC3B8Ow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/131] net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
Date:   Mon, 14 Nov 2022 13:45:27 +0100
Message-Id: <20221114124451.165823888@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 519b58bbfa825f042fcf80261cc18e1e35f85ffd ]

When prestera_sdma_switch_init() failed, the memory pointed to by
sw->rxtx isn't released. Fix it. Only be compiled, not be tested.

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Vadym Kochan <vadym.kochan@plvision.eu>
Link: https://lore.kernel.org/r/20221108025607.338450-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index 73d2eba5262f..a47aa624f745 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -776,6 +776,7 @@ static netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma,
 int prestera_rxtx_switch_init(struct prestera_switch *sw)
 {
 	struct prestera_rxtx *rxtx;
+	int err;
 
 	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
 	if (!rxtx)
@@ -783,7 +784,11 @@ int prestera_rxtx_switch_init(struct prestera_switch *sw)
 
 	sw->rxtx = rxtx;
 
-	return prestera_sdma_switch_init(sw);
+	err = prestera_sdma_switch_init(sw);
+	if (err)
+		kfree(rxtx);
+
+	return err;
 }
 
 void prestera_rxtx_switch_fini(struct prestera_switch *sw)
-- 
2.35.1



