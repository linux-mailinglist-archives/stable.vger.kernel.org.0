Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7863B498F9B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351737AbiAXTxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:53:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38688 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356754AbiAXTt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:49:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8267DB8121A;
        Mon, 24 Jan 2022 19:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B83FC340E5;
        Mon, 24 Jan 2022 19:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053763;
        bh=awbqRVaIUfFP7Xv7D24AO89VIJbRkobad3YVxWh0VP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HO7PeqamNdX1ocAGL7wOB66aa9B8a6LaEWihrdvhNkjCrAbS9Ak/F22G/lyabDCNW
         McRzimx6rZYgM3Pj/OXp5qnbCO+FKkEM3qB4rWaN525BjuTGGo99tG00ut/HFwAqMD
         G63cb9YP/YKjx0v4kQcvpF5gKusAkELBNe+4F1bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 142/563] media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()
Date:   Mon, 24 Jan 2022 19:38:27 +0100
Message-Id: <20220124184029.315256898@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit 0407c49ebe330333478440157c640fffd986f41b ]

In mxb_attach(dev, info), saa7146_vv_init() is called to allocate a
new memory for dev->vv_data. saa7146_vv_release() will be called on
failure of mxb_probe(dev). There is a dereference of dev->vv_data
in saa7146_vv_release(), which could lead to a NULL pointer dereference
on failure of saa7146_vv_init().

Fix this bug by adding a check of saa7146_vv_init().

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_VIDEO_MXB=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 03b1930efd3c ("V4L/DVB: saa7146: fix regression of the av7110/budget-av driver")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7146/mxb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 73fc901ecf3db..bf0b9b0914cd5 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -683,10 +683,16 @@ static struct saa7146_ext_vv vv_data;
 static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
 {
 	struct mxb *mxb;
+	int ret;
 
 	DEB_EE("dev:%p\n", dev);
 
-	saa7146_vv_init(dev, &vv_data);
+	ret = saa7146_vv_init(dev, &vv_data);
+	if (ret) {
+		ERR("Error in saa7146_vv_init()");
+		return ret;
+	}
+
 	if (mxb_probe(dev)) {
 		saa7146_vv_release(dev);
 		return -1;
-- 
2.34.1



