Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE1D49A263
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365710AbiAXXvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353848AbiAXWlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:41:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566FBC04D63D;
        Mon, 24 Jan 2022 13:04:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E610B81057;
        Mon, 24 Jan 2022 21:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A5FC340E5;
        Mon, 24 Jan 2022 21:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058296;
        bh=0jacikwTIJ8ekpPO0T6TP7Ryl+hPhvGeAirLDHLFhi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=om49342WxKRfZk3S5Ibmid3vseHt82qsNzlNPnVMh+htL5ivNigBiyXffnU8vUDXq
         ey+c37AFop8ObGMfjZpbua8h6B1w6OHtAUb5LLAPQQkYoMa3jpQQiNeVuUNj3yi0QV
         IKj+VDyTasR6MpcjVI8K6adwxXrATfv/Kk0LyEs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0244/1039] media: uvcvideo: Fix memory leak of object map on error exit path
Date:   Mon, 24 Jan 2022 19:33:53 +0100
Message-Id: <20220124184133.523951292@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 4b065060555b14c7a9b86c013a1c9bee8e8b6fbd ]

Currently when the allocation of map->name fails the error exit path
does not kfree the previously allocated object map. Fix this by
setting ret to -ENOMEM and taking the free_map exit error path to
ensure map is kfree'd.

Addresses-Coverity: ("Resource leak")

Fixes: 70fa906d6fce ("media: uvcvideo: Use control names from framework")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index f4e4aff8ddf77..711556d13d03a 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -44,8 +44,10 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 	if (v4l2_ctrl_get_name(map->id) == NULL) {
 		map->name = kmemdup(xmap->name, sizeof(xmap->name),
 				    GFP_KERNEL);
-		if (!map->name)
-			return -ENOMEM;
+		if (!map->name) {
+			ret = -ENOMEM;
+			goto free_map;
+		}
 	}
 	memcpy(map->entity, xmap->entity, sizeof(map->entity));
 	map->selector = xmap->selector;
-- 
2.34.1



