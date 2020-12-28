Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DE62E3CAA
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437617AbgL1OFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437611AbgL1OFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE871207B2;
        Mon, 28 Dec 2020 14:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164282;
        bh=Z1rfFhuzp6IwUyMd17rCXrQ0YW7uMXwsp4Y31TjnXQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUAy7uK1d0Q4Rfy9tDeKWks0wBkw29sdIAb3Q6nmb4ex+Ti7v+W0Xd1yDTRL80Jqb
         xUNpzXC+jb2kVqN52H7waaS6rZPyMx1k3ZjnZOqBfGMJh/HLOkByTyWYzbbNCjn4Rk
         fGJicGXxjk/FVTfvo/akopoExcodHOVG2ogQ8SPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/717] media: staging: rkisp1: cap: fix runtime PM imbalance on error
Date:   Mon, 28 Dec 2020 13:42:04 +0100
Message-Id: <20201228125026.986049733@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 4cbbe2aaa0536b0e7b3dfbd7febc3bc2ec300559 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference imbalance in rkisp1_vb2_start_streaming, so we
should fix it.

Fixes: 56e3b29f9f6b2 ("media: staging: rkisp1: add streaming paths")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkisp1/rkisp1-capture.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/rkisp1/rkisp1-capture.c b/drivers/staging/media/rkisp1/rkisp1-capture.c
index b6f497ce3e95c..0c934ca5adaa3 100644
--- a/drivers/staging/media/rkisp1/rkisp1-capture.c
+++ b/drivers/staging/media/rkisp1/rkisp1-capture.c
@@ -992,6 +992,7 @@ rkisp1_vb2_start_streaming(struct vb2_queue *queue, unsigned int count)
 
 	ret = pm_runtime_get_sync(cap->rkisp1->dev);
 	if (ret < 0) {
+		pm_runtime_put_noidle(cap->rkisp1->dev);
 		dev_err(cap->rkisp1->dev, "power up failed %d\n", ret);
 		goto err_destroy_dummy;
 	}
-- 
2.27.0



