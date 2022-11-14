Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C75A62803A
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbiKNNEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237668AbiKNNEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A153A29838
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 552E4B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C7DC433D6;
        Mon, 14 Nov 2022 13:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431047;
        bh=6Baoi8UT51aqyaL2D1/eq7a+VBF9R5WvkxRsno5KC0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Doll/MQWYaW8WU6GC7b2cmVmHJ2jPyhfCuV4rrsfvHuHQl9f1ix7KFsZ6alN6hZOh
         ulr7ux/LBdqbpTd5MVFh0k37urp9Fpza+lnfs3HJ2qOLQQx5xBcdpbBhOH1r5fYNQ1
         gWB65KKu+GQSRUro/nUX1Ol/Q6MNdYu23RIGAaQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 081/190] net: marvell: prestera: fix memory leak in prestera_rxtx_switch_init()
Date:   Mon, 14 Nov 2022 13:45:05 +0100
Message-Id: <20221114124502.211922155@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index dc3e3ddc60bf..faa5109a09d7 100644
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



