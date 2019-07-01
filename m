Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9FA735327
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfFDXXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727243AbfFDXXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:23:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F072085A;
        Tue,  4 Jun 2019 23:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690592;
        bh=+uGVSRxiHr5o1FYiBVBJnVahe5gpBP6cGkhq0E5848w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=azpzMoqs4Zbvc4GFAPmeRctAGJdoqHt5lVEz0hOZ5hN+pBm10/jlJ+zSt1Nyo6jUv
         LnNdtfhpbssXgJYBCkY48P9d4DZvHcWH03QvZY9MhW7e4PN8Uml7T5Ha8wm4e0rRyX
         PkICYTGLloAdKXS8kF7xQwFuhliNXtj6bBPTns1c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvdimm@lists.01.org
Subject: [PATCH AUTOSEL 5.1 39/60] libnvdimm: Fix compilation warnings with W=1
Date:   Tue,  4 Jun 2019 19:21:49 -0400
Message-Id: <20190604232212.6753-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit c01dafad77fea8d64c4fdca0a6031c980842ad65 ]

Several places (dimm_devs.c, core.c etc) include label.h but only
label.c uses NSINDEX_SIGNATURE, so move its definition to label.c
instead.

In file included from drivers/nvdimm/dimm_devs.c:23:
drivers/nvdimm/label.h:41:19: warning: 'NSINDEX_SIGNATURE' defined but
not used [-Wunused-const-variable=]

Also, some places abuse "/**" which is only reserved for the kernel-doc.

drivers/nvdimm/bus.c:648: warning: cannot understand function prototype:
'struct attribute_group nd_device_attribute_group = '
drivers/nvdimm/bus.c:677: warning: cannot understand function prototype:
'struct attribute_group nd_numa_attribute_group = '

Those are just some member assignments for the "struct attribute_group"
instances and it can't be expressed in the kernel-doc.

Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/bus.c   | 4 ++--
 drivers/nvdimm/label.c | 2 ++
 drivers/nvdimm/label.h | 2 --
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 7bbff0af29b2..99d5892ea98a 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -642,7 +642,7 @@ static struct attribute *nd_device_attributes[] = {
 	NULL,
 };
 
-/**
+/*
  * nd_device_attribute_group - generic attributes for all devices on an nd bus
  */
 struct attribute_group nd_device_attribute_group = {
@@ -671,7 +671,7 @@ static umode_t nd_numa_attr_visible(struct kobject *kobj, struct attribute *a,
 	return a->mode;
 }
 
-/**
+/*
  * nd_numa_attribute_group - NUMA attributes for all devices on an nd bus
  */
 struct attribute_group nd_numa_attribute_group = {
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 2030805aa216..edf278067e72 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -25,6 +25,8 @@ static guid_t nvdimm_btt2_guid;
 static guid_t nvdimm_pfn_guid;
 static guid_t nvdimm_dax_guid;
 
+static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
+
 static u32 best_seq(u32 a, u32 b)
 {
 	a &= NSINDEX_SEQ_MASK;
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index e9a2ad3c2150..4bb7add39580 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -38,8 +38,6 @@ enum {
 	ND_NSINDEX_INIT = 0x1,
 };
 
-static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
-
 /**
  * struct nd_namespace_index - label set superblock
  * @sig: NAMESPACE_INDEX\0
-- 
2.20.1

