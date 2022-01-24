Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E14E49A248
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365660AbiAXXv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356613AbiAXWjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7CFC05487D;
        Mon, 24 Jan 2022 13:02:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CE4D61330;
        Mon, 24 Jan 2022 21:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F753C340E5;
        Mon, 24 Jan 2022 21:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058158;
        bh=B5br9ewwZxFUbx8koaJI0fAcTbHZVutvSbyrlS9WXuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlHKJ2cDDhbNyK5OEOqBQ7OWI3nPDhdXqrfGL6mCXYu+0zsYLeyzQf3M80X/RbhSP
         RXtgByGrqkw8FvNGcXbc2lFmhBOGEmiN6CyZcRUesEH+AC2QwD09RPSJchDYdYSfA8
         BgyS/MeLEQFwBW50typIyItsHguCXno2S52r+yt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0191/1039] media: mtk-vcodec: Fix an error handling path in mtk_vcodec_probe()
Date:   Mon, 24 Jan 2022 19:33:00 +0100
Message-Id: <20220124184131.723405427@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 615c6f28b9ad7efc9bfbef2cafc6a0c5bc0c21e0 ]

In case of error the 'media_device_init()' call is not balanced by a
corresponding 'media_device_cleanup()' call.

Add it, when needed, as already done in the remove function.

Fixes: 118add98f80e ("media: mtk-vcodec: vdec: add media device if using stateless api")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Tzung-Bi Shih <tzungbi@google.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
index e6e6a8203eebf..8277c44209b5b 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c
@@ -358,6 +358,8 @@ err_media_reg:
 	if (dev->vdec_pdata->uses_stateless_api)
 		v4l2_m2m_unregister_media_controller(dev->m2m_dev_dec);
 err_reg_cont:
+	if (dev->vdec_pdata->uses_stateless_api)
+		media_device_cleanup(&dev->mdev_dec);
 	destroy_workqueue(dev->decode_workqueue);
 err_event_workq:
 	v4l2_m2m_release(dev->m2m_dev_dec);
-- 
2.34.1



