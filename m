Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7267550F5DA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbiDZIv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346503AbiDZIuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:50:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C68139771;
        Tue, 26 Apr 2022 01:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F249B81D18;
        Tue, 26 Apr 2022 08:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FD5C385A0;
        Tue, 26 Apr 2022 08:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962291;
        bh=BUttM4dMS6czkW5l9y8+dh5aeIjVbPYhm+0ip0mHMOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaG4ZsOFnn+EQgBT6elZSNtg/9aC4vv0tqM+XXMoiVkoLk3RyALsSVTH3v6Ash4Wm
         AzLtKTNBtSLMOA6r14UAhpSU+PZ6mFjkPVX7Wjht1rUM0sfIH5YwCfXouA/GLt6W3+
         gfRZ2letTKNXPaCkY1J4HTLJIGpQxzNa4dcRRUiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernice Zhang <bernice.zhang@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/124] dmaengine: idxd: add RO check for wq max_batch_size write
Date:   Tue, 26 Apr 2022 10:20:49 +0200
Message-Id: <20220426081748.667036725@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 66903461ffed0b66fc3e0200082d4e09365aacdc ]

Block wq_max_batch_size_store() when the device is configured as read-only
and not configurable.

Fixes: e7184b159dd3 ("dmaengine: idxd: add support for configurable max wq batch size")
Reported-by: Bernice Zhang <bernice.zhang@intel.com>
Tested-by: Bernice Zhang <bernice.zhang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/164971493551.2201159.1942042593642155209.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 999ce13a93ad..f7ab5c077a2b 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -876,6 +876,9 @@ static ssize_t wq_max_batch_size_store(struct device *dev, struct device_attribu
 	u64 batch_size;
 	int rc;
 
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return -EPERM;
+
 	if (wq->state != IDXD_WQ_DISABLED)
 		return -EPERM;
 
-- 
2.35.1



