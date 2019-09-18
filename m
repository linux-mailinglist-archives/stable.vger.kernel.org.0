Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9D4B5C50
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfIRGZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729997AbfIRGZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BCF021D80;
        Wed, 18 Sep 2019 06:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787906;
        bh=uaWqzottywCvur15Rkxvw7jfkwGA/KMVx4+phqc5MdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojK2sygNCFzMyOKQIGhqoHkjG7GoQO9jy4FWcnCp8zNHrcS0TNBwk5L8vk5ILS2fJ
         cpSpXWp9cCLzOORSMIPcZaLxxxCbby68po/RXDZpAS48htPl/kb82uZz5SPDJkHVOq
         YM6hyClgLRgMfZO9I+6OX51wveicG64mqamPDIaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Crossen <mcrossen@fb.com>,
        Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.2 27/85] cgroup: freezer: fix frozen state inheritance
Date:   Wed, 18 Sep 2019 08:18:45 +0200
Message-Id: <20190918061235.017112205@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit 97a61369830ab085df5aed0ff9256f35b07d425a upstream.

If a new child cgroup is created in the frozen cgroup hierarchy
(one or more of ancestor cgroups is frozen), the CGRP_FREEZE cgroup
flag should be set. Otherwise if a process will be attached to the
child cgroup, it won't become frozen.

The problem can be reproduced with the test_cgfreezer_mkdir test.

This is the output before this patch:
  ~/test_freezer
  ok 1 test_cgfreezer_simple
  ok 2 test_cgfreezer_tree
  ok 3 test_cgfreezer_forkbomb
  Cgroup /sys/fs/cgroup/cg_test_mkdir_A/cg_test_mkdir_B isn't frozen
  not ok 4 test_cgfreezer_mkdir
  ok 5 test_cgfreezer_rmdir
  ok 6 test_cgfreezer_migrate
  ok 7 test_cgfreezer_ptrace
  ok 8 test_cgfreezer_stopped
  ok 9 test_cgfreezer_ptraced
  ok 10 test_cgfreezer_vfork

And with this patch:
  ~/test_freezer
  ok 1 test_cgfreezer_simple
  ok 2 test_cgfreezer_tree
  ok 3 test_cgfreezer_forkbomb
  ok 4 test_cgfreezer_mkdir
  ok 5 test_cgfreezer_rmdir
  ok 6 test_cgfreezer_migrate
  ok 7 test_cgfreezer_ptrace
  ok 8 test_cgfreezer_stopped
  ok 9 test_cgfreezer_ptraced
  ok 10 test_cgfreezer_vfork

Reported-by: Mark Crossen <mcrossen@fb.com>
Signed-off-by: Roman Gushchin <guro@fb.com>
Fixes: 76f969e8948d ("cgroup: cgroup v2 freezer")
Cc: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5213,8 +5213,16 @@ static struct cgroup *cgroup_create(stru
 	 * if the parent has to be frozen, the child has too.
 	 */
 	cgrp->freezer.e_freeze = parent->freezer.e_freeze;
-	if (cgrp->freezer.e_freeze)
+	if (cgrp->freezer.e_freeze) {
+		/*
+		 * Set the CGRP_FREEZE flag, so when a process will be
+		 * attached to the child cgroup, it will become frozen.
+		 * At this point the new cgroup is unpopulated, so we can
+		 * consider it frozen immediately.
+		 */
+		set_bit(CGRP_FREEZE, &cgrp->flags);
 		set_bit(CGRP_FROZEN, &cgrp->flags);
+	}
 
 	spin_lock_irq(&css_set_lock);
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp)) {


