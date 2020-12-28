Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35B72E6412
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391957AbgL1Pq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:46:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404497AbgL1Nni (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:43:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C86F205CB;
        Mon, 28 Dec 2020 13:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163002;
        bh=Qy6O7UFGwu6RzimuKDMLL3i6t7Q79U4OyBRspofJ90c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LNq54s8bro/+dq7oPQbPDj3N4BMKKdimA9vwai1VsIZKv4cDAgE1M6GtVMh0sGJ5
         w/uBkrtvLIX6nH+XwoBKDfq3uYC99/8brE4TGGQ/MfdQIvOw+kduBMushujzNCdWTr
         GRpREGX8Wrlu/uQ8lwSVpRt4MaZYPHNEDEzltjCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/453] media: mtk-vcodec: add missing put_device() call in mtk_vcodec_release_dec_pm()
Date:   Mon, 28 Dec 2020 13:46:10 +0100
Message-Id: <20201228124943.648971943@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 27c3943683f74e35e1d390ceb2e3639eff616ad6 ]

mtk_vcodec_release_dec_pm() will be called in two places:

a. mtk_vcodec_init_dec_pm() succeed while mtk_vcodec_probe() return error.
b. mtk_vcodec_dec_remove().

In both cases put_device() call is needed, since of_find_device_by_node()
was called in mtk_vcodec_init_dec_pm() previously.

Thus add put_devices() call in mtk_vcodec_release_dec_pm()

Fixes: 590577a4e525 ("[media] vcodec: mediatek: Add Mediatek V4L2 Video Decoder Driver")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
index 01e680ede9bd5..f9bbd0000bf3e 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
@@ -86,6 +86,7 @@ put_device:
 void mtk_vcodec_release_dec_pm(struct mtk_vcodec_dev *dev)
 {
 	pm_runtime_disable(dev->pm.dev);
+	put_device(dev->pm.larbvdec);
 }
 
 void mtk_vcodec_dec_pw_on(struct mtk_vcodec_pm *pm)
-- 
2.27.0



