Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029A73CD7A4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242066AbhGSORw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241981AbhGSORh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C91366113E;
        Mon, 19 Jul 2021 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706696;
        bh=7dFL7hQpsqbewXitbbFDDP6hOtMenWxFnzoeU1K3+1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXfpTDCIUoBS+DdVCR5mlxfo1OMfHxYYg5oIidZrKZ4P3Xez6e5AIqhARsV4BqD9E
         AwBuDSJ767XYEAWb50jaeZxUJgS/2zwOe7J+NDq6A0wOTehspe/cGVlJdDa8Ch1FDX
         aW8OMjyJuLCmJ46HwENjQlldsuyxjx9luzsM5AdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dillon Min <dillon.minfei@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 058/188] media: s5p-g2d: Fix a memory leak on ctx->fh.m2m_ctx
Date:   Mon, 19 Jul 2021 16:50:42 +0200
Message-Id: <20210719144926.543430599@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Min <dillon.minfei@gmail.com>

[ Upstream commit 5d11e6aad1811ea293ee2996cec9124f7fccb661 ]

The m2m_ctx resources was allocated by v4l2_m2m_ctx_init() in g2d_open()
should be freed from g2d_release() when it's not used.

Fix it

Fixes: 918847341af0 ("[media] v4l: add G2D driver for s5p device family")
Signed-off-by: Dillon Min <dillon.minfei@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-g2d/g2d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 2b939555cccb..21968ef9dc45 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -282,6 +282,9 @@ static int g2d_release(struct file *file)
 	struct g2d_dev *dev = video_drvdata(file);
 	struct g2d_ctx *ctx = fh2ctx(file->private_data);
 
+	mutex_lock(&dev->mutex);
+	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
+	mutex_unlock(&dev->mutex);
 	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-- 
2.30.2



