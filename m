Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C364510C3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbhKOSzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242938AbhKOSwe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:52:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 783A963474;
        Mon, 15 Nov 2021 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999806;
        bh=0Mgl7Jp8YwnSMWIq36oBQkU1Uuzk5veNuyHc7pxbnD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jAmdS8jugCH4qv5pnKvDY3QK6lQX/33g8D+BK+vGuSxMfUI3aqlF2qnbYAiamVVYR
         iNbAiUJlUd3O4o5r3CD4/m7Uuo5LaDPbaiw/Kb62qwVtNEmYWdwwZeRjQ7TDrbNnC2
         38jq8Nfk/el9zXI8PWSLMqwQO6nxYBky62gowZjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 388/849] media: imx-jpeg: Fix the error handling path of mxc_jpeg_probe()
Date:   Mon, 15 Nov 2021 17:57:51 +0100
Message-Id: <20211115165433.384113005@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



