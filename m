Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A0B657BC0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiL1PZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiL1PY6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:24:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249911403E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:24:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D36A9B816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A48EC433EF;
        Wed, 28 Dec 2022 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241095;
        bh=6tXN9D0Ut7L6MH44vvbnziWvUY6QYflUHRZzoTAXn20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7k6Iecf85eB6ybKl1U4iR7+9JuFPwuNet3t2sM9ehK41mqdcj2eLOWw0jvLzR841
         kGw0AZPXxqsV0LKSa8SRUnzVcqZ93zXQ4vOWo9azLAbSbSRqxz52vYeY4PFyzWL2U6
         pTlSGioDbuj7kKi1gLBrEoiXFAH01zGuSm/T7wMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Scally <djrscally@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0239/1073] media: exynos4-is: dont rely on the v4l2_async_subdev internals
Date:   Wed, 28 Dec 2022 15:30:27 +0100
Message-Id: <20221228144334.518580389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit f98a5c2e1c4396488c27274ba82afc11725a4bcc ]

Commit 1f391df44607 ("media: v4l2-async: Use endpoints in
__v4l2_async_nf_add_fwnode_remote()") changed the data that is stored in
the v4l2_async_subdev internals from the fwnode pointer to the parent
device to the fwnode pointer to the matched endpoint. This broke the
sensor matching code, which relied on the particular fwnode data in the
v4l2_async_subdev internals. Fix this by simply matching the
v4l2_async_subdev pointer, which is already available there.

Reported-by: Daniel Scally <djrscally@gmail.com>
Fixes: fa91f1056f17 ("[media] exynos4-is: Add support for asynchronous subdevices registration")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Daniel Scally <djrscally@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/samsung/exynos4-is/media-dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/samsung/exynos4-is/media-dev.c b/drivers/media/platform/samsung/exynos4-is/media-dev.c
index 52b43ea04030..412213b0c384 100644
--- a/drivers/media/platform/samsung/exynos4-is/media-dev.c
+++ b/drivers/media/platform/samsung/exynos4-is/media-dev.c
@@ -1380,9 +1380,7 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
-		if (fmd->sensor[i].asd &&
-		    fmd->sensor[i].asd->match.fwnode ==
-		    of_fwnode_handle(subdev->dev->of_node))
+		if (fmd->sensor[i].asd == asd)
 			si = &fmd->sensor[i];
 
 	if (si == NULL)
-- 
2.35.1



