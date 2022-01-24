Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30389498AD4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346694AbiAXTHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:07:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35190 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346121AbiAXTFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:05:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 777CF611F9;
        Mon, 24 Jan 2022 19:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EBCC340E5;
        Mon, 24 Jan 2022 19:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051103;
        bh=5NY77zdV9ozn/+VEAlvfkSk/XENHtvV6igQMct3x6Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oC9s83EDntQZRbUXWRJqDT21vfPTXyVHrlKhp0RLa8J6KgdHy+XdouZwTGeGzd8Dr
         wUhrWFKK8UwNJjvgY4X5wL5eJeZO27H59qzVGxxPqtGx//VvGVxdD7edAcojlG2m1z
         D0w/WypYfJqqg1dcDi+4ADt88BUwOGHGj/MSOUDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 055/186] media: msi001: fix possible null-ptr-deref in msi001_probe()
Date:   Mon, 24 Jan 2022 19:42:10 +0100
Message-Id: <20220124183938.898353459@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
index 3a12ef35682b5..64d98517f470f 100644
--- a/drivers/media/tuners/msi001.c
+++ b/drivers/media/tuners/msi001.c
@@ -464,6 +464,13 @@ static int msi001_probe(struct spi_device *spi)
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



