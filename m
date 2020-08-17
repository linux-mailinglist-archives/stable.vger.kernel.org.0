Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FD8247124
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390867AbgHQSVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387682AbgHQQED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:04:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9155820772;
        Mon, 17 Aug 2020 16:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680243;
        bh=t4AJDmcFIYAeMJ26/qlszQXPc/mM9mgAbfhlt6uFyQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhZubAZTT6WwI1R0uxWLDyWvK8fnUS6P2pdMrFSN1oZpfEk5Eu8wfxHfWWCP9mejx
         WbmVP4Vfoo2NqnoHz+a5NFDr7LfjdWGrObFHlc20UXaPnE20as1rBTkTyQNROnCKkF
         5KWCg8/2E3R02pg4kw94D+LsIdF8XVCklVemdvhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/270] media: marvell-ccic: Add missed v4l2_async_notifier_cleanup()
Date:   Mon, 17 Aug 2020 17:15:10 +0200
Message-Id: <20200817143801.217754288@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index 803baf97f06e4..6de8b3d99fb9e 100644
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



