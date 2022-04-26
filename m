Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7783E50F5C1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiDZIwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346465AbiDZIuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:50:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EA21399B9;
        Tue, 26 Apr 2022 01:38:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53B1CB81CF2;
        Tue, 26 Apr 2022 08:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7EFC385A0;
        Tue, 26 Apr 2022 08:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962294;
        bh=0AMYWBbfpUL//+F2tIsTAni2SaYlp5EIBR+OQERkZTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0Al9Dmb1JcxCykmVLVsXCNYi7uCNKeUObwyMSjH9ujvdsif5qDuXwGJtq55HaS39
         o/lScZUQkamczqXCEnNYip1FS4Ram/YCRxMUentrLNzdJv2W5hxnzoUsC98XQox79D
         YXzfO2NhvuqsK+E4cbr0G5aXeZ0ZF4EhWJEX1DWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernice Zhang <bernice.zhang@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/124] dmaengine: idxd: add RO check for wq max_transfer_size write
Date:   Tue, 26 Apr 2022 10:20:50 +0200
Message-Id: <20220426081748.695278023@linuxfoundation.org>
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
index f7ab5c077a2b..33d94c67fedb 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -842,6 +842,9 @@ static ssize_t wq_max_transfer_size_store(struct device *dev, struct device_attr
 	u64 xfer_size;
 	int rc;
 
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return -EPERM;
+
 	if (wq->state != IDXD_WQ_DISABLED)
 		return -EPERM;
 
-- 
2.35.1



