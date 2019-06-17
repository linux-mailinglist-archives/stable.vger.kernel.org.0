Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32A74937D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfFQV3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730368AbfFQV3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:29:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1CC9204FD;
        Mon, 17 Jun 2019 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806943;
        bh=yv8DkqJKU8fMiKq+QS+HdTSIP2OK3r2/FzT0dXNjYZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZIa19YS/shfdaqDH7A2sVuMhYZmaG8+m3NNGHpPWnHEsb4+hgqE5yNogylcEgNiZ
         sja/Kf9h8/PcBkSMrwgm/Jw43yI4bWWyODsXjj0MqFv000ap0c2uwk/h79oXYRYr2V
         Gi33AahHeQsiV0XLiW7pNmVjKOAzGLdzewaEi3jQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Qian Cai <cai@lca.pw>, Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/53] libnvdimm: Fix compilation warnings with W=1
Date:   Mon, 17 Jun 2019 23:10:19 +0200
Message-Id: <20190617210751.496808847@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index a6746a1f20ae..2f1b54fab399 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -608,7 +608,7 @@ static struct attribute *nd_device_attributes[] = {
 	NULL,
 };
 
-/**
+/*
  * nd_device_attribute_group - generic attributes for all devices on an nd bus
  */
 struct attribute_group nd_device_attribute_group = {
@@ -637,7 +637,7 @@ static umode_t nd_numa_attr_visible(struct kobject *kobj, struct attribute *a,
 	return a->mode;
 }
 
-/**
+/*
  * nd_numa_attribute_group - NUMA attributes for all devices on an nd bus
  */
 struct attribute_group nd_numa_attribute_group = {
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 6a16017cc0d9..1fb3a2491131 100644
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
index 1ebf4d3d01ba..9ed772db6900 100644
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



