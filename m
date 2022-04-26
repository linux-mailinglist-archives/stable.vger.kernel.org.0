Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3DB50F8AA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiDZJGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347431AbiDZJFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:05:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54AA12010E;
        Tue, 26 Apr 2022 01:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FEB16133B;
        Tue, 26 Apr 2022 08:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533DEC385AE;
        Tue, 26 Apr 2022 08:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962680;
        bh=bOp/BP4lyuCh0nGRQPZAmPuB9T8MC+2Xng4CvR1ltGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RvpJ2uZcxDfNjBWXlg0rNrPVOOAdV/uPEE8lXYLAw5OF2s0n3NxrdngjSvfbL5iB+
         /l3cIVGDPmAEtPiP8t5JKpPs/LBLTzxy3okArkj/jBrN3f9yOibkgPW/xyy6tA5qGu
         obxb/lrobmNeWWTz2Ss79aeIrUEe1sgnOlVUkXco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Zhu <tony.zhu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 052/146] dmaengine: idxd: skip clearing device context when device is read-only
Date:   Tue, 26 Apr 2022 10:20:47 +0200
Message-Id: <20220426081751.532726298@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
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

[ Upstream commit 1cd8e751d96c43ece3f6842ac2244a37d9332c3a ]

If the device shows up as read-only configuration, skip the clearing of the
state as the context must be preserved for device re-enable after being
disabled.

Fixes: 0dcfe41e9a4c ("dmanegine: idxd: cleanup all device related bits after disabling device")
Reported-by: Tony Zhu <tony.zhu@intel.com>
Tested-by: Tony Zhu <tony.zhu@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/164971479479.2200566.13980022473526292759.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 5a0535a0f850..f652da6ab47d 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -708,6 +708,9 @@ static void idxd_device_wqs_clear_state(struct idxd_device *idxd)
 
 void idxd_device_clear_state(struct idxd_device *idxd)
 {
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return;
+
 	idxd_groups_clear_state(idxd);
 	idxd_engines_clear_state(idxd);
 	idxd_device_wqs_clear_state(idxd);
-- 
2.35.1



