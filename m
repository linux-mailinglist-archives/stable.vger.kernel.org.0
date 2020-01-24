Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497241480EF
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbgAXLPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390305AbgAXLPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:15:40 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7586520708;
        Fri, 24 Jan 2020 11:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864540;
        bh=tUh6CLf0IpiGLRBcHFAphW+usAQVEqq6YxT2MviT4vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRVI9Gv8b7Aev3xPT5LSCo9JptQQZfdjxsfPS7IcYU5Aas31b1mbiyCy2syfK7cVf
         M+7GyqUnR7GOvAP7ssBIIZblEki7xs1eIcuIeDul6yN/bIkyLjDphWZJYbF/mi2b0r
         grdvbwa8sVCbDQhGmc6yWqCbxihLHyBdex5z8c4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 281/639] media: tw5864: Fix possible NULL pointer dereference in tw5864_handle_frame
Date:   Fri, 24 Jan 2020 10:27:31 +0100
Message-Id: <20200124093122.017268600@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 2e7682ebfc750177a4944eeb56e97a3f05734528 ]

'vb' null check should be done before dereferencing it in
tw5864_handle_frame, otherwise a NULL pointer dereference
may occur.

Fixes: 34d1324edd31 ("[media] pci: Add tw5864 driver")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw5864/tw5864-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index ff2b7da90c088..6c40e60ac9939 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -1395,13 +1395,13 @@ static void tw5864_handle_frame(struct tw5864_h264_frame *frame)
 	input->vb = NULL;
 	spin_unlock_irqrestore(&input->slock, flags);
 
-	v4l2_buf = to_vb2_v4l2_buffer(&vb->vb.vb2_buf);
-
 	if (!vb) { /* Gone because of disabling */
 		dev_dbg(&dev->pci->dev, "vb is empty, dropping frame\n");
 		return;
 	}
 
+	v4l2_buf = to_vb2_v4l2_buffer(&vb->vb.vb2_buf);
+
 	/*
 	 * Check for space.
 	 * Mind the overhead of startcode emulation prevention.
-- 
2.20.1



