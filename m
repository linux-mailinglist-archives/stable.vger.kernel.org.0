Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06C12EE52
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732180AbfE3DqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731091AbfE3DUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:40 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 046F124949;
        Thu, 30 May 2019 03:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186439;
        bh=ILGA3zVDJDnQ89yGop1ParMwPXiEFFM0cHZr7j3Ovwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKEPnpFWgd2QZu7giYippRcmej+WUMUk/udzg8YHqJ3rFKRBHf6Whg/Dp3wHgt/Ue
         8KiFgxRP4+tdycfxlDYGXpY0WMGOqf5y12VR5H1PTiqVpSYV+vrioy0CwvT7stYwBz
         7mXRHdFYGYA61ccaPhFPVHvzGFAUo061NMwKkYmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Erwin Tsaur <erwin.tsaur@oracle.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4.9 007/128] libnvdimm/namespace: Fix label tracking error
Date:   Wed, 29 May 2019 20:05:39 -0700
Message-Id: <20190530030434.566971238@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit c4703ce11c23423d4b46e3d59aef7979814fd608 upstream.

Users have reported intermittent occurrences of DIMM initialization
failures due to duplicate allocations of address capacity detected in
the labels, or errors of the form below, both have the same root cause.

    nd namespace1.4: failed to track label: 0
    WARNING: CPU: 17 PID: 1381 at drivers/nvdimm/label.c:863

    RIP: 0010:__pmem_label_update+0x56c/0x590 [libnvdimm]
    Call Trace:
     ? nd_pmem_namespace_label_update+0xd6/0x160 [libnvdimm]
     nd_pmem_namespace_label_update+0xd6/0x160 [libnvdimm]
     uuid_store+0x17e/0x190 [libnvdimm]
     kernfs_fop_write+0xf0/0x1a0
     vfs_write+0xb7/0x1b0
     ksys_write+0x57/0xd0
     do_syscall_64+0x60/0x210

Unfortunately those reports were typically with a busy parallel
namespace creation / destruction loop making it difficult to see the
components of the bug. However, Jane provided a simple reproducer using
the work-in-progress sub-section implementation.

When ndctl is reconfiguring a namespace it may take an existing defunct
/ disabled namespace and reconfigure it with a new uuid and other
parameters. Critically namespace_update_uuid() takes existing address
resources and renames them for the new namespace to use / reconfigure as
it sees fit. The bug is that this rename only happens in the resource
tracking tree. Existing labels with the old uuid are not reaped leading
to a scenario where multiple active labels reference the same span of
address range.

Teach namespace_update_uuid() to flag any references to the old uuid for
reaping at the next label update attempt.

Cc: <stable@vger.kernel.org>
Fixes: bf9bccc14c05 ("libnvdimm: pmem label sets and namespace instantiation")
Link: https://github.com/pmem/ndctl/issues/91
Reported-by: Jane Chu <jane.chu@oracle.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Erwin Tsaur <erwin.tsaur@oracle.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/nvdimm/label.c          |   29 ++++++++++++++++-------------
 drivers/nvdimm/namespace_devs.c |   15 +++++++++++++++
 drivers/nvdimm/nd.h             |    4 ++++
 3 files changed, 35 insertions(+), 13 deletions(-)

--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -490,15 +490,26 @@ static unsigned long nd_label_offset(str
 		- (unsigned long) to_namespace_index(ndd, 0);
 }
 
+static void reap_victim(struct nd_mapping *nd_mapping,
+		struct nd_label_ent *victim)
+{
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	u32 slot = to_slot(ndd, victim->label);
+
+	dev_dbg(ndd->dev, "free: %d\n", slot);
+	nd_label_free_slot(ndd, slot);
+	victim->label = NULL;
+}
+
 static int __pmem_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
 		int pos, unsigned long flags)
 {
 	u64 cookie = nd_region_interleave_set_cookie(nd_region);
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_label_ent *label_ent, *victim = NULL;
 	struct nd_namespace_label *nd_label;
 	struct nd_namespace_index *nsindex;
+	struct nd_label_ent *label_ent;
 	struct nd_label_id label_id;
 	struct resource *res;
 	unsigned long *free;
@@ -551,18 +562,10 @@ static int __pmem_label_update(struct nd
 	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 		if (!label_ent->label)
 			continue;
-		if (memcmp(nspm->uuid, label_ent->label->uuid,
-					NSLABEL_UUID_LEN) != 0)
-			continue;
-		victim = label_ent;
-		list_move_tail(&victim->list, &nd_mapping->labels);
-		break;
-	}
-	if (victim) {
-		dev_dbg(ndd->dev, "%s: free: %d\n", __func__, slot);
-		slot = to_slot(ndd, victim->label);
-		nd_label_free_slot(ndd, slot);
-		victim->label = NULL;
+		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags)
+				|| memcmp(nspm->uuid, label_ent->label->uuid,
+					NSLABEL_UUID_LEN) == 0)
+			reap_victim(nd_mapping, label_ent);
 	}
 
 	/* update index */
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1210,12 +1210,27 @@ static int namespace_update_uuid(struct
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		struct nd_label_ent *label_ent;
 		struct resource *res;
 
 		for_each_dpa_resource(ndd, res)
 			if (strcmp(res->name, old_label_id.id) == 0)
 				sprintf((void *) res->name, "%s",
 						new_label_id.id);
+
+		mutex_lock(&nd_mapping->lock);
+		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+			struct nd_namespace_label *nd_label = label_ent->label;
+			struct nd_label_id label_id;
+
+			if (!nd_label)
+				continue;
+			nd_label_gen_id(&label_id, nd_label->uuid,
+					__le32_to_cpu(nd_label->flags));
+			if (strcmp(old_label_id.id, label_id.id) == 0)
+				set_bit(ND_LABEL_REAP, &label_ent->flags);
+		}
+		mutex_unlock(&nd_mapping->lock);
 	}
 	kfree(*old_uuid);
  out:
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -113,8 +113,12 @@ struct nd_percpu_lane {
 	spinlock_t lock;
 };
 
+enum nd_label_flags {
+	ND_LABEL_REAP,
+};
 struct nd_label_ent {
 	struct list_head list;
+	unsigned long flags;
 	struct nd_namespace_label *label;
 };
 


