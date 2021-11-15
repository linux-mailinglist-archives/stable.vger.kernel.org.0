Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8FF4526B3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhKPCKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239150AbhKORyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:54:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB6D963323;
        Mon, 15 Nov 2021 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997601;
        bh=5lJM8+1B7Xb0bOt1RewIpoClNTVOuJ9ombagdOIdK6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4e3XCtfp+2bux5C2FQYtws4PecL4sQnUf4cvmcy//lQfsb+nKn3ZdmYsspDoI8Ah
         4MEXoPtCBszkwvcGOSTSCCyzOe6bv5hsk8048zBUKaC0oRaQVv/8OdArQzcdyagATQ
         +2MPDs3XwN+h9tBE/Lx7w/NVGXedvYw5aR8+V2RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bingbu Cao <bingbu.cao@intel.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/575] media: ipu3-imgu: VIDIOC_QUERYCAP: Fix bus_info
Date:   Mon, 15 Nov 2021 17:58:52 +0100
Message-Id: <20211115165350.866933011@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 7926a777cbc8b..103f84466f6fc 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -592,11 +592,12 @@ static const struct imgu_fmt *find_format(struct v4l2_format *f, u32 type)
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



