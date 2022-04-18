Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E40505428
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbiDRNEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241609AbiDRNDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:03:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D88633A3B;
        Mon, 18 Apr 2022 05:43:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49108B80E4E;
        Mon, 18 Apr 2022 12:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D9CC385A1;
        Mon, 18 Apr 2022 12:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285834;
        bh=m6wrNkZWmg7a6xR1Fe3uV67ua/HPGqp18ze6bgN7Ofs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElkFRu/h0PD7F0pAbJVKGxKTHEr+Z3bMXWI6QueIuabPoJvJSyjpGn3eCMyI/8iAZ
         49D/1OMwoJa5ZDpE9CzchEgTRnLoe3VNxHlDTBYgmVPQk+iMCGksUDQo0wvHDS4UVj
         Uqi7iugQQS8zIczkw2NJiIsjJOSCLzjmec49KEqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.4 39/63] KVM: Dont create VM debugfs files outside of the VM directory
Date:   Mon, 18 Apr 2022 14:13:36 +0200
Message-Id: <20220418121136.835516666@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

commit a44a4cc1c969afec97dbb2aedaf6f38eaa6253bb upstream.

Unfortunately, there is no guarantee that KVM was able to instantiate a
debugfs directory for a particular VM. To that end, KVM shouldn't even
attempt to create new debugfs files in this case. If the specified
parent dentry is NULL, debugfs_create_file() will instantiate files at
the root of debugfs.

For arm64, it is possible to create the vgic-state file outside of a
VM directory, the file is not cleaned up when a VM is destroyed.
Nonetheless, the corresponding struct kvm is freed when the VM is
destroyed.

Nip the problem in the bud for all possible errant debugfs file
creations by initializing kvm->debugfs_dentry to -ENOENT. In so doing,
debugfs_create_file() will fail instead of creating the file in the root
directory.

Cc: stable@kernel.org
Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220406235615.1447180-2-oupton@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -623,7 +623,7 @@ static void kvm_destroy_vm_debugfs(struc
 {
 	int i;
 
-	if (!kvm->debugfs_dentry)
+	if (IS_ERR(kvm->debugfs_dentry))
 		return;
 
 	debugfs_remove_recursive(kvm->debugfs_dentry);
@@ -643,6 +643,12 @@ static int kvm_create_vm_debugfs(struct
 	struct kvm_stat_data *stat_data;
 	struct kvm_stats_debugfs_item *p;
 
+	/*
+	 * Force subsequent debugfs file creations to fail if the VM directory
+	 * is not created.
+	 */
+	kvm->debugfs_dentry = ERR_PTR(-ENOENT);
+
 	if (!debugfs_initialized())
 		return 0;
 
@@ -4399,7 +4405,7 @@ static void kvm_uevent_notify_change(uns
 	}
 	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
 
-	if (kvm->debugfs_dentry) {
+	if (!IS_ERR(kvm->debugfs_dentry)) {
 		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
 
 		if (p) {


