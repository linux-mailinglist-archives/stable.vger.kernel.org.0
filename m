Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0748498D6A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347543AbiAXTcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56252 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348432AbiAXT2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:28:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB53861488;
        Mon, 24 Jan 2022 19:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87120C340E5;
        Mon, 24 Jan 2022 19:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052515;
        bh=dqbWfEMlNE/Ni041E7Yb6Yct9cWyfdGrWOafYB2jzak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06DEDYjITSgUU2c0Yx2z00e8+8xIDS6eGTmnw2WSg5LqJ8ua6VDSQOVe6mrsFKT78
         JyR6K/MfATqR6C2oNTB3435nb5pbgYT5ewL4eUMlx1s/Ae4j6srli+uYKT114x1JkM
         OuDelCKLd3O/KHQH+x/P5ts4bUVs9iio97TCAUV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/320] media: msi001: fix possible null-ptr-deref in msi001_probe()
Date:   Mon, 24 Jan 2022 19:41:08 +0100
Message-Id: <20220124183956.605918298@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 3d5831a40d3464eea158180eb12cbd81c5edfb6a ]

I got a null-ptr-deref report:

BUG: kernel NULL pointer dereference, address: 0000000000000060
...
RIP: 0010:v4l2_ctrl_auto_cluster+0x57/0x270
...
Call Trace:
 msi001_probe+0x13b/0x24b [msi001]
 spi_probe+0xeb/0x130
...
 do_syscall_64+0x35/0xb0

In msi001_probe(), if the creation of control for bandwidth_auto
fails, there will be a null-ptr-deref issue when it is used in
v4l2_ctrl_auto_cluster().

Check dev->hdl.error before v4l2_ctrl_auto_cluster() to fix this bug.

Link: https://lore.kernel.org/linux-media/20211026112348.2878040-1-wanghai38@huawei.com
Fixes: 93203dd6c7c4 ("[media] msi001: Mirics MSi001 silicon tuner driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/msi001.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/tuners/msi001.c b/drivers/media/tuners/msi001.c
index 78e6fd600d8ef..44247049a3190 100644
--- a/drivers/media/tuners/msi001.c
+++ b/drivers/media/tuners/msi001.c
@@ -442,6 +442,13 @@ static int msi001_probe(struct spi_device *spi)
 			V4L2_CID_RF_TUNER_BANDWIDTH_AUTO, 0, 1, 1, 1);
 	dev->bandwidth = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_BANDWIDTH, 200000, 8000000, 1, 200000);
+	if (dev->hdl.error) {
+		ret = dev->hdl.error;
+		dev_err(&spi->dev, "Could not initialize controls\n");
+		/* control init failed, free handler */
+		goto err_ctrl_handler_free;
+	}
+
 	v4l2_ctrl_auto_cluster(2, &dev->bandwidth_auto, 0, false);
 	dev->lna_gain = v4l2_ctrl_new_std(&dev->hdl, &msi001_ctrl_ops,
 			V4L2_CID_RF_TUNER_LNA_GAIN, 0, 1, 1, 1);
-- 
2.34.1



