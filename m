Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7204F28F5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiDEIYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237643AbiDEISJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588D4B6E48;
        Tue,  5 Apr 2022 01:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEF91B81B92;
        Tue,  5 Apr 2022 08:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DEAC385A0;
        Tue,  5 Apr 2022 08:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146030;
        bh=sEdwyZKytQP93J9LHq4NnHXmmYIPENRb0QN6Cpzyh2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/v6ca9vWi6OABXqPhSNR4k7JqABXdw7LJsggmQfI2n2fWmRzHgVDxxOHj2UQByrL
         Rz0yEYUBrM8QqZf9xOruyw+6XaBO9Ti/2tTTaXoZuHYJg0VRSBp/vgSAgN8WzmMyXk
         KSisvj+wu/rIcGoYOYaZ4aAN+IXc0I2MWJ0dxu1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0617/1126] gpu: host1x: Fix an error handling path in host1x_probe()
Date:   Tue,  5 Apr 2022 09:22:44 +0200
Message-Id: <20220405070425.745515467@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e5d5db1a79a5929b9ced99472f9a748a243d6a69 ]

Add the missing 'host1x_bo_cache_destroy()' call in the error handling
path of the probe, as already done in the remove function.

In order to simplify the error handling, move the 'host1x_bo_cache_init()'
call after all the devm_ function.

Fixes: 1f39b1dfa53c ("drm/tegra: Implement buffer object cache")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 6994f8c0e02e..9605495f001a 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -447,7 +447,6 @@ static int host1x_probe(struct platform_device *pdev)
 	if (syncpt_irq < 0)
 		return syncpt_irq;
 
-	host1x_bo_cache_init(&host->cache);
 	mutex_init(&host->devices_lock);
 	INIT_LIST_HEAD(&host->devices);
 	INIT_LIST_HEAD(&host->list);
@@ -489,10 +488,12 @@ static int host1x_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	host1x_bo_cache_init(&host->cache);
+
 	err = host1x_iommu_init(host);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to setup IOMMU: %d\n", err);
-		return err;
+		goto destroy_cache;
 	}
 
 	err = host1x_channel_list_init(&host->channel_list,
@@ -553,6 +554,8 @@ static int host1x_probe(struct platform_device *pdev)
 	host1x_channel_list_free(&host->channel_list);
 iommu_exit:
 	host1x_iommu_exit(host);
+destroy_cache:
+	host1x_bo_cache_destroy(&host->cache);
 
 	return err;
 }
-- 
2.34.1



