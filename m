Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E25E5E806D
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiIWRKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiIWRKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:10:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFDE1176EB;
        Fri, 23 Sep 2022 10:10:47 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AD962219E8;
        Fri, 23 Sep 2022 17:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663953045; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7wdzniV44JpDOtKhagq8bpV/n/iPwiybf6GIA01NcK8=;
        b=ruxKVqiRRt9gnO/c+YPWRlsrcsMWgfXWIpusnxCGIg9Z1bN88Zx4/1cESvhWpr22f5ZnnZ
        quyfk5/mYB73yH1UbrsN3olLzgxXwhTh8jiqqc5ODCEB/H/JCW+xBc5aumyRYuOqZ1j0XH
        lETDTv08Aj7JUA67yMIWc9V9otL+UYE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663953045;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7wdzniV44JpDOtKhagq8bpV/n/iPwiybf6GIA01NcK8=;
        b=DkfgD5rwHpyA25iOf1Id1b9Xe9IBID6N6JrK41GeK7j6BLp3pCurZto6lNYl65Po6KlXM7
        cpEKJYiTl39JlxCw==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        by relay2.suse.de (Postfix) with ESMTP id 74A632C15C;
        Fri, 23 Sep 2022 17:10:45 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Sven Schnelle <svens@linux.ibm.com>,
        Philipp Rudo <prudo@redhat.com>,
        Sasha Levin <sashal@kernel.org>, Baoquan He <bhe@redhat.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        linux-s390@vger.kernel.org (open list:S390)
Subject: [PATCH 5.15 1/6] s390/kexec_file: move kernel image size check
Date:   Fri, 23 Sep 2022 19:10:29 +0200
Message-Id: <e2869bb973f6b5fe350c52e4033fb171ef64aecd.1663951201.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1663951201.git.msuchanek@suse.de>
References: <cover.1663951201.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 277c8389386e2ccb8417afe4e36f67fc5dcd735d upstream.

In preparation of adding support for command lines with variable
sizes on s390, the check whether the new kernel image is at least HEAD_END
bytes long isn't correct. Move the check to kexec_file_add_components()
so we can get the size of the parm area and check the size there.

The '.org HEAD_END' directive can now also be removed from head.S. This
was used in the past to reserve space for the early sccb buffer, but with
commit f1d3c5323772 ("s390/boot: move sclp early buffer from fixed address
in asm to C") this is no longer required.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 arch/s390/boot/head.S                 |  2 --
 arch/s390/include/asm/setup.h         |  1 -
 arch/s390/kernel/machine_kexec_file.c | 17 ++---------------
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/s390/boot/head.S b/arch/s390/boot/head.S
index 40f4cff538b8..f3a8dba7dd5d 100644
--- a/arch/s390/boot/head.S
+++ b/arch/s390/boot/head.S
@@ -383,5 +383,3 @@ SYM_DATA_START(parmarea)
 	.byte	0
 	.org	PARMAREA+__PARMAREA_SIZE
 SYM_DATA_END(parmarea)
-
-	.org	HEAD_END
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index b6606ffd85d8..121e1a8c41d7 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -11,7 +11,6 @@
 #include <linux/build_bug.h>
 
 #define PARMAREA		0x10400
-#define HEAD_END		0x11000
 
 /*
  * Machine features detected in early.c
diff --git a/arch/s390/kernel/machine_kexec_file.c b/arch/s390/kernel/machine_kexec_file.c
index 3459362c54ac..29a9178ff0d4 100644
--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -243,7 +243,8 @@ void *kexec_file_add_components(struct kimage *image,
 	if (ret)
 		goto out;
 
-	if (image->cmdline_buf_len >= ARCH_COMMAND_LINE_SIZE) {
+	if (image->kernel_buf_len < PARMAREA + sizeof(struct parmarea) ||
+	    image->cmdline_buf_len >= ARCH_COMMAND_LINE_SIZE) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -333,20 +334,6 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 	return 0;
 }
 
-int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
-				  unsigned long buf_len)
-{
-	/* A kernel must be at least large enough to contain head.S. During
-	 * load memory in head.S will be accessed, e.g. to register the next
-	 * command line. If the next kernel were smaller the current kernel
-	 * will panic at load.
-	 */
-	if (buf_len < HEAD_END)
-		return -ENOEXEC;
-
-	return kexec_image_probe_default(image, buf, buf_len);
-}
-
 int arch_kimage_file_post_load_cleanup(struct kimage *image)
 {
 	vfree(image->arch.ipl_buf);
-- 
2.35.3

