Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC674988BB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245483AbiAXSuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245479AbiAXStZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:49:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D95C061762;
        Mon, 24 Jan 2022 10:49:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9450614D5;
        Mon, 24 Jan 2022 18:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97079C340E5;
        Mon, 24 Jan 2022 18:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050164;
        bh=I5LwytMph0R/5LpJof8AntKK3LVkEsBvnCH9TCu9nQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHj1u4zp/KXsd/JMYHPuDE1C1W2C5rfeOIyqu/ypoK4ewfaCyUNgXVVXXIWJT3Uze
         5UaSGTVFAW3DI1n/vYRn33DVOl4eeYg963ydZiNC4F5y2Mc//n2lqyxsN5DA+fFaes
         d1MZgKbc887b9xPRc/wS5ATq+GesoG3J/oUrmGpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 031/114] media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()
Date:   Mon, 24 Jan 2022 19:42:06 +0100
Message-Id: <20220124183928.081898439@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
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
index 868af73c5536a..56691a79ef08f 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -694,10 +694,16 @@ static struct saa7146_ext_vv vv_data;
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



