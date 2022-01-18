Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BD449158B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245214AbiARC2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40180 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245190AbiARC0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9B6BB8122C;
        Tue, 18 Jan 2022 02:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD585C36AF3;
        Tue, 18 Jan 2022 02:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472796;
        bh=zzwXETvO8DRgU0B6/KjTgVdtgOFdMCxyOYkTNdKrc3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFDNdYNWxHDIftakssdafl/jDHpam9qoldy3UyQ+zmlOcE8yJpYSEVO+y/mB6awS1
         2fwBjE367iudgUBFfrj767ORmispNIEKJoKV3cbGmsq6E7K0Co+yWUuMpt2sqbNjNE
         eJzMexq29XgWy5g3OI9q4oVCzKEpr/HJzIYUnNuKHc1S3p/OHLdKnX39KEmwtWSQtZ
         f4Bu4CMZXbkH2fLRuY1k8hPfMK0qHOHUecW6W/ZTh7o4t0wF998NGKTbtTsHKFiU8H
         jz56wO5Y/uhwlvywejdEGVL8rcS/iXAR1jysKyxl/jtItXeF5NBsMPOQBg7CKShpBp
         3JSPqpjaPopVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Qingyang <zhou1615@umn.edu>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 136/217] media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()
Date:   Mon, 17 Jan 2022 21:18:19 -0500
Message-Id: <20220118021940.1942199-136-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit 3af86b046933ba513d08399dba0d4d8b50d607d0 ]

In hexium_attach(dev, info), saa7146_vv_init() is called to allocate
a new memory for dev->vv_data. saa7146_vv_release() will be called on
failure of saa7146_register_device(). There is a dereference of
dev->vv_data in saa7146_vv_release(), which could lead to a NULL
pointer dereference on failure of saa7146_vv_init().

Fix this bug by adding a check of saa7146_vv_init().

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_VIDEO_HEXIUM_GEMINI=m show no new warnings,
and our static analyzer no longer warns about this code.

Link: https://lore.kernel.org/linux-media/20211203154030.111210-1-zhou1615@umn.edu
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/saa7146/saa7146_fops.c | 2 +-
 drivers/media/pci/saa7146/hexium_gemini.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index baf5772c52a96..be32159777142 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -521,7 +521,7 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 		ERR("out of memory. aborting.\n");
 		kfree(vv);
 		v4l2_ctrl_handler_free(hdl);
-		return -1;
+		return -ENOMEM;
 	}
 
 	saa7146_video_uops.init(dev,vv);
diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index 2214c74bbbf15..3947701cd6c7e 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -284,7 +284,12 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	hexium_set_input(hexium, 0);
 	hexium->cur_input = 0;
 
-	saa7146_vv_init(dev, &vv_data);
+	ret = saa7146_vv_init(dev, &vv_data);
+	if (ret) {
+		i2c_del_adapter(&hexium->i2c_adapter);
+		kfree(hexium);
+		return ret;
+	}
 
 	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
 	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
-- 
2.34.1

