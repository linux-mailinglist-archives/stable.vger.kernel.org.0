Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889361CAD03
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgEHMy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730211AbgEHMy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CF822054F;
        Fri,  8 May 2020 12:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942465;
        bh=nfiwwpDz/de7q+n6W8S3wgYmXpKZ5Q6kBvbCxOI4mBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lA0GXtmhCX/5RDV581hrr9H0OWDfGRjMIGYgu4xu+sMJRw5ybBJZCX16nRi3ezN2k
         +rbjSCdDjMXH3zPLDqkK8NLFOMr0pD27ewNHF4y+VaT9YSpiqc7ouvBVu5fPKeN62J
         SbHs4MtwiMGUvs0ZxfQf+Beky4+JqF5KBWWonzSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heidi Fahim <heidifahim@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 33/50] Revert "software node: Simplify software_node_release() function"
Date:   Fri,  8 May 2020 14:35:39 +0200
Message-Id: <20200508123048.021195543@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

commit 7589238a8cf37331607c3222a64ac3140b29532d upstream.

This reverts commit 3df85a1ae51f6b256982fe9d17c2dc5bfb4cc402.

The reverted commit says "It's possible to release the node ID
immediately when fwnode_remove_software_node() is called, no need to
wait for software_node_release() with that." However, releasing the node
ID before waiting for software_node_release() to be called causes the
node ID to be released before the kobject and the underlying sysfs
entry; this means there is a period of time where a sysfs entry exists
that is associated with an unallocated node ID.

Once consequence of this is that there is a race condition where it is
possible to call fwnode_create_software_node() with no parent node
specified (NULL) and have it fail with -EEXIST because the node ID that
was assigned is still associated with a stale sysfs entry that hasn't
been cleaned up yet.

Although it is difficult to reproduce this race condition under normal
conditions, it can be deterministically reproduced with the following
minconfig on UML:

CONFIG_KUNIT_DRIVER_PE_TEST=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_KUNIT=y

Running the tests with this configuration causes the following failure:

<snip>
kobject: 'node0' ((____ptrval____)): kobject_release, parent (____ptrval____) (delayed 400)
	ok 1 - pe_test_uints
sysfs: cannot create duplicate filename '/kernel/software_nodes/node0'
CPU: 0 PID: 28 Comm: kunit_try_catch Not tainted 5.6.0-rc3-next-20200227 #14
<snip>
kobject_add_internal failed for node0 with -EEXIST, don't try to register things with the same name in the same directory.
kobject: 'node0' ((____ptrval____)): kobject_release, parent (____ptrval____) (delayed 100)
	# pe_test_uint_arrays: ASSERTION FAILED at drivers/base/test/property-entry-test.c:123
	Expected node is not error, but is: -17
	not ok 2 - pe_test_uint_arrays
<snip>

Reported-by: Heidi Fahim <heidifahim@google.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/swnode.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -679,6 +679,13 @@ static void software_node_release(struct
 {
 	struct swnode *swnode = kobj_to_swnode(kobj);
 
+	if (swnode->parent) {
+		ida_simple_remove(&swnode->parent->child_ids, swnode->id);
+		list_del(&swnode->entry);
+	} else {
+		ida_simple_remove(&swnode_root_ids, swnode->id);
+	}
+
 	if (swnode->allocated) {
 		property_entries_free(swnode->node->properties);
 		kfree(swnode->node);
@@ -844,13 +851,6 @@ void fwnode_remove_software_node(struct
 	if (!swnode)
 		return;
 
-	if (swnode->parent) {
-		ida_simple_remove(&swnode->parent->child_ids, swnode->id);
-		list_del(&swnode->entry);
-	} else {
-		ida_simple_remove(&swnode_root_ids, swnode->id);
-	}
-
 	kobject_put(&swnode->kobj);
 }
 EXPORT_SYMBOL_GPL(fwnode_remove_software_node);


