Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9B7604505
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiJSMTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbiJSMTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:19:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60BE1D67C;
        Wed, 19 Oct 2022 04:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A516B82312;
        Wed, 19 Oct 2022 08:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBEDC433D6;
        Wed, 19 Oct 2022 08:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169136;
        bh=jg4ohn3/1jVyZ03iJkHbsTt2BOLdGqdLWdeUndyq9E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PijNbsh6PjC6zD3jcv433tEkVqMZfLab3Fs2Azw8esvOkVJIvwZb82ByyIvVvxn+I
         TD87vMS0Y1JItZzxq4VkCXP2V5xelM0j3bIi0q9/KNLrlVSsrVUx8pdMC0waxLz7OU
         iFdoNeeSxeE/Dc9TDm3pLs2hpRZyDmsS6j03+IJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Samuel Holland <samuel@sholland.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.0 170/862] media: cedrus: Set the platform driver data earlier
Date:   Wed, 19 Oct 2022 10:24:17 +0200
Message-Id: <20221019083257.464093108@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 708938f8495147fe2e77a9a3e1015d8e6899323e upstream.

The cedrus_hw_resume() crashes with NULL deference on driver probe if
runtime PM is disabled because it uses platform data that hasn't been
set up yet. Fix this by setting the platform data earlier during probe.

Cc: stable@vger.kernel.org
Fixes: 50e761516f2b (media: platform: Add Cedrus VPU decoder driver)
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -448,6 +448,8 @@ static int cedrus_probe(struct platform_
 	if (!dev)
 		return -ENOMEM;
 
+	platform_set_drvdata(pdev, dev);
+
 	dev->vfd = cedrus_video_device;
 	dev->dev = &pdev->dev;
 	dev->pdev = pdev;
@@ -521,8 +523,6 @@ static int cedrus_probe(struct platform_
 		goto err_m2m_mc;
 	}
 
-	platform_set_drvdata(pdev, dev);
-
 	return 0;
 
 err_m2m_mc:


