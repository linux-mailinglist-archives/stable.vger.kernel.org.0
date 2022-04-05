Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6414F3E04
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380913AbiDEMOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357188AbiDEKZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:25:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632574F45E;
        Tue,  5 Apr 2022 03:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20D5BB81C99;
        Tue,  5 Apr 2022 10:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D44C385A1;
        Tue,  5 Apr 2022 10:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153380;
        bh=iaSwEjjuWRcxTwl+l28MhCYSoH0dBAcZnjsk1fku08Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVBURlHeIyV5shavaDYoH90+Gc5qdLdunkopQ9EpRQBnyQLFPH8nj6BZxCFTnVNGg
         xzKq/LJDp3Xvc8NsHbtDdT7W2xKQ8K82rLVxI9uXjGfBb4WIqQWE8iXWJrpH/oKTxd
         fGY5BU0FyYhX449mF0duj+eYqXYRWOrw5Pm0X8uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 164/599] vfio: platform: simplify device removal
Date:   Tue,  5 Apr 2022 09:27:38 +0200
Message-Id: <20220405070303.721581867@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 5b495ac8fe03b9e0d2e775f9064c3e2a340ff440 ]

vfio_platform_remove_common() cannot return non-NULL in
vfio_amba_remove() as the latter is only called if vfio_amba_probe()
returned success.

Diagnosed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20210126165835.687514-4-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/platform/vfio_amba.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index 9636a2afaecd..7b3ebf1558e1 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -73,16 +73,12 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
 
 static int vfio_amba_remove(struct amba_device *adev)
 {
-	struct vfio_platform_device *vdev;
-
-	vdev = vfio_platform_remove_common(&adev->dev);
-	if (vdev) {
-		kfree(vdev->name);
-		kfree(vdev);
-		return 0;
-	}
+	struct vfio_platform_device *vdev =
+		vfio_platform_remove_common(&adev->dev);
 
-	return -EINVAL;
+	kfree(vdev->name);
+	kfree(vdev);
+	return 0;
 }
 
 static const struct amba_id pl330_ids[] = {
-- 
2.34.1



