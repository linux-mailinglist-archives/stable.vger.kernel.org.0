Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB0FA61105E
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiJ1MEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJ1MEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:04:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D24C13D10
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16DA8B829A6
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762CDC433C1;
        Fri, 28 Oct 2022 12:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958676;
        bh=Q5ot/Wyj7o/rmkQOaFcpbdB7JEysf9GXn2sQlz2bfIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2RQ0MotPzhKqNdqqrcGRh+RnPet6sLM7YQOW9C3sSwKZjO1evPIc6DMdCqjkR6DU
         5cmmCCt9k2i8DbnqMphKBi0QZXz7otKEITqYs2G1YFb2E4l0YelMDj9oVSthln6Kts
         zlF21F94BONCE9/SVkQ3DbcLnIxbI7eo80Rj7Yt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tan Ninghao <tanninghao1@huawei.com>,
        "GONG, Ruiqi" <gongruiqi1@huawei.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Paul Moore <paul@paul-moore.com>, GONG@vger.kernel.org
Subject: [PATCH 5.10 03/73] selinux: enable use of both GFP_KERNEL and GFP_ATOMIC in convert_context()
Date:   Fri, 28 Oct 2022 14:03:00 +0200
Message-Id: <20221028120232.517023698@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: GONG, Ruiqi <gongruiqi1@huawei.com>

commit abe3c631447dcd1ba7af972fe6f054bee6f136fa upstream.

The following warning was triggered on a hardware environment:

  SELinux: Converting 162 SID table entries...
  BUG: sleeping function called from invalid context at
       __might_sleep+0x60/0x74 0x0
  in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 5943, name: tar
  CPU: 7 PID: 5943 Comm: tar Tainted: P O 5.10.0 #1
  Call trace:
   dump_backtrace+0x0/0x1c8
   show_stack+0x18/0x28
   dump_stack+0xe8/0x15c
   ___might_sleep+0x168/0x17c
   __might_sleep+0x60/0x74
   __kmalloc_track_caller+0xa0/0x7dc
   kstrdup+0x54/0xac
   convert_context+0x48/0x2e4
   sidtab_context_to_sid+0x1c4/0x36c
   security_context_to_sid_core+0x168/0x238
   security_context_to_sid_default+0x14/0x24
   inode_doinit_use_xattr+0x164/0x1e4
   inode_doinit_with_dentry+0x1c0/0x488
   selinux_d_instantiate+0x20/0x34
   security_d_instantiate+0x70/0xbc
   d_splice_alias+0x4c/0x3c0
   ext4_lookup+0x1d8/0x200 [ext4]
   __lookup_slow+0x12c/0x1e4
   walk_component+0x100/0x200
   path_lookupat+0x88/0x118
   filename_lookup+0x98/0x130
   user_path_at_empty+0x48/0x60
   vfs_statx+0x84/0x140
   vfs_fstatat+0x20/0x30
   __se_sys_newfstatat+0x30/0x74
   __arm64_sys_newfstatat+0x1c/0x2c
   el0_svc_common.constprop.0+0x100/0x184
   do_el0_svc+0x1c/0x2c
   el0_svc+0x20/0x34
   el0_sync_handler+0x80/0x17c
   el0_sync+0x13c/0x140
  SELinux: Context system_u:object_r:pssp_rsyslog_log_t:s0:c0 is
           not valid (left unmapped).

It was found that within a critical section of spin_lock_irqsave in
sidtab_context_to_sid(), convert_context() (hooked by
sidtab_convert_params.func) might cause the process to sleep via
allocating memory with GFP_KERNEL, which is problematic.

As Ondrej pointed out [1], convert_context()/sidtab_convert_params.func
has another caller sidtab_convert_tree(), which is okay with GFP_KERNEL.
Therefore, fix this problem by adding a gfp_t argument for
convert_context()/sidtab_convert_params.func and pass GFP_KERNEL/_ATOMIC
properly in individual callers.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20221018120111.1474581-1-gongruiqi1@huawei.com/ [1]
Reported-by: Tan Ninghao <tanninghao1@huawei.com>
Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
[PM: wrap long BUG() output lines, tweak subject line]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/ss/services.c |    5 +++--
 security/selinux/ss/sidtab.c   |    4 ++--
 security/selinux/ss/sidtab.h   |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2011,7 +2011,8 @@ static inline int convert_context_handle
  * in `newc'.  Verify that the context is valid
  * under the new policy.
  */
-static int convert_context(struct context *oldc, struct context *newc, void *p)
+static int convert_context(struct context *oldc, struct context *newc, void *p,
+			   gfp_t gfp_flags)
 {
 	struct convert_context_args *args;
 	struct ocontext *oc;
@@ -2025,7 +2026,7 @@ static int convert_context(struct contex
 	args = p;
 
 	if (oldc->str) {
-		s = kstrdup(oldc->str, GFP_KERNEL);
+		s = kstrdup(oldc->str, gfp_flags);
 		if (!s)
 			return -ENOMEM;
 
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -325,7 +325,7 @@ int sidtab_context_to_sid(struct sidtab
 		}
 
 		rc = convert->func(context, &dst_convert->context,
-				   convert->args);
+				   convert->args, GFP_ATOMIC);
 		if (rc) {
 			context_destroy(&dst->context);
 			goto out_unlock;
@@ -404,7 +404,7 @@ static int sidtab_convert_tree(union sid
 		while (i < SIDTAB_LEAF_ENTRIES && *pos < count) {
 			rc = convert->func(&esrc->ptr_leaf->entries[i].context,
 					   &edst->ptr_leaf->entries[i].context,
-					   convert->args);
+					   convert->args, GFP_KERNEL);
 			if (rc)
 				return rc;
 			(*pos)++;
--- a/security/selinux/ss/sidtab.h
+++ b/security/selinux/ss/sidtab.h
@@ -65,7 +65,7 @@ struct sidtab_isid_entry {
 };
 
 struct sidtab_convert_params {
-	int (*func)(struct context *oldc, struct context *newc, void *args);
+	int (*func)(struct context *oldc, struct context *newc, void *args, gfp_t gfp_flags);
 	void *args;
 	struct sidtab *target;
 };


