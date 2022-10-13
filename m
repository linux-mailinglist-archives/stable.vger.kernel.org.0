Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E035FD0CE
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiJMAaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbiJMA1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:27:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F51C7B1D0;
        Wed, 12 Oct 2022 17:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59474B81CFA;
        Thu, 13 Oct 2022 00:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51630C43470;
        Thu, 13 Oct 2022 00:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620657;
        bh=y1DBNfu6J+1iXQV3cyheZ8RvEKrcWUOykKgA/HCuzNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g51v7Vzpss9kAbFj+WE9oD2u57sDyfeJmockRigBNWRCaETFbZQJEzXcL8pdKH3zq
         t5EcI8RQSOAsHBb1Qxuh2O7aXA1NAzjf3YHoVlrockhsUPv7myZ0rtbW62rlMlYh2o
         bdmjoXswhmRBZxU2Jb5jIIQ4iYhcFs/1eTkrolmUbgj+ayKUJWaHAGMwdCk88pMJTx
         MAYSrW7roVRRs7vJHazo5kn5/NMCSLaUsEKVFdkAW/nCFup3GiA/TCSXzJ3/Ou7znL
         0q5ces0DP1UJZCfLGZ/6txMxZpCbbvukjWjq5qKBwSDVLfKId9b6bj1oeVxxQi768T
         tSURBKcTWUZUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 17/33] soundwire: intel: fix error handling on dai registration issues
Date:   Wed, 12 Oct 2022 20:23:16 -0400
Message-Id: <20221013002334.1894749-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002334.1894749-1-sashal@kernel.org>
References: <20221013002334.1894749-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit c6867cda906aadbce5e71efde9c78a26108b2bad ]

The call to intel_register_dai() may fail because of memory allocation
issues or problems reported by the ASoC core. In all cases, when a
error is thrown the component is not registered, it's invalid to
unregister it.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220919175721.354679-2-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 824d9f900aca..942d2fe13218 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1470,7 +1470,6 @@ int intel_master_startup(struct platform_device *pdev)
 	ret = intel_register_dai(sdw);
 	if (ret) {
 		dev_err(dev, "DAI registration failed: %d\n", ret);
-		snd_soc_unregister_component(dev);
 		goto err_interrupt;
 	}
 
-- 
2.35.1

