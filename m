Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29B6540BEC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351754AbiFGScm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351759AbiFGSaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:30:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9894B14479F;
        Tue,  7 Jun 2022 10:55:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32C84617A6;
        Tue,  7 Jun 2022 17:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3720AC385A5;
        Tue,  7 Jun 2022 17:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624543;
        bh=HfeXI4PtLGJsrGQJTZotp4cV6+7UV/Hjb/HFqFPhRFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5MCvdkAOx98zhwAgznCWzZdhBOt8t8tUUrAiiOdXN81RiqgR9+FsAwD4eYuxfpce
         vyd1aKBHuZ/Zy71f4m2hZpftl7wr8jaw7jtEeA51FdXLskFjlkJX5EfVm/DgJE3sYH
         avB6nRaBi35ap0JX7O1NB+kKozLiytgk3aen4abo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 366/667] hv_netvsc: Fix potential dereference of NULL pointer
Date:   Tue,  7 Jun 2022 19:00:31 +0200
Message-Id: <20220607164945.729356032@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongzhi Liu <lyz_cs@pku.edu.cn>

[ Upstream commit eb4c0788964730d12e8dd520bd8f5217ca48321c ]

The return value of netvsc_devinfo_get()
needs to be checked to avoid use of NULL
pointer in case of an allocation failure.

Fixes: 0efeea5fb153 ("hv_netvsc: Add the support of hibernation")
Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/1652962188-129281-1-git-send-email-lyz_cs@pku.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index bdfcf75f0827..ae4577731e3e 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2665,7 +2665,10 @@ static int netvsc_suspend(struct hv_device *dev)
 
 	/* Save the current config info */
 	ndev_ctx->saved_netvsc_dev_info = netvsc_devinfo_get(nvdev);
-
+	if (!ndev_ctx->saved_netvsc_dev_info) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = netvsc_detach(net, nvdev);
 out:
 	rtnl_unlock();
-- 
2.35.1



