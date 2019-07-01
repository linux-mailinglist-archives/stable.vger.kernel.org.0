Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777D32368A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388136AbfETMqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388938AbfETMY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:24:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67D2220645;
        Mon, 20 May 2019 12:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355097;
        bh=u1Z1DG+dfw+neeh9hLZCBqpazPFnvD8rEFLVjWvGUbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mKC1EmBHni9a01SHU2OQ54lwRS7dhZAuyVdw1iAqP1E4AxS0bdNr9QW7Dhg9v5ksw
         ceUnONcZmiDJIE8guZcxVC7n2C88Mz4aaPVqRmlqxHgH45mxaZkqqdPdccBIwFmA0k
         zfjE8CijrLdY/I6NPugwCH81Gv1/3Pir4+q55rlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jane Chu <jane.chu@oracle.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Erwin Tsaur <erwin.tsaur@oracle.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4.19 097/105] libnvdimm/namespace: Fix label tracking error
Date:   Mon, 20 May 2019 14:14:43 +0200
Message-Id: <20190520115253.930121417@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
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
@@ -623,6 +623,17 @@ static const guid_t *to_abstraction_guid
 		return &guid_null;
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
@@ -630,9 +641,9 @@ static int __pmem_label_update(struct nd
 	struct nd_namespace_common *ndns = &nspm->nsio.common;
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_label_ent *label_ent, *victim = NULL;
 	struct nd_namespace_label *nd_label;
 	struct nd_namespace_index *nsindex;
+	struct nd_label_ent *label_ent;
 	struct nd_label_id label_id;
 	struct resource *res;
 	unsigned long *free;
@@ -701,18 +712,10 @@ static int __pmem_label_update(struct nd
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
-		dev_dbg(ndd->dev, "free: %d\n", slot);
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
@@ -1248,12 +1248,27 @@ static int namespace_update_uuid(struct
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
 


