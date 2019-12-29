Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F041012C76A
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbfL2R3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:29:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728730AbfL2R3I (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:29:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2CB20722;
        Sun, 29 Dec 2019 17:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640547;
        bh=Rgirj3H8NYh1nKmJ6SrOmyEmFgV0feelfe6H2rxU0+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kvr9aA0Gk4lF0LFudh1RsrdnyS+zeR+IIuAvCICtK3wm+nEtqdInUIpZJl3FutSQS
         cC4ItQfUXqLarxGI0/Z8n0iZw0ipYdlOEsF5q901wBi58FpV87HJq3G8UJ+R3NqgbR
         bP/jO6/Dcw35JBKT8MPqOBCWE8Xk8yV7OlRBKlrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benoit Parrot <bparrot@ti.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/219] media: am437x-vpfe: Setting STD to current value is not an error
Date:   Sun, 29 Dec 2019 18:17:21 +0100
Message-Id: <20191229162514.206369196@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b05738a95e55..809320decdeb 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1848,6 +1848,10 @@ static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
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



