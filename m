Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25E0608AA9
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiJVJEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbiJVJDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:03:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39842FACE1;
        Sat, 22 Oct 2022 01:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C781D60B84;
        Sat, 22 Oct 2022 07:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0A2C433D6;
        Sat, 22 Oct 2022 07:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425198;
        bh=WTP5UwOckZbMbSXMx2VCri9AardoaYuqySbMaS2HOr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xByQgtxMxZVMgBztxVoe/uh6UpRusSxqVD+yVNqIDpJEVIsdzHZL6fPGwHqTyW77F
         rEHYD7zmoVXn2gHftouBo7+BdpRhAm27trw3dsHv1df9KyCb0jGdq8buryUhHylGfO
         btxveMjdW8JIBZOpDStj0fjM9M7BnqR3EGQgG1yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 394/717] media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop
Date:   Sat, 22 Oct 2022 09:24:33 +0200
Message-Id: <20221022072515.184860811@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 211f8304fa21aaedc2c247f0c9d6c7f1aaa61ad7 ]

In fimc_is_register_subdevs(), we need to call of_node_put() for
the reference 'i2c_bus' when breaking out of the
for_each_compatible_node() which has increased the refcount.

Fixes: 9a761e436843 ("[media] exynos4-is: Add Exynos4x12 FIMC-IS driver")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/exynos4-is/fimc-is.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/samsung/exynos4-is/fimc-is.c b/drivers/media/platform/samsung/exynos4-is/fimc-is.c
index e3072d69c49f..a7704ff069d6 100644
--- a/drivers/media/platform/samsung/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/samsung/exynos4-is/fimc-is.c
@@ -213,6 +213,7 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 
 			if (ret < 0 || index >= FIMC_IS_SENSORS_NUM) {
 				of_node_put(child);
+				of_node_put(i2c_bus);
 				return ret;
 			}
 			index++;
-- 
2.35.1



