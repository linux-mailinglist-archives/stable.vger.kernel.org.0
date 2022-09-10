Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859F25B4A01
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiIJVZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiIJVYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:24:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFD14E863;
        Sat, 10 Sep 2022 14:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36A52B80959;
        Sat, 10 Sep 2022 21:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1728C433D7;
        Sat, 10 Sep 2022 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844764;
        bh=ctclM3JBJrkIeibqeVrapq86rbugeEMyPRRRmJnwhBU=;
        h=From:To:Cc:Subject:Date:From;
        b=nxNAlAKioFR1/sFRXmsZ9XigiQuoNa+e12xWF7oae2aJC2CXp5WIQ6bYOV397IU9b
         FzVa1Te+6c8j80ZytxhvdHN53FoFol98o7Aoyeqj6FZHnxcQ+Mn/zBxbl5evwn1zlJ
         G/Qbl13SkO44mv2mWbiy58VjvrWsxkhUCV36e+OJJTWEFqUfRKgF3mzh9MvpRr1g/6
         oGUb12ctypRA3rH23BKv9kef1uficGGqvcv//Y4fqJuXCsV08fa62uq0FPTAd5bVvV
         koJdBly/70IZb+qrBgJdDL9b+aT7+7OzYLXBH9rSu6HpAafKbi42Mxm1Uj0XUPYHPy
         wkPlcWxhWRogQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        airlied@linux.ie, daniel@ffwll.ch, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 1/8] drm/msm/rd: Fix FIFO-full deadlock
Date:   Sat, 10 Sep 2022 17:19:14 -0400
Message-Id: <20220910211921.70891-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 174974d8463b77c2b4065e98513adb204e64de7d ]

If the previous thing cat'ing $debugfs/rd left the FIFO full, then
subsequent open could deadlock in rd_write() (because open is blocked,
not giving a chance for read() to consume any data in the FIFO).  Also
it is generally a good idea to clear out old data from the FIFO.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/496706/
Link: https://lore.kernel.org/r/20220807160901.2353471-2-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_rd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_rd.c b/drivers/gpu/drm/msm/msm_rd.c
index d4cc5ceb22d01..bb65aab49c214 100644
--- a/drivers/gpu/drm/msm/msm_rd.c
+++ b/drivers/gpu/drm/msm/msm_rd.c
@@ -199,6 +199,9 @@ static int rd_open(struct inode *inode, struct file *file)
 	file->private_data = rd;
 	rd->open = true;
 
+	/* Reset fifo to clear any previously unread data: */
+	rd->fifo.head = rd->fifo.tail = 0;
+
 	/* the parsing tools need to know gpu-id to know which
 	 * register database to load.
 	 */
-- 
2.35.1

