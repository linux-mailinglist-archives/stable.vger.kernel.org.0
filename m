Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB886AF321
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjCGTAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCGTAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:00:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8675CAA72D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:47:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57FCA61522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB39C433D2;
        Tue,  7 Mar 2023 18:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214836;
        bh=7VPYRnb5vE2aLXoWpqGSZZdB4gNPvy0oN1oHrm9nH6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+pbHp6kEDR80m57/yq6UAzpNv60l4a17UNxHe50x6RcH3BPeHhR3eBBlJ+pzmrmQ
         AHjwnZmvf5C9mJm9DXdPf+c9KZhDr7Zdd5JKkQKFIX3A2NuR3QP6hTF30XRpWFf3A+
         W1D7/eymrIK4cpx5AsomNufljbri54tKKDMzTJ9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Simon Horman <simon.horman@corigine.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/567] wifi: rsi: Fix memory leak in rsi_coex_attach()
Date:   Tue,  7 Mar 2023 17:56:42 +0100
Message-Id: <20230307165908.748568050@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 956fb851a6e19da5ab491e19c1bc323bb2c2cf6f ]

The coex_cb needs to be freed when rsi_create_kthread() failed in
rsi_coex_attach().

Fixes: 2108df3c4b18 ("rsi: add coex support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221205061441.114632-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_coex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index a0c5d02ae88cf..7395359b43b77 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -160,6 +160,7 @@ int rsi_coex_attach(struct rsi_common *common)
 			       rsi_coex_scheduler_thread,
 			       "Coex-Tx-Thread")) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to init tx thrd\n", __func__);
+		kfree(coex_cb);
 		return -EINVAL;
 	}
 	return 0;
-- 
2.39.2



