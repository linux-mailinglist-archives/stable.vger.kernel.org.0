Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6475F6B43CC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjCJOSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjCJORv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:17:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EC311F6B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:16:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9249BB8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F31C433D2;
        Fri, 10 Mar 2023 14:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457795;
        bh=f0nVKhNDPzhfCKNRFI3VygVHIA+Vz8P9OjPnVWdO9iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLTXkCgD0zTV5zFy8zFWexYBP0WGMnbT4kh5HpQx41j/7qlhKrvsZGK2k67q7FJ+0
         GIHO9y4S3x2yhiF/3+mV6O9KZCG5T7028O3BHo74N8wkjQx19gg/1YUkjf2zoP0PGu
         uDQb1acxOD4dRpol93LMt88TvyEutVN75Yu5+tK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Simon Horman <simon.horman@corigine.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/252] wifi: rsi: Fix memory leak in rsi_coex_attach()
Date:   Fri, 10 Mar 2023 14:36:30 +0100
Message-Id: <20230310133719.436885955@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index c8ba148f8c6cf..acf4d8cb4b479 100644
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



