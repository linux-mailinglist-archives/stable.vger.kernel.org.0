Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D063587B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbiKWJ6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbiKWJ5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:57:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA2A98245
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A7CEB81EEB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D92C433D7;
        Wed, 23 Nov 2022 09:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197128;
        bh=3T9A7XV3dvrq5RgeaJKwXAXtgDdUaXw2bIuGUfOlCig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMFIpO5XrKQbaBEzrU4CZULgy669tZbQVo92Q6bNtxRrGWK2GLYG+G9upImLjvP3r
         /W8GY8H2u8hciAV2ydCzaFI1SpLdVDNorkWWAb4ghTLlgCm1Sehh4Jx4tJE4sxT2uT
         WAlcwX9hsvOMGmym8Oe3vKzfAE/M8Hk2BZU/DmFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jie Wang <wangjie125@huawei.com>,
        Hao Lan <lanhao@huawei.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 174/314] net: hns3: fix return value check bug of rx copybreak
Date:   Wed, 23 Nov 2022 09:50:19 +0100
Message-Id: <20221123084633.452115664@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 29df7c695ed67a8fa32bb7805bad8fe2a76c1f88 ]

The refactoring of rx copybreak modifies the original return logic, which
will make this feature unavailable. So this patch fixes the return logic of
rx copybreak.

Fixes: e74a726da2c4 ("net: hns3: refactor hns3_nic_reuse_page()")
Fixes: 99f6b5fb5f63 ("net: hns3: use bounce buffer when rx page can not be reused")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 944f36e4d66f..44d4265f109a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3736,8 +3736,8 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 		desc_cb->reuse_flag = 1;
 	} else if (frag_size <= ring->rx_copybreak) {
 		ret = hns3_handle_rx_copybreak(skb, i, ring, pull_len, desc_cb);
-		if (ret)
-			goto out;
+		if (!ret)
+			return;
 	}
 
 out:
-- 
2.35.1



