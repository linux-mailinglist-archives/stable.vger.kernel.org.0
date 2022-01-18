Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBF3491A67
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352307AbiARC7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56404 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345210AbiARCrl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:47:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4BBAB811CE;
        Tue, 18 Jan 2022 02:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD420C36AEB;
        Tue, 18 Jan 2022 02:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474058;
        bh=IgOmWKurGb8OpPoy0PJCtd1kBOIPTV6l0o9s3riMki8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HD0/za9sITI9ZhZDbqBjvMe1Hzmm1J2MST4gSzdc/U5207F3IJBRvGTzgn7CfYxqZ
         k44jB5UJ+Bz124i01++a19h7CdE/mQi2tTmOVqlYLxJRJ3Ux96J5XZ6KojDlXWeo7U
         1olZYH0kf7Exsedozz8Xj8gafEAO+1NEzpo+qwRdCzZTTxewhxr7t/yPAj5svghYxC
         IMW9MmGIUbP0FiCRc0MW+dz0o91KIYMfuTRkCEuXOlNbMYL8/b+FuIgSkzdy8YkuYF
         CXTGJlpx1DajpMD6yL4YVJkhZ8sr07PJUwf0o4wqf8UM70LGUSihqa/nWapAcCzxtK
         I5U2RTszg9exQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhou Qingyang <zhou1615@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/59] media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()
Date:   Mon, 17 Jan 2022 21:46:19 -0500
Message-Id: <20220118024701.1952911-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index a794f9e5f9908..b88aa1feb7df2 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -367,10 +367,16 @@ static struct saa7146_ext_vv vv_data;
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

