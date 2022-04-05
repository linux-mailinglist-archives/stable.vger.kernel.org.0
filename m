Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BE34F3860
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376387AbiDELVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349420AbiDEJtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1581EAE0;
        Tue,  5 Apr 2022 02:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB6861368;
        Tue,  5 Apr 2022 09:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49882C385A2;
        Tue,  5 Apr 2022 09:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151917;
        bh=qSaTGiySKFFr1e9/bvAwdPYGh0SluH4gytxj95+oIgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nSh0bQ6NThfBZKRfitK4wpGPJeRtfe4vkmjCaftcYM2y/KL7is/AoP2QhnEGgRb9R
         EQBvE+yKi3yIu8A4nxeCnflA8kRcJX6N1wz0rh/QKAJPfMWQbCKUx36gmaEDefC9rl
         NYpRca7tG7yIY32TGa+eZca0CKn9zpxzDac0+srk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 589/913] dmaengine: idxd: check GENCAP config support for gencfg register
Date:   Tue,  5 Apr 2022 09:27:31 +0200
Message-Id: <20220405070357.499184808@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 79c4c3db7d86b9bec94562275efc82e58f3d0132 ]

DSA spec 1.2 has moved the GENCFG register under the GENCAP configuration
support with respect to writability. Add check in driver before writing to
GENCFG register.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163406171896.1303830.11217958011385656998.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index b468ca36d3a0..3cda1c5faf3c 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -801,7 +801,7 @@ static int idxd_groups_config_write(struct idxd_device *idxd)
 	struct device *dev = &idxd->pdev->dev;
 
 	/* Setup bandwidth token limit */
-	if (idxd->token_limit) {
+	if (idxd->hw.gen_cap.config_en && idxd->token_limit) {
 		reg.bits = ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET);
 		reg.token_limit = idxd->token_limit;
 		iowrite32(reg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);
-- 
2.34.1



