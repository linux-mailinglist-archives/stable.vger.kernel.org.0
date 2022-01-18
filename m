Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38EC491813
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343563AbiARCoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346584AbiARCje (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:39:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5838C06138F;
        Mon, 17 Jan 2022 18:36:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16D27B81260;
        Tue, 18 Jan 2022 02:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028C6C36AEF;
        Tue, 18 Jan 2022 02:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473363;
        bh=t6EK6nXBYsJjngzkuNBBOsN4uXBS60XMMOEjqfzHALs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJmGqkEld2E1r6BX9XXn7wrDBWvgr0MX7+PJfjfOWf4ahINuCRMpbi2HKBjQSakI6
         asyxfXi0b6Rae0YfdBIklEub/XJCKptdAaFVDXlCmdZFufsa2fjNtK1aB6UlCHvipY
         G2a77ORadkgOl24bn3XrWCT3hTehp1etjbqChvmVSIEaB1J/luKnNluisXJVquWJRZ
         1rZcIWIal4Ld//5lOLUqigZ+mB1f0Q4o26EmPRPSD5ugLXk1GrxnDdRDhYEf3bVQAj
         3fc12AhvdeIfDSafjEDhSSo/IYBHXYc+L0HfQPjLog7Jdjzl+/NQyRlhCb5F4yd0V7
         88Cu6TYL7Kfwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tsuchiya Yuto <kitakar@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, hverkuil-cisco@xs4all.nl,
        arnd@arndb.de, tomi.valkeinen@ideasonboard.com,
        alex.dewar90@gmail.com, alinesantanacordeiro@gmail.com,
        peterz@infradead.org, mingo@kernel.org, kaixuxia@tencent.com,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 086/188] media: atomisp: fix "variable dereferenced before check 'asd'"
Date:   Mon, 17 Jan 2022 21:30:10 -0500
Message-Id: <20220118023152.1948105-86-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tsuchiya Yuto <kitakar@gmail.com>

[ Upstream commit ac56760a8bbb4e654b2fd54e5de79dd5d72f937d ]

There are two occurrences where the variable 'asd' is dereferenced
before check. Fix this issue by using the variable after the check.

Link: https://lore.kernel.org/linux-media/20211122074122.GA6581@kili/

Link: https://lore.kernel.org/linux-media/20211201141904.47231-1-kitakar@gmail.com
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_cmd.c   | 3 ++-
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
index 1ddb9c815a3cb..ef0b0963cf930 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -5224,7 +5224,7 @@ static int atomisp_set_fmt_to_isp(struct video_device *vdev,
 	int (*configure_pp_input)(struct atomisp_sub_device *asd,
 				  unsigned int width, unsigned int height) =
 				      configure_pp_input_nop;
-	u16 stream_index = atomisp_source_pad_to_stream_id(asd, source_pad);
+	u16 stream_index;
 	const struct atomisp_in_fmt_conv *fc;
 	int ret, i;
 
@@ -5233,6 +5233,7 @@ static int atomisp_set_fmt_to_isp(struct video_device *vdev,
 			__func__, vdev->name);
 		return -EINVAL;
 	}
+	stream_index = atomisp_source_pad_to_stream_id(asd, source_pad);
 
 	v4l2_fh_init(&fh.vfh, vdev);
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
index 442446e5d59f7..3861e794272ea 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -1112,7 +1112,7 @@ int __atomisp_reqbufs(struct file *file, void *fh,
 	struct ia_css_frame *frame;
 	struct videobuf_vmalloc_memory *vm_mem;
 	u16 source_pad = atomisp_subdev_source_pad(vdev);
-	u16 stream_id = atomisp_source_pad_to_stream_id(asd, source_pad);
+	u16 stream_id;
 	int ret = 0, i = 0;
 
 	if (!asd) {
@@ -1120,6 +1120,7 @@ int __atomisp_reqbufs(struct file *file, void *fh,
 			__func__, vdev->name);
 		return -EINVAL;
 	}
+	stream_id = atomisp_source_pad_to_stream_id(asd, source_pad);
 
 	if (req->count == 0) {
 		mutex_lock(&pipe->capq.vb_lock);
-- 
2.34.1

