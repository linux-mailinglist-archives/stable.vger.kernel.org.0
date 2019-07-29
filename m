Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D9279956
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfG2T1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729886AbfG2T1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:27:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5A9F2171F;
        Mon, 29 Jul 2019 19:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428437;
        bh=WNEwlZmblCDELfMHFO9HduNW/EQ4DWBXMScy77tVMug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjyZQIsTvBSAD/RzUmU8a/S6Ho7dYKDS5hk07ej/oXK+ks1uJ6g10HCnt53ZyO7vT
         zOPJDv+wbFVXZI9fyqmE8efuYGG9cVpg1z2HibnbQG0wER8AMD5EYJl9gIqXJYZAs5
         RpibLLEWTW7dEy1MGB5tDMnu8RgcBv5lT31HrVCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Borislav Petkov <bp@suse.de>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/293] EDAC/sysfs: Fix memory leak when creating a csrow object
Date:   Mon, 29 Jul 2019 21:19:10 +0200
Message-Id: <20190729190828.825030264@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 585fb3d93d32dbe89e718b85009f9c322cc554cd ]

In edac_create_csrow_object(), the reference to the object is not
released when adding the device to the device hierarchy fails
(device_add()). This may result in a memory leak.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>
Link: https://lkml.kernel.org/r/1555554438-103953-1-git-send-email-bianpan2016@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/edac_mc_sysfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 79c13301bf41..148c4649b155 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -426,6 +426,8 @@ static inline int nr_pages_per_csrow(struct csrow_info *csrow)
 static int edac_create_csrow_object(struct mem_ctl_info *mci,
 				    struct csrow_info *csrow, int index)
 {
+	int err;
+
 	csrow->dev.type = &csrow_attr_type;
 	csrow->dev.bus = mci->bus;
 	csrow->dev.groups = csrow_dev_groups;
@@ -438,7 +440,11 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 	edac_dbg(0, "creating (virtual) csrow node %s\n",
 		 dev_name(&csrow->dev));
 
-	return device_add(&csrow->dev);
+	err = device_add(&csrow->dev);
+	if (err)
+		put_device(&csrow->dev);
+
+	return err;
 }
 
 /* Create a CSROW object under specifed edac_mc_device */
-- 
2.20.1



