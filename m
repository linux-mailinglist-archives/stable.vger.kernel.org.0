Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE05247383
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgHQPuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387806AbgHQPtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:49:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F167A2177B;
        Mon, 17 Aug 2020 15:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679386;
        bh=FuDqbqHNGOJ1FAQuHX3T3LekdytDLHEkuF0/xXfCRJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4ojjnZKv0fCavwbnPYRks3M9CNptgka2plUZyOfQSf39F/9BF7/H2zlmgtLgS3a2
         lYQoHUoEM6E3teARnJWmF31oElHSiBFq9Z4dIG8aeLIW43FKehKaeZhOx9fFMVim4o
         Xcl5W2YESDn832L7ZRymhzbkzA0FAO/DiX3HXvgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 153/393] media: marvell-ccic: Add missed v4l2_async_notifier_cleanup()
Date:   Mon, 17 Aug 2020 17:13:23 +0200
Message-Id: <20200817143827.038516566@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit 4603a5b4a87ccd6fb90cbfa10195291cfcf6ba34 ]

mccic_register() forgets to cleanup the notifier in its error handler.
mccic_shutdown() also misses calling v4l2_async_notifier_cleanup().
Add the missed calls to fix them.

Fixes: 3eefe36cc00c ("media: marvell-ccic: use async notifier to get the sensor")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 09775b6624c6b..326e79b8531c5 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1940,6 +1940,7 @@ int mccic_register(struct mcam_camera *cam)
 out:
 	v4l2_async_notifier_unregister(&cam->notifier);
 	v4l2_device_unregister(&cam->v4l2_dev);
+	v4l2_async_notifier_cleanup(&cam->notifier);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mccic_register);
@@ -1961,6 +1962,7 @@ void mccic_shutdown(struct mcam_camera *cam)
 	v4l2_ctrl_handler_free(&cam->ctrl_handler);
 	v4l2_async_notifier_unregister(&cam->notifier);
 	v4l2_device_unregister(&cam->v4l2_dev);
+	v4l2_async_notifier_cleanup(&cam->notifier);
 }
 EXPORT_SYMBOL_GPL(mccic_shutdown);
 
-- 
2.25.1



