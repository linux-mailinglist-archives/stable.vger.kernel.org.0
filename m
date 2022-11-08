Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6DE6210B9
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbiKHMbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiKHMbO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:31:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6ACE3E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:31:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E67C61520
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74649C433D6;
        Tue,  8 Nov 2022 12:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667910672;
        bh=hyKS2gTTbQB9VbPOmxPE/WWt7fxvIRfM61GFllXp7kQ=;
        h=Subject:To:Cc:From:Date:From;
        b=WB1XYwhJzf3WKWvWvI6Chg+TTNJE4gQYGz3p86pFYYx8XsfmrvNEKk28pqvYQkLWK
         jmWsOHqM4m6dWXacVwQfSfc13GWNyMJwCtPSJN6TtoI9wuTMRtqbpgRVJO8dGwogOk
         oTmL6t//+EedD8uTgljyXh68XPnZHjCwIIAFktOM=
Subject: FAILED: patch "[PATCH] drm/amdkfd: Fix NULL pointer dereference in" failed to apply to 6.0-stable tree
To:     yang.lee@linux.alibaba.com, Felix.Kuehling@amd.com,
        abaci@linux.alibaba.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Nov 2022 13:31:09 +0100
Message-ID: <1667910669201143@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5b994354af3c ("drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()")
e1f84eef313f ("drm/amdkfd: handle CPU fault on COW mapping")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5b994354af3cab770bf13386469c5725713679af Mon Sep 17 00:00:00 2001
From: Yang Li <yang.lee@linux.alibaba.com>
Date: Wed, 26 Oct 2022 10:00:54 +0800
Subject: [PATCH] drm/amdkfd: Fix NULL pointer dereference in
 svm_migrate_to_ram()

./drivers/gpu/drm/amd/amdkfd/kfd_migrate.c:985:58-62: ERROR: p is NULL but dereferenced.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2549
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 2797029bd500..22b077ac9a19 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -973,12 +973,10 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 out_unlock_svms:
 	mutex_unlock(&p->svms.lock);
 out_unref_process:
+	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
 	kfd_unref_process(p);
 out_mmput:
 	mmput(mm);
-
-	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
-
 	return r ? VM_FAULT_SIGBUS : 0;
 }
 

