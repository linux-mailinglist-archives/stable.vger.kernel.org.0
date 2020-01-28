Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B78714B827
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgA1OVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:21:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbgA1OVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:21:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7B52071E;
        Tue, 28 Jan 2020 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221263;
        bh=Dxw+0f89/DOVqp441cgRJbzq3Pg2nRwQeSh2x1Rm7CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoZE+r8AR4gryiHedbfq8Y9lk1Ef2om1HcXWS4KKXeZX8adP9ji3nqUbYJIBAKjGp
         AakkT/JlO15H/o9gvsF4hZ1v15ADFFPt49N/Rxij6NxuHNmECNQVXzbpugvswBWA+A
         ITuY0qBHJqxQ9Ne2u6UJ1K8hwG1R8Uaq3vAvsNlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 108/271] media: tw5864: Fix possible NULL pointer dereference in tw5864_handle_frame
Date:   Tue, 28 Jan 2020 15:04:17 +0100
Message-Id: <20200128135900.618848609@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index 1ddf80f85c248..27ff6e0d98453 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -1386,13 +1386,13 @@ static void tw5864_handle_frame(struct tw5864_h264_frame *frame)
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



