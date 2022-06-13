Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E545494FE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356937AbiFMLxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356972AbiFMLw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:52:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC6E21259;
        Mon, 13 Jun 2022 03:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2115661257;
        Mon, 13 Jun 2022 10:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284DDC34114;
        Mon, 13 Jun 2022 10:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117722;
        bh=+GwQ78k6PfWm/H5SjSG6dts4NNQtZaWGVz0m9qkt2Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gtuIC9aaRaIWrsXGu/z3Lm5yIaP6xTEOaYEKqDRm5W+TNff6mVnTcH17D0wJQ7tT
         e6Ct4NQFfOYNs97WqSvYll6nFCyUgCMHNtWwqBZtkZ17XFQoE0zxAjMexh+0G7ml8j
         MFEeomuTqnF1HT9fOqoMCixNyd91N49G47FwK3bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Hugues Fruchet <hugues.fruchet@foss.st.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 096/287] media: st-delta: Fix PM disable depth imbalance in delta_probe
Date:   Mon, 13 Jun 2022 12:08:40 +0200
Message-Id: <20220613094926.789410340@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
 drivers/media/platform/sti/delta/delta-v4l2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index 53dc6da2b09e..eb5e8867967e 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -1862,7 +1862,7 @@ static int delta_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(delta->dev, "%s failed to initialize firmware ipc channel\n",
 			DELTA_PREFIX);
-		goto err;
+		goto err_pm_disable;
 	}
 
 	/* register all available decoders */
@@ -1876,7 +1876,7 @@ static int delta_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(delta->dev, "%s failed to register V4L2 device\n",
 			DELTA_PREFIX);
-		goto err;
+		goto err_pm_disable;
 	}
 
 	delta->work_queue = create_workqueue(DELTA_NAME);
@@ -1901,6 +1901,8 @@ static int delta_probe(struct platform_device *pdev)
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



