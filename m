Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1344F3724
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245377AbiDELKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348829AbiDEJsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CFFB3DCE;
        Tue,  5 Apr 2022 02:36:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C837DB81B93;
        Tue,  5 Apr 2022 09:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3138FC385A0;
        Tue,  5 Apr 2022 09:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151388;
        bh=jh9CllG9PsAXX5BVlSm7J62a8oQ3Hy7djmNXGAhkUiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=An+cltzTsqXahPWZFFa8s8E9Qm9kainBAXkVQylCcpvwis2xeXzNLVq0+c9C8r3XA
         ufjuzQ6LDZQ9VTgRzYa8GVGR54QqMhZjAtsUta8WMyj8Ul+MKaR67c7Lb8uOck+7hI
         MXZWWGD93oOV1wrraOCp/0zWpHFWm5eiWBVF6xVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 397/913] ionic: fix type complaint in ionic_dev_cmd_clean()
Date:   Tue,  5 Apr 2022 09:24:19 +0200
Message-Id: <20220405070351.748311758@linuxfoundation.org>
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
index 6f07bf509efe..f4af760cfa73 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -328,10 +328,10 @@ int ionic_adminq_post_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx)
 
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



