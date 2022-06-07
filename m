Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20581541B31
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381282AbiFGVmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381210AbiFGVkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E0B17CC82;
        Tue,  7 Jun 2022 12:05:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A941B823AF;
        Tue,  7 Jun 2022 19:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF3EC385A2;
        Tue,  7 Jun 2022 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628753;
        bh=cHRlMGUzCXKk8F2ryIz/RpSKKPb+sErUHOmEBspnArs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyNz+bNxQRkI5SxwczIPzBW8zkZvn9vqnungUvX1yKJ7Kd6D0Hi86gPtopeyIl7gM
         vR4u2nBkKBZ35QD/DA7LQsQvytZEfPpsccuAw2tUfgkhxbXzvCDXTsv6G35WNJLFIs
         bBM+NRf+wmSHYke0+vqjjOZoynCKLxah0cq/RfBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 442/879] media: st-delta: Fix PM disable depth imbalance in delta_probe
Date:   Tue,  7 Jun 2022 18:59:20 +0200
Message-Id: <20220607165015.701562010@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 94e3dba710fe0afc772172305444250023fc2d30 ]

The pm_runtime_enable will decrease power disable depth.
If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().

Fixes: f386509e4959 ("[media] st-delta: STiH4xx multi-format video decoder v4l2 driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Hugues Fruchet <hugues.fruchet@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/sti/delta/delta-v4l2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/st/sti/delta/delta-v4l2.c b/drivers/media/platform/st/sti/delta/delta-v4l2.c
index c887a31ebb54..420ad4d8df5d 100644
--- a/drivers/media/platform/st/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/st/sti/delta/delta-v4l2.c
@@ -1859,7 +1859,7 @@ static int delta_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(delta->dev, "%s failed to initialize firmware ipc channel\n",
 			DELTA_PREFIX);
-		goto err;
+		goto err_pm_disable;
 	}
 
 	/* register all available decoders */
@@ -1873,7 +1873,7 @@ static int delta_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(delta->dev, "%s failed to register V4L2 device\n",
 			DELTA_PREFIX);
-		goto err;
+		goto err_pm_disable;
 	}
 
 	delta->work_queue = create_workqueue(DELTA_NAME);
@@ -1898,6 +1898,8 @@ static int delta_probe(struct platform_device *pdev)
 	destroy_workqueue(delta->work_queue);
 err_v4l2:
 	v4l2_device_unregister(&delta->v4l2_dev);
+err_pm_disable:
+	pm_runtime_disable(dev);
 err:
 	return ret;
 }
-- 
2.35.1



