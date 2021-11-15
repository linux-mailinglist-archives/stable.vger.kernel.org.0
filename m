Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4900450B3F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbhKORU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237315AbhKORTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5731C63264;
        Mon, 15 Nov 2021 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996451;
        bh=00t9+56O2F+wjU4QcpzyqZH5P6Zty6X2Mm41xVal2yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wELE07TYF/Uey8XNuQe+jJoU1JxPh7RE62sbbmJmH2QCPEr95cY7OGEk7RSACEKcW
         aK18jW4nj5Yh170GVcTzWsq1eQ6TUGSR7o3GnbSUWxfOy0bmnrJ1jVev1U42YLmsRu
         v6rG+RicovQF4+bdLnJURVNMhh4W5DxqsU5h810A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bingbu Cao <bingbu.cao@intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/355] media: ipu3-imgu: VIDIOC_QUERYCAP: Fix bus_info
Date:   Mon, 15 Nov 2021 18:01:09 +0100
Message-Id: <20211115165318.481796148@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit ea2b9a33711604e91f8c826f4dcb3c12baa1990a ]

bus_info field had a different value for the media entity and the video
device.

Fixes v4l2-compliance:

v4l2-compliance.cpp(637): media bus_info 'PCI:0000:00:05.0' differs from
			  V4L2 bus_info 'PCI:viewfinder'

Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index dd214fcd80cf8..53239ea67fe48 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -594,11 +594,12 @@ static const struct imgu_fmt *find_format(struct v4l2_format *f, u32 type)
 static int imgu_vidioc_querycap(struct file *file, void *fh,
 				struct v4l2_capability *cap)
 {
-	struct imgu_video_device *node = file_to_intel_imgu_node(file);
+	struct imgu_device *imgu = video_drvdata(file);
 
 	strscpy(cap->driver, IMGU_NAME, sizeof(cap->driver));
 	strscpy(cap->card, IMGU_NAME, sizeof(cap->card));
-	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s", node->name);
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
+		 pci_name(imgu->pci_dev));
 
 	return 0;
 }
-- 
2.33.0



