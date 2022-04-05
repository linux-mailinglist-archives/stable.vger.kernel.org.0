Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424134F3BD5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354782AbiDEMCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358024AbiDEK1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2D8689A2;
        Tue,  5 Apr 2022 03:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0223B81C88;
        Tue,  5 Apr 2022 10:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD05C385A1;
        Tue,  5 Apr 2022 10:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153584;
        bh=ZIOmT5Slk2G++mQSpDt+ZoovSPZ+Y40/5YBoKMtkjkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbNbov6nPpmtVU4GakahqqLNM2fa3+AOqQ6icYx7FBl9RMQYm9YIrKaEmoU9gwiwB
         Aw7a98Qw+Y3WY+L87a0+0xdhkEm8HuP24f5+oQ5+s7HqQA1I4lIqcL6hHKhh6c1kkm
         0iFFQbAjgQnqx0FaN6QgkgjhqHnDX/gnu/Cjm5I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 273/599] ionic: fix type complaint in ionic_dev_cmd_clean()
Date:   Tue,  5 Apr 2022 09:29:27 +0200
Message-Id: <20220405070306.962301309@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index d355676f6c16..e14869a2e24a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -311,10 +311,10 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 
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



