Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E602561FA4D
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 17:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiKGQqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 11:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbiKGQqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 11:46:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458701F2EC
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 08:46:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F274DB815A0
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 16:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4400AC433D6;
        Mon,  7 Nov 2022 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667839595;
        bh=12X+lkgaoTS4+UHyoiDqB5nT1dpdIjCWQ9q4JitD9i0=;
        h=Subject:To:Cc:From:Date:From;
        b=Xk2nsuBgpY47pz2sTDEV3xHOeYjuZ/elIl9HVBPmfDCqYruvdBEYg7Q0U2erGJGlM
         qzX4TQcVElpzq0DzOuVin7+J6OP8cKnXln50zQET9yRbW22k6urJvfNE6nIW5VEVpQ
         YbY0/VIU7UqZ4ZHKWd6LEWIznDIC3imXYe/ruwnM=
Subject: WTF: patch "[PATCH] KVM: debugfs: Return retval of simple_attr_open() if it fails" was seriously submitted to be applied to the 6.0-stable tree?
To:     houwenlong.hwl@antgroup.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Nov 2022 17:46:32 +0100
Message-ID: <166783959219142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 6.0-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 180418e2eb33be5c8d0b703c843e0ebc045aef80 Mon Sep 17 00:00:00 2001
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
Date: Mon, 17 Oct 2022 11:06:10 +0800
Subject: [PATCH] KVM: debugfs: Return retval of simple_attr_open() if it fails

Although simple_attr_open() fails only with -ENOMEM with current code
base, it would be nicer to return retval of simple_attr_open() directly
in kvm_debugfs_open().

No functional change intended.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Message-Id: <69d64d93accd1f33691b8a383ae555baee80f943.1665975828.git.houwenlong.hwl@antgroup.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1376a47fedee..f1df24c2bc84 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5409,6 +5409,7 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 			   int (*get)(void *, u64 *), int (*set)(void *, u64),
 			   const char *fmt)
 {
+	int ret;
 	struct kvm_stat_data *stat_data = (struct kvm_stat_data *)
 					  inode->i_private;
 
@@ -5420,15 +5421,13 @@ static int kvm_debugfs_open(struct inode *inode, struct file *file,
 	if (!kvm_get_kvm_safe(stat_data->kvm))
 		return -ENOENT;
 
-	if (simple_attr_open(inode, file, get,
-		    kvm_stats_debugfs_mode(stat_data->desc) & 0222
-		    ? set : NULL,
-		    fmt)) {
+	ret = simple_attr_open(inode, file, get,
+			       kvm_stats_debugfs_mode(stat_data->desc) & 0222
+			       ? set : NULL, fmt);
+	if (ret)
 		kvm_put_kvm(stat_data->kvm);
-		return -ENOMEM;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int kvm_debugfs_release(struct inode *inode, struct file *file)

