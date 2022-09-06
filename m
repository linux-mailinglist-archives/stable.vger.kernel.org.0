Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68D5AF692
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiIFVD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiIFVD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:03:57 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961A6A9252
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 14:03:56 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id v15so6505190qvi.11
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 14:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date;
        bh=JT+gOz3fKl6MC7AjldhQFB7VwdWbFk28JfZ/z8wOF6U=;
        b=c5EwKL8SupN4TigtQt+6UDHFb1iZ77+Gbldz45t7EpCqyqQYOocUIwvBrx/04yJXlE
         +6/TqgT/JyHs9dZk/mhv2UmmHdrY2LqnCwX2mL/G6S9siyytASYDb0vVGvQHTWza7Suc
         xmb3G7rqJOqBmdD4jZNUA7H9grirly+SF2PEyvchO6S4j6GDR90dkJeF/GdauoVLJBk3
         85F/DYhXbaB14qY6o0LtqIl0gz54WQr8mzp4PelJB21mQQjC54XeNDqmgfnRkZiUJXIf
         ql6ZwWiQo9hu15mUU45/gEVNb2eyWIrIQFMTd2HaLFec84rkJxqVu+pj7wh7gbH846n8
         4aBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-message-state
         :from:to:cc:subject:date;
        bh=JT+gOz3fKl6MC7AjldhQFB7VwdWbFk28JfZ/z8wOF6U=;
        b=JgkSRytH1rJxgjhZSgNdynj0Dsy2e/TULfB+S6jatj4eQrj1l5CcVKJRjHAcoiwsFo
         oTnqsouGHzEcR1XDG0DfyosQCl5aX9fiwcUyzVheygPerMIOsNA1WOzqKMrQ1Ppozt4g
         vFyQphGV3aZs7bsnboUJlI2PC0lN6HEt5kQbE8QN/1kss3Ddt6SoNUBc/inEn3mTK6Ic
         +3uDMnqP1XUZ9HZO9iwBt4vbot8dZLNAOXmTEcfzWb7Y67RUrAT//je0JVwg6Zxr3uZa
         edsmYek6xd7+jhtI9yfmSbErocXw7iPefBL39o4huysvT3mmXh24M2y4DglZlf+9CM/L
         osvA==
X-Gm-Message-State: ACgBeo3hrHv1LgwQ5k8aIN+2DoOU2OoTBGfgQR3RzKEX2vCDdvATzxLm
        rWA9UfrOLaKsQ0HdprB5yBDdWgEEZFqv
X-Google-Smtp-Source: AA6agR5NX2KOzSimlyRxEms1kdM1D1nBQoMlTRJaBhRuDGN2/Po4caz+hTKm3muhATsUyr3NcCQ1pA==
X-Received: by 2002:a0c:9a48:0:b0:4aa:9d5e:2557 with SMTP id q8-20020a0c9a48000000b004aa9d5e2557mr432141qvd.104.1662498235252;
        Tue, 06 Sep 2022 14:03:55 -0700 (PDT)
Received: from localhost (pool-108-26-161-203.bstnma.fios.verizon.net. [108.26.161.203])
        by smtp.gmail.com with ESMTPSA id h5-20020a05620a284500b006bc192d277csm12207592qkp.10.2022.09.06.14.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 14:03:54 -0700 (PDT)
Subject: [v5.19.y PATCH 3/3] Smack: Provide read control for io_uring_cmd
From:   Paul Moore <paul@paul-moore.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Luis Chamberlain <mcgrof@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org
Date:   Tue, 06 Sep 2022 17:03:54 -0400
Message-ID: <166249823441.409408.621539815259290208.stgit@olly>
In-Reply-To: <166249766105.409408.12118839467847524983.stgit@olly>
References: <166249766105.409408.12118839467847524983.stgit@olly>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport the following upstream commit into Linux v5.19.y:

    commit dd9373402280cf4715fdc8fd5070f7d039e43511
    Author: Casey Schaufler <casey@schaufler-ca.com>
    Date:   Tue Aug 23 16:46:18 2022 -0700

    Smack: Provide read control for io_uring_cmd

    Limit io_uring "cmd" options to files for which the caller has
    Smack read access. There may be cases where the cmd option may
    be closer to a write access than a read, but there is no way
    to make that determination.

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 security/smack/smack_lsm.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 6207762dbdb1..b30e20f64471 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -42,6 +42,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/watch_queue.h>
+#include <linux/io_uring.h>
 #include "smack.h"
 
 #define TRANS_TRUE	"TRUE"
@@ -4739,6 +4740,36 @@ static int smack_uring_sqpoll(void)
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
@@ -4896,6 +4927,7 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 #ifdef CONFIG_IO_URING
 	LSM_HOOK_INIT(uring_override_creds, smack_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, smack_uring_sqpoll),
+	LSM_HOOK_INIT(uring_cmd, smack_uring_cmd),
 #endif
 };
 

