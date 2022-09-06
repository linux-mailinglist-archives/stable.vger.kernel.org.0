Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59665AE716
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbiIFMAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiIFMAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:00:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BA772ED8
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 05:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5353161325
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 12:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C14C433D6;
        Tue,  6 Sep 2022 12:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465634;
        bh=/0mvyIQ9K7qL4KNVFCJ7uMES3t2oM0gfn4n2yT3C/AE=;
        h=Subject:To:Cc:From:Date:From;
        b=tjb84V1ZVowRtGk+yusrSAH9TCY6EpXdfe2Rk0fLdSAIho6zYePPHNEne2ciIEzq0
         TtPGi0MkfrEFDad6lNrLJ5JTM+rX9afpPNX4/F5odBMuhFguLRm+v3xswzqUNW8LSN
         5jwIQnFu0CBLRheiM2SSKP5zbocrZpnjZ+cM4XL4=
Subject: FAILED: patch "[PATCH] Smack: Provide read control for io_uring_cmd" failed to apply to 5.19-stable tree
To:     casey@schaufler-ca.com, paul@paul-moore.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 14:00:22 +0200
Message-ID: <16624656226867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

dd9373402280 ("Smack: Provide read control for io_uring_cmd")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dd9373402280cf4715fdc8fd5070f7d039e43511 Mon Sep 17 00:00:00 2001
From: Casey Schaufler <casey@schaufler-ca.com>
Date: Tue, 23 Aug 2022 16:46:18 -0700
Subject: [PATCH] Smack: Provide read control for io_uring_cmd

Limit io_uring "cmd" options to files for which the caller has
Smack read access. There may be cases where the cmd option may
be closer to a write access than a read, but there is no way
to make that determination.

Cc: stable@vger.kernel.org
Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 001831458fa2..bffccdc494cb 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -42,6 +42,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/watch_queue.h>
+#include <linux/io_uring.h>
 #include "smack.h"
 
 #define TRANS_TRUE	"TRUE"
@@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
 	return -EPERM;
 }
 
+/**
+ * smack_uring_cmd - check on file operations for io_uring
+ * @ioucmd: the command in question
+ *
+ * Make a best guess about whether a io_uring "command" should
+ * be allowed. Use the same logic used for determining if the
+ * file could be opened for read in the absence of better criteria.
+ */
+static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct file *file = ioucmd->file;
+	struct smk_audit_info ad;
+	struct task_smack *tsp;
+	struct inode *inode;
+	int rc;
+
+	if (!file)
+		return -EINVAL;
+
+	tsp = smack_cred(file->f_cred);
+	inode = file_inode(file);
+
+	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
+	smk_ad_setfield_u_fs_path(&ad, file->f_path);
+	rc = smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad);
+	rc = smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
+
+	return rc;
+}
+
 #endif /* CONFIG_IO_URING */
 
 struct lsm_blob_sizes smack_blob_sizes __lsm_ro_after_init = {
@@ -4889,6 +4920,7 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 #ifdef CONFIG_IO_URING
 	LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
+	LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
 #endif
 };
 

