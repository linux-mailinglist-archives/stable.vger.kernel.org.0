Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7960E5941E1
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiHOU45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347032AbiHOU4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABB02D1D2;
        Mon, 15 Aug 2022 12:12:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC65760BDE;
        Mon, 15 Aug 2022 19:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CD7C433C1;
        Mon, 15 Aug 2022 19:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590721;
        bh=waPJhJ6SojFPzfGmvO2QfFFRmbu4h7chPRsAD9faz1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j27v1TT15eWZB+430UZS3ddchi/QsUD5HlpUMtQ68pKv+Hrz9q8IqOc4M4PqBvKFo
         t4uTRX37wCfN80FIZso3n3xavpniY9YV6BBQv5BysH+RzVhCjTvbhBCC3zVGCoNtGL
         y9rXj3nOeyjkyahDA89rc7FOHx1vYrtaJe56miCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0349/1095] media: tw686x: Register the irq at the end of probe
Date:   Mon, 15 Aug 2022 19:55:48 +0200
Message-Id: <20220815180444.211191813@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit fb730334e0f759d00f72168fbc555e5a95e35210 ]

We got the following warning when booting the kernel:

[    3.243674] INFO: trying to register non-static key.
[    3.243922] The code is fine but needs lockdep annotation, or maybe
[    3.244230] you didn't initialize this object before use?
[    3.245642] Call Trace:
[    3.247836]  lock_acquire+0xff/0x2d0
[    3.248727]  tw686x_audio_irq+0x1a5/0xcc0 [tw686x]
[    3.249211]  tw686x_irq+0x1f9/0x480 [tw686x]

The lock 'vc->qlock' will be initialized in tw686x_video_init(), but the
driver registers the irq before calling the tw686x_video_init(), and we
got the warning.

Fix this by registering the irq at the end of probe

Fixes: 704a84ccdbf1 ("[media] media: Support Intersil/Techwell TW686x-based video capture cards")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw686x/tw686x-core.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index 6676e069b515..384d38754a4b 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -315,13 +315,6 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 
 	spin_lock_init(&dev->lock);
 
-	err = request_irq(pci_dev->irq, tw686x_irq, IRQF_SHARED,
-			  dev->name, dev);
-	if (err < 0) {
-		dev_err(&pci_dev->dev, "unable to request interrupt\n");
-		goto iounmap;
-	}
-
 	timer_setup(&dev->dma_delay_timer, tw686x_dma_delay, 0);
 
 	/*
@@ -333,18 +326,23 @@ static int tw686x_probe(struct pci_dev *pci_dev,
 	err = tw686x_video_init(dev);
 	if (err) {
 		dev_err(&pci_dev->dev, "can't register video\n");
-		goto free_irq;
+		goto iounmap;
 	}
 
 	err = tw686x_audio_init(dev);
 	if (err)
 		dev_warn(&pci_dev->dev, "can't register audio\n");
 
+	err = request_irq(pci_dev->irq, tw686x_irq, IRQF_SHARED,
+			  dev->name, dev);
+	if (err < 0) {
+		dev_err(&pci_dev->dev, "unable to request interrupt\n");
+		goto iounmap;
+	}
+
 	pci_set_drvdata(pci_dev, dev);
 	return 0;
 
-free_irq:
-	free_irq(pci_dev->irq, dev);
 iounmap:
 	pci_iounmap(pci_dev, dev->mmio);
 free_region:
-- 
2.35.1



