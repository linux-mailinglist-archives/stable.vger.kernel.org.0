Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE7260A96C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiJXNUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiJXNTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:19:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5E484E6E;
        Mon, 24 Oct 2022 05:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8798612E7;
        Mon, 24 Oct 2022 12:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18C4C433C1;
        Mon, 24 Oct 2022 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614295;
        bh=xnezvrP/hKkBp2MwA9j44y/EoiumJaeOfO3sR5XKtVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XclhKWIjRKZHnMWNr9aBKqgtaRtmqiwD1ygh7gUYZj/hnjoasGg5XH9JFwWaEkhyO
         H7v7HPP/ZTjqEO80D/EIb+/MCyaE+IYmUI29IoIy9duasbNaF04Vdhxr0vwH0tUPYQ
         Zcs+cpv9dx5LQ02AjIONKoVI5arK2eav87cvS8Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/390] media: exynos4-is: fimc-is: Add of_node_put() when breaking out of loop
Date:   Mon, 24 Oct 2022 13:30:03 +0200
Message-Id: <20221024113031.541577286@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/media/platform/exynos4-is/fimc-is.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index dc2a144cd29b..b52d2203eac5 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -213,6 +213,7 @@ static int fimc_is_register_subdevs(struct fimc_is *is)
 
 			if (ret < 0 || index >= FIMC_IS_SENSORS_NUM) {
 				of_node_put(child);
+				of_node_put(i2c_bus);
 				return ret;
 			}
 			index++;
-- 
2.35.1



