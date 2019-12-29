Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A92C912C79D
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbfL2RoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:44:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730677AbfL2RoZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:44:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C41A620718;
        Sun, 29 Dec 2019 17:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641464;
        bh=tU2GX5+sca3ivMdzwzsrGxtVKUy5coL92TLj6QPC+iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtyu63JBB0OPfmYw8ag28SOHCFSv4UnhsGBdXlqDPdifAXCm372Zo0pgnaIyPyY6c
         gPdMAz2rgoVb5Kc2cFHHUu6dvRHv9sgj84A5Vq18wah7namaTFQh+JMwYYzkPeHhpr
         mETEtZIXZ4TFGQwVk7SV1Jr7Q3S0EGS4AwEoRYQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/434] media: vim2m: Fix abort issue
Date:   Sun, 29 Dec 2019 18:22:10 +0100
Message-Id: <20191229172706.741138426@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit c362f77a243bfd1daec21b6c36491c061ee2f31b ]

Currently, if start streaming -> stop streaming -> start streaming
sequence is executed, driver will end job prematurely, if ctx->translen
is higher than 1, because "aborting" flag is still set from previous
stop streaming command.

Fix that by clearing "aborting" flag in start streaming handler.

Fixes: 96d8eab5d0a1 ("V4L/DVB: [v5,2/2] v4l: Add a mem-to-mem videobuf framework test device")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index acd3bd48c7e2..2d79cdc130c5 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1073,6 +1073,9 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (!q_data)
 		return -EINVAL;
 
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		ctx->aborting = 0;
+
 	q_data->sequence = 0;
 	return 0;
 }
-- 
2.20.1



