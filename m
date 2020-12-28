Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1BA2E3C22
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407548AbgL1N7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:59:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:32768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407540AbgL1N7A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E3020791;
        Mon, 28 Dec 2020 13:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163899;
        bh=bFujeQTmkX8voB3Hyv3mHFA2PPAjBxbnp9aIl6G7r7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5VDJoQdYJu9SYy3LTOuiD8ZagmmANyi5AOJWPVSH6HHFJqdP+Pv+lYTb1cpdlxnL
         L0U7Np4TwXXhA0/woJBteR7JNLqbZvqsDmv3kN4RAqpuHeNzr+YOq5cHUBD6C6ruho
         O0yGqVE0gQ8kiZtQocZnXnm2LR/PvV8Dd8wpP2RQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.4 448/453] libnvdimm/namespace: Fix reaping of invalidated block-window-namespace labels
Date:   Mon, 28 Dec 2020 13:51:24 +0100
Message-Id: <20201228124958.779418264@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 2dd2a1740ee19cd2636d247276cf27bfa434b0e2 upstream.

A recent change to ndctl to attempt to reconfigure namespaces in place
uncovered a label accounting problem in block-window-type namespaces.
The ndctl "create.sh" test is able to trigger this signature:

 WARNING: CPU: 34 PID: 9167 at drivers/nvdimm/label.c:1100 __blk_label_update+0x9a3/0xbc0 [libnvdimm]
 [..]
 RIP: 0010:__blk_label_update+0x9a3/0xbc0 [libnvdimm]
 [..]
 Call Trace:
  uuid_store+0x21b/0x2f0 [libnvdimm]
  kernfs_fop_write+0xcf/0x1c0
  vfs_write+0xcc/0x380
  ksys_write+0x68/0xe0

When allocated capacity for a namespace is renamed (new UUID) the labels
with the old UUID need to be deleted. The ndctl behavior to always
destroy namespaces on reconfiguration hid this problem.

The immediate impact of this bug is limited since block-window-type
namespaces only seem to exist in the specification and not in any
shipping products. However, the label handling code is being reused for
other technologies like CXL region labels, so there is a benefit to
making sure both vertical labels sets (block-window) and horizontal
label sets (pmem) have a functional reference implementation in
libnvdimm.

Fixes: c4703ce11c23 ("libnvdimm/namespace: Fix label tracking error")
Cc: <stable@vger.kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvdimm/label.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -980,6 +980,15 @@ static int __blk_label_update(struct nd_
 		}
 	}
 
+	/* release slots associated with any invalidated UUIDs */
+	mutex_lock(&nd_mapping->lock);
+	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list)
+		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags)) {
+			reap_victim(nd_mapping, label_ent);
+			list_move(&label_ent->list, &list);
+		}
+	mutex_unlock(&nd_mapping->lock);
+
 	/*
 	 * Find the resource associated with the first label in the set
 	 * per the v1.2 namespace specification.


