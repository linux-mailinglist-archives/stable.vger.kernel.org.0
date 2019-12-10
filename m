Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67660119E62
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbfLJWoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:44:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbfLJWav (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:30:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9279207FF;
        Tue, 10 Dec 2019 22:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017050;
        bh=9ayxFiiRo/5juvAvRN+DLnoDZxTnce77doeiWpqr+8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U53+gAq+nschF5peaBcm7PP1HNflK3Y+LMkKGOh2WJZ/DkJBasSYGZgxwYJ1tkoxw
         eO3+M6QpBQTmYyuFV+uzYF6HmEIJL/yqMoQzpUFC4mFicaH6Lq833xwQeotTXAx4nv
         7qiOikXF9KQlIqEICRHoPUKRcBCzgEVuumQ9KcGw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benoit Parrot <bparrot@ti.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/91] media: am437x-vpfe: Setting STD to current value is not an error
Date:   Tue, 10 Dec 2019 17:29:16 -0500
Message-Id: <20191210223035.14270-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benoit Parrot <bparrot@ti.com>

[ Upstream commit 13aa21cfe92ce9ebb51824029d89f19c33f81419 ]

VIDIOC_S_STD should not return an error if the value is identical
to the current one.
This error was highlighted by the v4l2-compliance test.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Lad Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 05489a401c5c1..bd500f12d0f79 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1847,6 +1847,10 @@ static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 	if (!(sdinfo->inputs[0].capabilities & V4L2_IN_CAP_STD))
 		return -ENODATA;
 
+	/* if trying to set the same std then nothing to do */
+	if (vpfe_standards[vpfe->std_index].std_id == std_id)
+		return 0;
+
 	/* If streaming is started, return error */
 	if (vb2_is_busy(&vpfe->buffer_queue)) {
 		vpfe_err(vpfe, "%s device busy\n", __func__);
-- 
2.20.1

