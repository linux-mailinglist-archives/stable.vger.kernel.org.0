Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C55FF693DF
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404374AbfGOOrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405203AbfGOOrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:47:36 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA0442067C;
        Mon, 15 Jul 2019 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563202055;
        bh=i0PFZkIJ9nL0kFh10gLhFccdUQZCEye8EhDIlvNLGXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLfA9Y4vNoXMtp/8zVuGa1XRbctmD7di+g+EgiFO+8OF0kKg3QZHJHFkyVKtfbGZJ
         jC2z7zauY2hUso/rkR5Enhs2G/wLXlmcmoLCqDEMpwvMZo989wDko+AZB+Wlh8dilX
         /+ogs29b9ASKg9fmyWHTbvTUzkL6x3c2AbSZfGJo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 34/53] EDAC/sysfs: Fix memory leak when creating a csrow object
Date:   Mon, 15 Jul 2019 10:45:16 -0400
Message-Id: <20190715144535.11636-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

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
index 3c8f19f5ac81..0c53f2d54765 100644
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

