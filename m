Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0966A20E6DF
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732927AbgF2Vva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgF2Sfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B463F2478A;
        Mon, 29 Jun 2020 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444095;
        bh=CEb9o2yL5eEnwlfJtCGk5Cdd+bLozxsyRisthU6Vmsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qaI7LPFVhNFkUEpWNdD82O+Rm4inYFouZxto82BSnMuDBosRkmqcxqX5aHJ/5m+ho
         h5Tp92dbqb4BPugllruFoUxUbrcLCPTZt0Wd0EdC+nJsA5SvFQ8E9ux+Ky/cLMlSxx
         G3RvA9gtBQiY7GTtDjc4JOWaIvOoN1frAIA/K04c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 205/265] nvdimm/region: always show the 'align' attribute
Date:   Mon, 29 Jun 2020 11:17:18 -0400
Message-Id: <20200629151818.2493727-206-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit 543094e19c82b5d171e139d09a1a3ea0a7361117 ]

It is possible that a platform that is capable of 'namespace labels'
comes up without the labels properly initialized. In this case, the
region's 'align' attribute is hidden. Howerver, once the user does
initialize he labels, the 'align' attribute still stays hidden, which is
unexpected.

The sysfs_update_group() API is meant to address this, and could be
called during region probe, but it has entanglements with the device
'lockdep_mutex'. Therefore, simply make the 'align' attribute always
visible. It doesn't matter what it says for label-less namespaces, since
it is not possible to change their allocation anyway.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/20200520225026.29426-1-vishal.l.verma@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/region_devs.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index ccbb5b43b8b2c..4502f9c4708d0 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -679,18 +679,8 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 		return a->mode;
 	}
 
-	if (a == &dev_attr_align.attr) {
-		int i;
-
-		for (i = 0; i < nd_region->ndr_mappings; i++) {
-			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-			struct nvdimm *nvdimm = nd_mapping->nvdimm;
-
-			if (test_bit(NDD_LABELING, &nvdimm->flags))
-				return a->mode;
-		}
-		return 0;
-	}
+	if (a == &dev_attr_align.attr)
+		return a->mode;
 
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
-- 
2.25.1

