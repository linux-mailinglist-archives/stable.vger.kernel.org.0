Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DFE451FE5
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352895AbhKPApo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343783AbhKOTWD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2000A635E3;
        Mon, 15 Nov 2021 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001961;
        bh=0Mgl7Jp8YwnSMWIq36oBQkU1Uuzk5veNuyHc7pxbnD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLDAo3O9/79H0lectqhKiCRdt/zRUO/+dEHMT6L6sa3o50jLjatobS9TwkL5QV5kG
         Um9BAoZQqXfPmXZlB1dz7Y+HLwrF5Q6RVSEU+GTZinLyqGsPqQN84CmidfrypcOklF
         PvmDyyI6IHlDZII50SNi/5eIPVeRo/TnatI2Z6FQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 387/917] media: imx-jpeg: Fix the error handling path of mxc_jpeg_probe()
Date:   Mon, 15 Nov 2021 17:58:02 +0100
Message-Id: <20211115165441.888758339@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5c47dc6657543b3c4dffcbe741fb693b9b96796d ]

A successful 'mxc_jpeg_attach_pm_domains()' call should be balanced by a
corresponding 'mxc_jpeg_detach_pm_domains()' call in the error handling
path of the probe, as already done in the remove function.

Update the error handling path accordingly.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 33e7604271cdf..fc905ea78b175 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -2092,6 +2092,8 @@ err_m2m:
 	v4l2_device_unregister(&jpeg->v4l2_dev);
 
 err_register:
+	mxc_jpeg_detach_pm_domains(jpeg);
+
 err_irq:
 	return ret;
 }
-- 
2.33.0



