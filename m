Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECD96AF3F6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbjCGTMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbjCGTLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:11:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C582684
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:55:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77369B819DB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48ECC4339B;
        Tue,  7 Mar 2023 18:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215307;
        bh=H78v4yoDsXx60NrZH61rRRVX438mKYVnaUKsRmQUQtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQ3YTaVr5WITQJI9LDQn/wSxzb7t+ChRrVodsOqX2sQxb8x9vEZGNAvdZQ1PVCqGq
         +Dzz51HML60Uign9HZBVAnplIW6JjJVf67G8RC7DE83Q5rztwJbckGUUgUiHFcv65v
         i33KxivVQb1t/BHwpFa04IUziHYaxnkW9sS7Do2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 191/567] drm/msm/gem: Add check for kmalloc
Date:   Tue,  7 Mar 2023 17:58:47 +0100
Message-Id: <20230307165914.224420105@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit d839f0811a31322c087a859c2b181e2383daa7be ]

Add the check for the return value of kmalloc in order to avoid
NULL pointer dereference in copy_from_user.

Fixes: 20224d715a88 ("drm/msm/submit: Move copy_from_user ahead of locking bos")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/514678/
Link: https://lore.kernel.org/r/20221212091117.43511-1-jiasheng@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 1f74bab9e231a..83e6ccad77286 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -220,6 +220,10 @@ static int submit_lookup_cmds(struct msm_gem_submit *submit,
 			goto out;
 		}
 		submit->cmd[i].relocs = kmalloc(sz, GFP_KERNEL);
+		if (!submit->cmd[i].relocs) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		ret = copy_from_user(submit->cmd[i].relocs, userptr, sz);
 		if (ret) {
 			ret = -EFAULT;
-- 
2.39.2



