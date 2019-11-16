Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3117CFF25A
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfKPPq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:46:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729388AbfKPPq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:27 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4209020830;
        Sat, 16 Nov 2019 15:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919186;
        bh=yztD/eG3vMr/Rvs0vWXMhNLFKFHrlrDPs/mf4F4zuqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcNZg48p29k8GoM2Khl9YjEd//n+fJqNjaoIt+SERnq0j2y6b3aVCY4Dy91wRwhcr
         uHS3c3HG4QUW1PMEAqJnbeY64T/df9eHYn2Pjyhd5tghl1tH5ztGstyr7vDEMn1wb4
         mk9CE51HQgljxU7YxeJOTfmoG89ZHL9QNxVe60f8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 194/237] media: ov13858: Check for possible null pointer
Date:   Sat, 16 Nov 2019 10:40:29 -0500
Message-Id: <20191116154113.7417-194-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>

[ Upstream commit 35629182eb8f931b0de6ed38c0efac58e922c801 ]

Check for possible null pointer to avoid crash.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov13858.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index a66f6201f53c7..cf28381a903e3 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1612,7 +1612,8 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 				OV13858_NUM_OF_LINK_FREQS - 1,
 				0,
 				link_freq_menu_items);
-	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	if (ov13858->link_freq)
+		ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
 	pixel_rate_min = link_freq_to_pixel_rate(link_freq_menu_items[1]);
@@ -1635,7 +1636,8 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 	ov13858->hblank = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_HBLANK,
 				hblank, hblank, 1, hblank);
-	ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	if (ov13858->hblank)
+		ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	exposure_max = mode->vts_def - 8;
 	ov13858->exposure = v4l2_ctrl_new_std(
-- 
2.20.1

