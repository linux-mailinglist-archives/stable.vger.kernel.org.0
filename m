Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F111B0ABC
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgDTMug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728836AbgDTMtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:49:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB8E320747;
        Mon, 20 Apr 2020 12:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386955;
        bh=CYFVsBxgywRzUEvwk2dikz2au/dAN3WcLNWOf1HanAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZiNPXXuEX8OM5NnN1sRrLWXHhTYW+C3AGa2prJcsAKbWPVc4t5pi3RkyK4li74C5
         Cmk2Y+cFix9DtEc6qrQqFK8g0/jzSIIyojKhR3cdCVQgzywp4sb7hwED4RTXckBg9j
         SHvQDPdAqH9lCDTpg63FY2iIn05tqSmnfyC9Cwu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.19 34/40] x86/resctrl: Fix invalid attempt at removing the default resource group
Date:   Mon, 20 Apr 2020 14:39:44 +0200
Message-Id: <20200420121505.792530801@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121444.178150063@linuxfoundation.org>
References: <20200420121444.178150063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reinette Chatre <reinette.chatre@intel.com>

commit b0151da52a6d4f3951ea24c083e7a95977621436 upstream.

The default resource group ("rdtgroup_default") is associated with the
root of the resctrl filesystem and should never be removed. New resource
groups can be created as subdirectories of the resctrl filesystem and
they can be removed from user space.

There exists a safeguard in the directory removal code
(rdtgroup_rmdir()) that ensures that only subdirectories can be removed
by testing that the directory to be removed has to be a child of the
root directory.

A possible deadlock was recently fixed with

  334b0f4e9b1b ("x86/resctrl: Fix a deadlock due to inaccurate reference").

This fix involved associating the private data of the "mon_groups"
and "mon_data" directories to the resource group to which they belong
instead of NULL as before. A consequence of this change was that
the original safeguard code preventing removal of "mon_groups" and
"mon_data" found in the root directory failed resulting in attempts to
remove the default resource group that ends in a BUG:

  kernel BUG at mm/slub.c:3969!
  invalid opcode: 0000 [#1] SMP PTI

  Call Trace:
  rdtgroup_rmdir+0x16b/0x2c0
  kernfs_iop_rmdir+0x5c/0x90
  vfs_rmdir+0x7a/0x160
  do_rmdir+0x17d/0x1e0
  do_syscall_64+0x55/0x1d0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by improving the directory removal safeguard to ensure that
subdirectories of the resctrl root directory can only be removed if they
are a child of the resctrl filesystem's root _and_ not associated with
the default resource group.

Fixes: 334b0f4e9b1b ("x86/resctrl: Fix a deadlock due to inaccurate reference")
Reported-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/884cbe1773496b5dbec1b6bd11bb50cffa83603d.1584461853.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
+++ b/arch/x86/kernel/cpu/intel_rdt_rdtgroup.c
@@ -2923,7 +2923,8 @@ static int rdtgroup_rmdir(struct kernfs_
 	 * If the rdtgroup is a mon group and parent directory
 	 * is a valid "mon_groups" directory, remove the mon group.
 	 */
-	if (rdtgrp->type == RDTCTRL_GROUP && parent_kn == rdtgroup_default.kn) {
+	if (rdtgrp->type == RDTCTRL_GROUP && parent_kn == rdtgroup_default.kn &&
+	    rdtgrp != &rdtgroup_default) {
 		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
 			ret = rdtgroup_ctrl_remove(kn, rdtgrp);


