Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63555AF693
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 23:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiIFVD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 17:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiIFVDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 17:03:51 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A7FA98CD
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 14:03:50 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id a10so9124230qkl.13
        for <stable@vger.kernel.org>; Tue, 06 Sep 2022 14:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:from:to:cc:subject
         :date;
        bh=zxQ66m5smH23GnuOECwAiTPpsELUaznzezl4/ifu74Q=;
        b=M7VpfvSjm/xhgtLPB8T/3TywX/TwQtxWaF7Df56ET1MNqn08IrKYVhDDqikYYU4bZk
         ZyLlphwIrvabKTQi11OzmuwkiYXfi+3BzNXsxlWkPIIw9jKrdh6ioFpPyIF7BnvQZG7P
         15kKquPxU9JOp9n5QUqaFpvvL5qjJudyCm/sdMq4m+1ru/NEQCNcaegVzAHMptkOpA20
         U1qH6BMcrVOZfNqnV7ZAQtD0+TxhsWwg7bsu6JWGPurtECJVv3T8FAXMGkqRPhgAOYy+
         0WedvN9NsbMgU6U6YLnuSftryooyL9ghpvmM9Gf0kTBe27DTa++/WNPcSivcP9ikj4yd
         hv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:date:cc:to:from:subject:x-gm-message-state
         :from:to:cc:subject:date;
        bh=zxQ66m5smH23GnuOECwAiTPpsELUaznzezl4/ifu74Q=;
        b=17nym3mjJO7KJpazCQrdw9RcraJpELY2lUkbGQ2EPanypi/Ik5STTZGG1zWv23sFEV
         /vl/WroM/IBG/3Z+14oUVjNmu4P6ks3RCXiOGu/3pTmP3bvzXFf9Mas5ts3DAJYo53SN
         nxw0/17FiAaVIxT453jErpxfmj0sW7cfxtSmA/28JpmbSW3ihyCmQ4oZPo4FkH77PSFG
         ddBMoIWROqXNnIP/tRdFV+tKuVBHKk7rc8VJ9JhX/ivNfGKGisM4AzU7s3OlCnToJv5D
         U8X8/shTu/nVv+7biXD81OoV10q8MAQCqh2rHZm0cakmLV5430J2WC0ztj6bUYrLkks1
         8x5A==
X-Gm-Message-State: ACgBeo3pN1s//U3x6Eg2UjzAIu1wA0dO8myKzvK7WISsvoGKfMiWaC64
        KEiD9g+oAzq207eew0iMHqKuQTbyQQvq
X-Google-Smtp-Source: AA6agR7SkQibN9yqKoWTbVD1M3dgQcyRamfkXa6npPHkPIwXqfb7VFKVYavZTtR0SJ4LPkIJjS2bjg==
X-Received: by 2002:a05:620a:1018:b0:6bc:638d:cf54 with SMTP id z24-20020a05620a101800b006bc638dcf54mr428624qkj.161.1662498229300;
        Tue, 06 Sep 2022 14:03:49 -0700 (PDT)
Received: from localhost (pool-108-26-161-203.bstnma.fios.verizon.net. [108.26.161.203])
        by smtp.gmail.com with ESMTPSA id x24-20020ac87a98000000b003431446588fsm10351464qtr.5.2022.09.06.14.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 14:03:48 -0700 (PDT)
Subject: [v5.19.y PATCH 2/3] selinux: implement the security_uring_cmd() LSM
 hook
From:   Paul Moore <paul@paul-moore.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Luis Chamberlain <mcgrof@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org
Date:   Tue, 06 Sep 2022 17:03:48 -0400
Message-ID: <166249822847.409408.9982274436178494091.stgit@olly>
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

    commit f4d653dcaa4e4056e1630423e6a8ece4869b544f
    Author: Paul Moore <paul@paul-moore.com>
    Date:   Wed Aug 10 15:55:36 2022 -0400

    selinux: implement the security_uring_cmd() LSM hook

    Add a SELinux access control for the iouring IORING_OP_URING_CMD
    command.  This includes the addition of a new permission in the
    existing "io_uring" object class: "cmd".  The subject of the new
    permission check is the domain of the process requesting access, the
    object is the open file which points to the device/file that is the
    target of the IORING_OP_URING_CMD operation.  A sample policy rule
    is shown below:

      allow <domain> <file>:io_uring { cmd };

Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 security/selinux/hooks.c            |   24 ++++++++++++++++++++++++
 security/selinux/include/classmap.h |    2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1bbd53321d13..e90dfa36f79a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -91,6 +91,7 @@
 #include <uapi/linux/mount.h>
 #include <linux/fsnotify.h>
 #include <linux/fanotify.h>
+#include <linux/io_uring.h>
 
 #include "avc.h"
 #include "objsec.h"
@@ -6990,6 +6991,28 @@ static int selinux_uring_sqpoll(void)
 	return avc_has_perm(&selinux_state, sid, sid,
 			    SECCLASS_IO_URING, IO_URING__SQPOLL, NULL);
 }
+
+/**
+ * selinux_uring_cmd - check if IORING_OP_URING_CMD is allowed
+ * @ioucmd: the io_uring command structure
+ *
+ * Check to see if the current domain is allowed to execute an
+ * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
+ *
+ */
+static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
+{
+	struct file *file = ioucmd->file;
+	struct inode *inode = file_inode(file);
+	struct inode_security_struct *isec = selinux_inode(inode);
+	struct common_audit_data ad;
+
+	ad.type = LSM_AUDIT_DATA_FILE;
+	ad.u.file = file;
+
+	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
+			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
+}
 #endif /* CONFIG_IO_URING */
 
 /*
@@ -7234,6 +7257,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 #ifdef CONFIG_IO_URING
 	LSM_HOOK_INIT(uring_override_creds, selinux_uring_override_creds),
 	LSM_HOOK_INIT(uring_sqpoll, selinux_uring_sqpoll),
+	LSM_HOOK_INIT(uring_cmd, selinux_uring_cmd),
 #endif
 
 	/*
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index ff757ae5f253..1c2f41ff4e55 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -253,7 +253,7 @@ const struct security_class_mapping secclass_map[] = {
 	{ "anon_inode",
 	  { COMMON_FILE_PERMS, NULL } },
 	{ "io_uring",
-	  { "override_creds", "sqpoll", NULL } },
+	  { "override_creds", "sqpoll", "cmd", NULL } },
 	{ NULL }
   };
 

