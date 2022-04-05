Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227524F38C9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377193AbiDEL2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349728AbiDEJvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:51:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3587E120BB;
        Tue,  5 Apr 2022 02:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDC32B81B76;
        Tue,  5 Apr 2022 09:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0E8C385A1;
        Tue,  5 Apr 2022 09:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152147;
        bh=96OvkCivmFseK7bEObf6KFbVIP+u0ZzPNMVNOVGBOvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mR6S41XNt8kKxjt5e4VUEyWzJLVMvS9pKlP9i9bH2wvcfIgPEV4Ek/jDm4Ek0XiWI
         aPpFv8royFTK//f2LmzJbT10A3E4Nr5GGFbSMRnRmAzchezLP+vAE4Xt8iBZvsfvQn
         Xv0QyOgsMBOcuyqbF0Kbu751B02mNYsCRpl4zLwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 673/913] net: sparx5: switchdev: fix possible NULL pointer dereference
Date:   Tue,  5 Apr 2022 09:28:55 +0200
Message-Id: <20220405070400.009412195@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 0906f3a3df07835e37077d8971aac65347f2ed57 ]

As the possible failure of the allocation, devm_kzalloc() may return NULL
pointer.
Therefore, it should be better to check the 'db' in order to prevent
the dereference of NULL pointer.

Fixes: 10615907e9b51 ("net: sparx5: switchdev: adding frame DMA functionality")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index 7436f62fa152..174ad95e746a 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -420,6 +420,8 @@ static int sparx5_fdma_tx_alloc(struct sparx5 *sparx5)
 			db_hw->dataptr = phys;
 			db_hw->status = 0;
 			db = devm_kzalloc(sparx5->dev, sizeof(*db), GFP_KERNEL);
+			if (!db)
+				return -ENOMEM;
 			db->cpu_addr = cpu_addr;
 			list_add_tail(&db->list, &tx->db_list);
 		}
-- 
2.34.1



