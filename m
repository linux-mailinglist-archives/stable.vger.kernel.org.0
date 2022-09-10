Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CBA5B49D7
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiIJVYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiIJVX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:23:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0181011;
        Sat, 10 Sep 2022 14:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EF2660EC8;
        Sat, 10 Sep 2022 21:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D835AC4347C;
        Sat, 10 Sep 2022 21:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844717;
        bh=+gxl2HYx2Ui/E2dJ0+8vkM5bnjpZDmbWrSJmuo+oIdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEvfOXeW+VVH075+kaUf9PReNMhKhfpgTKgaCNba1kkCCIL+u+ucuHHKaq6SB4t1C
         ZuQAzI/wX6zk1KrIyqc/2WaSnAxDz+0jTKhT+FeIRoNl0dGTTGrcbi9wQDTt0RotAO
         aItMWEHabxn8CTfz9ZzAhlF5al55lb4sWyn8NPXiNxnKYkcFqw9tmA7Mmd099jGSXA
         T/TyZHAipdr7D3aifGeSd4AFHp5ypbw8/LEiwkOl1nwLSnzdX96npYB702wYvjm4mp
         GPaV5k6fHTFVm8y+QHeH39wXefp5A2coAxJ05A8YwlPXb/I++paWC7gIeTBQOUmC0p
         ZwfiazON2hfAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        quic_abhinavk@quicinc.com, dmitry.baryshkov@linaro.org,
        airlied@linux.ie, daniel@ffwll.ch, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 02/14] drm/msm/rd: Fix FIFO-full deadlock
Date:   Sat, 10 Sep 2022 17:18:20 -0400
Message-Id: <20220910211832.70579-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211832.70579-1-sashal@kernel.org>
References: <20220910211832.70579-1-sashal@kernel.org>
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
index fea30e7aa9e83..084b6ae2a4761 100644
--- a/drivers/gpu/drm/msm/msm_rd.c
+++ b/drivers/gpu/drm/msm/msm_rd.c
@@ -191,6 +191,9 @@ static int rd_open(struct inode *inode, struct file *file)
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

