Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ACB491811
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbiARCoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345781AbiARCjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:39:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8F5C061786;
        Mon, 17 Jan 2022 18:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B5AA61268;
        Tue, 18 Jan 2022 02:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC437C36AF2;
        Tue, 18 Jan 2022 02:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473357;
        bh=JjoTPxcrsm13yYDz2X0aCGOrakWj/cvM4DjQzFBa75A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEJHHOksiw+iIIOa6JbEFga0b9Rhzyb/2f6W0S4NFLoXYEY0WRHRkSHDm6lIbLKR6
         lO4fqqFx3ipIKYyfjTnLPYP0Kaz2rLRLkzCTBZHDf9WC6ly16gVO0gr8GMkPTQjujM
         NIhURsPADtdiCFIlp7LfsGCZkZ+b6LJODjhlC+OVzwKPRJqmTT3OBXDZ4sTRzfcxpl
         KRVn0gZarA+A6ZC5zYxEEP/qYnPD0thyfPc01RAXtCEUzrV5VRQ6/2MniswVyhJhum
         8Mz7X+8G7E7qC5UIaf8kweRsPXG9XrUBXRuXBg62FE1R/kl0Z99Yfa0jkAdRar/ov3
         /8PyVuTUPIZgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Qingyang <zhou1615@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 085/188] media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()
Date:   Mon, 17 Jan 2022 21:30:09 -0500
Message-Id: <20220118023152.1948105-85-sashal@kernel.org>
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

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit 348df8035301dd212e3cc2860efe4c86cb0d3303 ]

In hexium_attach(dev, info), saa7146_vv_init() is called to allocate
a new memory for dev->vv_data. In hexium_detach(), saa7146_vv_release()
will be called and there is a dereference of dev->vv_data in
saa7146_vv_release(), which could lead to a NULL pointer dereference
on failure of saa7146_vv_init() according to the following logic.

Both hexium_attach() and hexium_detach() are callback functions of
the variable 'extension', so there exists a possible call chain directly
from hexium_attach() to hexium_detach():

hexium_attach(dev, info) -- fail to alloc memory to dev->vv_data
	|		    		in saa7146_vv_init().
	|
	|
hexium_detach() -- a dereference of dev->vv_data in saa7146_vv_release()

Fix this bug by adding a check of saa7146_vv_init().

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_VIDEO_HEXIUM_ORION=m show no new warnings,
and our static analyzer no longer warns about this code.

Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7146/hexium_orion.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index 39d14c179d229..2eb4bee16b71f 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -355,10 +355,16 @@ static struct saa7146_ext_vv vv_data;
 static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
 {
 	struct hexium *hexium = (struct hexium *) dev->ext_priv;
+	int ret;
 
 	DEB_EE("\n");
 
-	saa7146_vv_init(dev, &vv_data);
+	ret = saa7146_vv_init(dev, &vv_data);
+	if (ret) {
+		pr_err("Error in saa7146_vv_init()\n");
+		return ret;
+	}
+
 	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
 	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
 	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
-- 
2.34.1

