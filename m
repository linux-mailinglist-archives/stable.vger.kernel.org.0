Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46E24990BA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350507AbiAXUDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376372AbiAXUBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:01:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1998CC055ABE;
        Mon, 24 Jan 2022 11:28:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADDA26148F;
        Mon, 24 Jan 2022 19:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0F3C340E7;
        Mon, 24 Jan 2022 19:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052527;
        bh=jNhhpFP2tNg+Npy4Crv5614QHwFsd4ldaIklWzBWj20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncJBAo2PsG3u4k3A+vimOP90FEwhtem6E3chxLDlnL3dH76p/96eFWNAqHumcEyNr
         ySRtEXFRcj4dZCvUaDhyOZnbr0zJTHhy0zhf0EFLDz7ZWL2QRSt5SUj5qZZPgamGwv
         KUJXgHEy90bQR3er/+ZdnDIjsfHfvqOs2sCMFf10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/320] media: hantro: Fix probe func error path
Date:   Mon, 24 Jan 2022 19:41:12 +0100
Message-Id: <20220124183956.735090904@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 37af43b250fda6162005d47bf7c959c70d52b107 ]

If clocks for some reason couldn't be enabled, probe function returns
immediately, without disabling PM. This obviously leaves PM ref counters
unbalanced.

Fix that by jumping to appropriate error path, so effects of PM functions
are reversed.

Fixes: 775fec69008d ("media: add Rockchip VPU JPEG encoder driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/hantro/hantro_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/hantro/hantro_drv.c b/drivers/staging/media/hantro/hantro_drv.c
index 32e5966ba5c5f..58cf44045b396 100644
--- a/drivers/staging/media/hantro/hantro_drv.c
+++ b/drivers/staging/media/hantro/hantro_drv.c
@@ -823,7 +823,7 @@ static int hantro_probe(struct platform_device *pdev)
 	ret = clk_bulk_prepare(vpu->variant->num_clocks, vpu->clocks);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to prepare clocks\n");
-		return ret;
+		goto err_pm_disable;
 	}
 
 	ret = v4l2_device_register(&pdev->dev, &vpu->v4l2_dev);
@@ -879,6 +879,7 @@ err_v4l2_unreg:
 	v4l2_device_unregister(&vpu->v4l2_dev);
 err_clk_unprepare:
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
+err_pm_disable:
 	pm_runtime_dont_use_autosuspend(vpu->dev);
 	pm_runtime_disable(vpu->dev);
 	return ret;
-- 
2.34.1



