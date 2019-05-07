Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7981815D08
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEGFcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:32:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfEGFcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:32:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB2A921019;
        Tue,  7 May 2019 05:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207164;
        bh=k23acjIjh5iGl+y92pyfvh2F36MiK+QoAsbM8KP7lkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryVV9cLzUYmRSUZWZ1yjXXE99JmOJkRFcCjuIrj9vIImpIN0HBkq7hyDQyqc6vKDl
         blP4CfccQwD2xS/ucRCcCMny9InVXvVFaFmDCoWpOOeYu5tTaLND/Ef5qpTFTzeMwS
         x5OH1SrQJq7yKD6uRSlSs3jigQB7GadmBaCLypWs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 5.0 05/99] libnvdimm/namespace: Fix a potential NULL pointer dereference
Date:   Tue,  7 May 2019 01:30:59 -0400
Message-Id: <20190507053235.29900-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 55c1fc0af29a6c1b92f217b7eb7581a882e0c07c ]

In case kmemdup fails, the fix goes to blk_err to avoid NULL
pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/namespace_devs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 33a3b23b3db7..e761b29f7160 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2249,9 +2249,12 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
 	if (!nsblk->uuid)
 		goto blk_err;
 	memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
-	if (name[0])
+	if (name[0]) {
 		nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN,
 				GFP_KERNEL);
+		if (!nsblk->alt_name)
+			goto blk_err;
+	}
 	res = nsblk_add_resource(nd_region, ndd, nsblk,
 			__le64_to_cpu(nd_label->dpa));
 	if (!res)
-- 
2.20.1

