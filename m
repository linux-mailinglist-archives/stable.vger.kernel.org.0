Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FE7499418
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388410AbiAXUi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348495AbiAXUdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6510C07E2A4;
        Mon, 24 Jan 2022 11:46:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53F9D614BB;
        Mon, 24 Jan 2022 19:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB7FC340E5;
        Mon, 24 Jan 2022 19:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053566;
        bh=nkRbVp2W10K033deshM2ceJteFE6A6KthK5vUO20h1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4RcX5T7eP7DrQh29Q5oSSF4NcGcRVZN3eyv8u2I89JegiLwl8ASuEN7cCSl6QgaY
         ceXzorXhbyDwH3JZ565zYB8498EY9Pi+2UmVtwi3m3dlp4C6oVGqvNBizUt6fqUBD1
         QWHiMWbKzoRTCMkWeGZ7H1yf3w3hmu+HR+o0I/E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jammy Huang <jammy_huang@aspeedtech.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Joel Stanley <joel@jms.id.au>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/563] media: aspeed: fix mode-detect always time out at 2nd run
Date:   Mon, 24 Jan 2022 19:37:20 +0100
Message-Id: <20220124184026.991814372@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jammy Huang <jammy_huang@aspeedtech.com>

[ Upstream commit 62cea52ad4bead0ae4be2cfe1142eb0aae0e9fbd ]

aspeed_video_get_resolution() will try to do res-detect again if the
timing got in last try is invalid. But it will always time out because
VE_SEQ_CTRL_TRIG_MODE_DET is only cleared after 1st mode-detect.

To fix the problem, just clear VE_SEQ_CTRL_TRIG_MODE_DET before setting
it in aspeed_video_enable_mode_detect().

Fixes: d2b4387f3bdf ("media: platform: Add Aspeed Video Engine driver")
Signed-off-by: Jammy Huang <jammy_huang@aspeedtech.com>
Acked-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/aspeed-video.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/aspeed-video.c b/drivers/media/platform/aspeed-video.c
index 7bb6babdcade0..23c41c545c536 100644
--- a/drivers/media/platform/aspeed-video.c
+++ b/drivers/media/platform/aspeed-video.c
@@ -500,6 +500,10 @@ static void aspeed_video_enable_mode_detect(struct aspeed_video *video)
 	aspeed_video_update(video, VE_INTERRUPT_CTRL, 0,
 			    VE_INTERRUPT_MODE_DETECT);
 
+	/* Disable mode detect in order to re-trigger */
+	aspeed_video_update(video, VE_SEQ_CTRL,
+			    VE_SEQ_CTRL_TRIG_MODE_DET, 0);
+
 	/* Trigger mode detect */
 	aspeed_video_update(video, VE_SEQ_CTRL, 0, VE_SEQ_CTRL_TRIG_MODE_DET);
 }
@@ -786,10 +790,6 @@ static void aspeed_video_get_resolution(struct aspeed_video *video)
 			return;
 		}
 
-		/* Disable mode detect in order to re-trigger */
-		aspeed_video_update(video, VE_SEQ_CTRL,
-				    VE_SEQ_CTRL_TRIG_MODE_DET, 0);
-
 		aspeed_video_check_and_set_polarity(video);
 
 		aspeed_video_enable_mode_detect(video);
-- 
2.34.1



