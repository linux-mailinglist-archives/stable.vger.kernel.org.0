Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0062060861F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiJVHpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiJVHoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:44:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEAB65002;
        Sat, 22 Oct 2022 00:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E125460ADB;
        Sat, 22 Oct 2022 07:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0183EC433D6;
        Sat, 22 Oct 2022 07:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424294;
        bh=mTM8XwlixReFBR2M/bAy6NtBfzbCLFwzZaBA3O/Amjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OB2p/japObCqWth+VM4eOx89oQx7r7fc9ZTSADbkXdvCND7VUjWxcJKA8zsuUeYEK
         J1vxu2xcsYru2Ww1QEs4quYOj9Hx0aaUGOxcwDqC9fpsvRjXkKrZ6iBT7rqSefTFWL
         AajHqapvIA+hYRjgXL2ogxhbFBZemrjU3vuIugzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.19 065/717] dmaengine: qcom-adm: fix wrong sizeof config in slave_config
Date:   Sat, 22 Oct 2022 09:19:04 +0200
Message-Id: <20221022072426.574843271@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Marangi <ansuelsmth@gmail.com>

commit 7c8765308371be30f50c1b5b97618b731514b207 upstream.

Fix broken slave_config function that uncorrectly compare the
peripheral_size with the size of the config pointer instead of the size
of the config struct. This cause the crci value to be ignored and cause
a kernel panic on any slave that use adm driver.

To fix this, compare to the size of the struct and NOT the size of the
pointer.

Fixes: 03de6b273805 ("dmaengine: qcom-adm: stop abusing slave_id config")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.17+
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220915204844.3838-1-ansuelsmth@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/qcom/qcom_adm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/qcom/qcom_adm.c b/drivers/dma/qcom/qcom_adm.c
index facdacf8aede..c77d9de853de 100644
--- a/drivers/dma/qcom/qcom_adm.c
+++ b/drivers/dma/qcom/qcom_adm.c
@@ -494,7 +494,7 @@ static int adm_slave_config(struct dma_chan *chan, struct dma_slave_config *cfg)
 
 	spin_lock_irqsave(&achan->vc.lock, flag);
 	memcpy(&achan->slave, cfg, sizeof(struct dma_slave_config));
-	if (cfg->peripheral_size == sizeof(config))
+	if (cfg->peripheral_size == sizeof(*config))
 		achan->crci = config->crci;
 	spin_unlock_irqrestore(&achan->vc.lock, flag);
 
-- 
2.38.0



