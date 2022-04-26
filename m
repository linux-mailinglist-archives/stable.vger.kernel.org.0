Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B8250F577
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345455AbiDZIl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345456AbiDZIlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:41:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB3D157DE4;
        Tue, 26 Apr 2022 01:33:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFAE6B81CAF;
        Tue, 26 Apr 2022 08:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42721C385A4;
        Tue, 26 Apr 2022 08:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961977;
        bh=XC/PxJ890NE8IKU5ycw5MBJnxf3y3mMFkwqlK2hnpFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cL4mWgRStF5NsVgwdFFOqOKA7Gk+mDtduePrqWoeDOZefJ30rV3GSXF7DfGGOj6Ww
         /I/SjtwxUiEJhwHblEL4aJZS3ebJfAiXZZqRv0u25gsNMG1vPGuastlMAGXQY7lKvv
         4DUaqfyWsQcfGJzIIezlZSEPOqU0PBIt8utDhKSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernice Zhang <bernice.zhang@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/86] dmaengine: idxd: add RO check for wq max_transfer_size write
Date:   Tue, 26 Apr 2022 10:20:58 +0200
Message-Id: <20220426081742.078041062@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
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

[ Upstream commit 505a2d1032ae656b0a8c736be110255503941cde ]

Block wq_max_transfer_size_store() when the device is configured as
read-only and not configurable.

Fixes: d7aad5550eca ("dmaengine: idxd: add support for configurable max wq xfer size")
Reported-by: Bernice Zhang <bernice.zhang@intel.com>
Tested-by: Bernice Zhang <bernice.zhang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/164971488154.2200913.10706665404118545941.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 5bf4b4be64e4..51af0dfc3c63 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1098,6 +1098,9 @@ static ssize_t wq_max_transfer_size_store(struct device *dev, struct device_attr
 	u64 xfer_size;
 	int rc;
 
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return -EPERM;
+
 	if (wq->state != IDXD_WQ_DISABLED)
 		return -EPERM;
 
-- 
2.35.1



