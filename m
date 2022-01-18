Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A70491ACA
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352950AbiARDAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350723AbiARCwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:52:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26D1C03F938;
        Mon, 17 Jan 2022 18:43:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7146461127;
        Tue, 18 Jan 2022 02:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFC5C36AE3;
        Tue, 18 Jan 2022 02:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473780;
        bh=Mmov4kXM/0WU3bh6vK5IbxHSy3H97/BMQnWmsVg6fm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFfUwhzH/t6Ty8LosF3dTvjSyfwM38CHNM4VZbBbeajGeBRMEDvL5+ngqt2mZm+zY
         TPTRKBYZPUbsH/oYKm3fbWWfPcpp2zbYuiKHel1QpDf2g3eKvaIyZnZ1Y4I5LqAJk3
         hCgu1bMaYv+tctoyIO+zwWzpLhHPMgeUTbw+218FGJrNgsAxBYNOAPYlg7S1BBSUER
         2JDW2JEo7ybtskCvzrTHhfgUyJBM9VIMQw5RNwe7XwMByMPLSMGJVyHYheRSqtT6LM
         lKT8rRFmMYI56yyW5pv6Od9fSzg7V0u8L8YCG/3EJ+EKqGcSo2usZ7NX6J5B6HNyWM
         Iw5w6eCUaRs3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Qingyang <zhou1615@umn.edu>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 069/116] media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()
Date:   Mon, 17 Jan 2022 21:39:20 -0500
Message-Id: <20220118024007.1950576-69-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index d6531874faa65..8047e305f3d01 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -523,7 +523,7 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
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

