Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017B5440D2
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfFMQJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731260AbfFMIoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:44:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FB8620851;
        Thu, 13 Jun 2019 08:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415460;
        bh=nlxQQu1TVOMaBROokJCURPMsg/tlJX3WGEfpYjys6DU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Epin70MVnd/hXC3XexAbSCutELvPUwTjs/x4J1xlTIualSKX1qUZjAegrocQy/FxQ
         ksdJBzE8w3G7jOveTWvMAS9SgXniUVXnAvpJUn0jdkch5efnPetKwAU7b3/bJu4TrY
         +LAxC5BJ1jIM6qVNwDutcxZAG3vltT0n6IUXpzBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Karlman <jonas@kwiboo.se>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 002/155] media: rockchip/vpu: Fix/re-order probe-error/remove path
Date:   Thu, 13 Jun 2019 10:31:54 +0200
Message-Id: <20190613075652.837733651@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fc8670d1f72b746ff3a5fe441f1fca4c4dba0e6f ]

media_device_cleanup() and v4l2_m2m_unregister_media_controller() were
missing in the probe error path.
While at it, re-order calls in the remove path to unregister/cleanup
things in the reverse order they were initialized/registered.

Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index 962412c79b91..33b556b3f0df 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -481,10 +481,12 @@ static int rockchip_vpu_probe(struct platform_device *pdev)
 	return 0;
 err_video_dev_unreg:
 	if (vpu->vfd_enc) {
+		v4l2_m2m_unregister_media_controller(vpu->m2m_dev);
 		video_unregister_device(vpu->vfd_enc);
 		video_device_release(vpu->vfd_enc);
 	}
 err_m2m_rel:
+	media_device_cleanup(&vpu->mdev);
 	v4l2_m2m_release(vpu->m2m_dev);
 err_v4l2_unreg:
 	v4l2_device_unregister(&vpu->v4l2_dev);
@@ -501,13 +503,13 @@ static int rockchip_vpu_remove(struct platform_device *pdev)
 	v4l2_info(&vpu->v4l2_dev, "Removing %s\n", pdev->name);
 
 	media_device_unregister(&vpu->mdev);
-	v4l2_m2m_unregister_media_controller(vpu->m2m_dev);
-	v4l2_m2m_release(vpu->m2m_dev);
-	media_device_cleanup(&vpu->mdev);
 	if (vpu->vfd_enc) {
+		v4l2_m2m_unregister_media_controller(vpu->m2m_dev);
 		video_unregister_device(vpu->vfd_enc);
 		video_device_release(vpu->vfd_enc);
 	}
+	media_device_cleanup(&vpu->mdev);
+	v4l2_m2m_release(vpu->m2m_dev);
 	v4l2_device_unregister(&vpu->v4l2_dev);
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
 	pm_runtime_disable(vpu->dev);
-- 
2.20.1



