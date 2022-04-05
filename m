Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682784F27CE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiDEIJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbiDEIBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049A34B431;
        Tue,  5 Apr 2022 00:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95FDB61748;
        Tue,  5 Apr 2022 07:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A484FC340EE;
        Tue,  5 Apr 2022 07:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145586;
        bh=0Dg7CYB7xn8BcJUfpIWrYJsGfvLqYxZJacs/FazW+sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmSjyDYpIm9FnpLHDuLcT72R+wCTSgmoWJpBdq2ljklCh7B7eRXmNk5zclRC05seD
         PADrka+ZqBA92sdzjZ0tKg2lhUCZJX1UQ7vY1uqky5ATmn/OADCuRcVAlFF0t0WT+/
         RcMFzwgiSASvklwbfBQkz0hKS0vqPPslauZhXiK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0456/1126] ionic: fix type complaint in ionic_dev_cmd_clean()
Date:   Tue,  5 Apr 2022 09:20:03 +0200
Message-Id: <20220405070421.009558887@linuxfoundation.org>
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

From: Shannon Nelson <snelson@pensando.io>

[ Upstream commit bc0bf9de6f48268f4ee59e57fb42ac751be3ecda ]

Sparse seems to have gotten a little more picky lately and
we need to revisit this bit of code to make sparse happy.

warning: incorrect type in initializer (different address spaces)
   expected union ionic_dev_cmd_regs *regs
   got union ionic_dev_cmd_regs [noderef] __iomem *dev_cmd_regs
warning: incorrect type in argument 2 (different address spaces)
   expected void [noderef] __iomem *
   got unsigned int *
warning: incorrect type in argument 1 (different address spaces)
   expected void volatile [noderef] __iomem *
   got union ionic_dev_cmd *

Fixes: d701ec326a31 ("ionic: clean up sparse complaints")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 875f4ec42efe..a89ad768e4a0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -370,10 +370,10 @@ int ionic_adminq_post_wait_nomsg(struct ionic_lif *lif, struct ionic_admin_ctx *
 
 static void ionic_dev_cmd_clean(struct ionic *ionic)
 {
-	union __iomem ionic_dev_cmd_regs *regs = ionic->idev.dev_cmd_regs;
+	struct ionic_dev *idev = &ionic->idev;
 
-	iowrite32(0, &regs->doorbell);
-	memset_io(&regs->cmd, 0, sizeof(regs->cmd));
+	iowrite32(0, &idev->dev_cmd_regs->doorbell);
+	memset_io(&idev->dev_cmd_regs->cmd, 0, sizeof(idev->dev_cmd_regs->cmd));
 }
 
 int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
-- 
2.34.1



