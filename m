Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD764988CB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245389AbiAXSua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245516AbiAXSth (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:49:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4ECC061768;
        Mon, 24 Jan 2022 10:49:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28460614D8;
        Mon, 24 Jan 2022 18:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69A8C340E5;
        Mon, 24 Jan 2022 18:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050170;
        bh=5NY77zdV9ozn/+VEAlvfkSk/XENHtvV6igQMct3x6Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah/ACyyZvfRyePn6l6DX0Y2wQI19zWNaz7yc5r7mh/Q32QnarlmufGmvUfLrYn3+1
         S65y3gcQGfd0dtKEEM4/xjFPemksMCgBjPJgPEDufc4V/uDKB4nPh4xC5Jwcg5ZMCo
         FbGtq5DQaS+TN8oX0amTQFF/EtwDP7N0ByvDlZoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 032/114] media: msi001: fix possible null-ptr-deref in msi001_probe()
Date:   Mon, 24 Jan 2022 19:42:07 +0100
Message-Id: <20220124183928.111280323@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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



