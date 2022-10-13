Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A11E5FD071
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiJMA1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiJMAZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:25:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A912C106901;
        Wed, 12 Oct 2022 17:24:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27D94616CC;
        Thu, 13 Oct 2022 00:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0CFC433D7;
        Thu, 13 Oct 2022 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620392;
        bh=W+yRkhVnvuDn6P4WhQFBQd4IV6hCCgQ3Bo73XUYdjqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cm6IxOovSbLnjvij17XV2xFpWH0e6PXxqu9Ty4k9/ZJACk/6ZykxguiRec4qqlRJ4
         KEK0vKAM2UpbNnTd/CkgBE7Z/Gs4QQmqH2d7eKFPW7r9ONizixAt7/XDz/Jy60hnAY
         Pgh1l5UPPtoBvTJX/NPY9Rpw9S6pJytWugJBbAFU8PI9LfzvwJ0LvNFSztZnxy1sY2
         L7oNS/yUfjl7aj/fUtRckmvbEtch0vA2OOnSgMowC95H2H5mlRUDdWUtycjIEiqFag
         Zn06Zs8jyQ9bHTbA003KH8w/ffUoRHz2ErdWsTQHMq983Ot3zuv16b52kM1J5OJkhB
         57jgIMBOS0XQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.19 28/63] soundwire: intel: fix error handling on dai registration issues
Date:   Wed, 12 Oct 2022 20:18:02 -0400
Message-Id: <20221013001842.1893243-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013001842.1893243-1-sashal@kernel.org>
References: <20221013001842.1893243-1-sashal@kernel.org>
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
index 505c5ef061e3..865d91ecb862 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1401,7 +1401,6 @@ int intel_link_startup(struct auxiliary_device *auxdev)
 	ret = intel_register_dai(sdw);
 	if (ret) {
 		dev_err(dev, "DAI registration failed: %d\n", ret);
-		snd_soc_unregister_component(dev);
 		goto err_interrupt;
 	}
 
-- 
2.35.1

