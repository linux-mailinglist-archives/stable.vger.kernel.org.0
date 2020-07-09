Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4FC21A513
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 18:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbgGIQrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 12:47:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45211 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728248AbgGIQrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 12:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594313226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UspVOw6XAGLtilKBpYwpbaqQeMaCCmM2aVuZ489RO+o=;
        b=LWSfhdjnKyWaxIDXzJHe5txJCczeUZlpJu4HSOt/ZveqCkI6SrkOLSLd79i17J5PQ+8+SH
        3adPyEvlaCGMhNCu3de9dA8LZhKiUVerkYGwEEAxwQpP8IKHxnLMreAO3vILouoiaWCk1u
        lKbAiKyr/b1ne9H5sz8FU/mtSc2H3Zs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-oDlM1zC6Nci7D7IE62glIQ-1; Thu, 09 Jul 2020 12:46:55 -0400
X-MC-Unique: oDlM1zC6Nci7D7IE62glIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C8D5E918;
        Thu,  9 Jul 2020 16:46:53 +0000 (UTC)
Received: from localhost (ovpn-116-137.gru2.redhat.com [10.97.116.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B7085BAEA;
        Thu,  9 Jul 2020 16:46:50 +0000 (UTC)
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-integrity@vger.kernel.org
Cc:     zohar@linux.ibm.com, erichte@linux.ibm.com, nayna@linux.ibm.com,
        stable@vger.kernel.org, Bruno Meneguele <bmeneg@redhat.com>
Subject: [PATCH v5] ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime
Date:   Thu,  9 Jul 2020 13:46:47 -0300
Message-Id: <20200709164647.45153-1-bmeneg@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

APPRAISE_BOOTPARAM has been marked as dependent on !ARCH_POLICY in compile
time, enforcing the appraisal whenever the kernel had the arch policy option
enabled.

However it breaks systems where the option is set but the system didn't
boot in a "secure boot" platform. In this scenario, anytime an appraisal
policy (i.e. ima_policy=appraisal_tcb) is used it will be forced, without
giving the user the opportunity to label the filesystem, before enforcing
integrity.

Considering the ARCH_POLICY is only effective when secure boot is actually
enabled this patch remove the compile time dependency and move it to a
runtime decision, based on the secure boot state of that platform.

With this patch:

- x86-64 with secure boot enabled

[    0.004305] Secure boot enabled
...
[    0.015651] Kernel command line: <...> ima_policy=appraise_tcb ima_appraise=fix
[    0.015682] ima: appraise boot param ignored: secure boot enabled

- powerpc with secure boot disabled

[    0.000000] Kernel command line: <...> ima_policy=appraise_tcb ima_appraise=fix
[    0.000000] Secure boot mode disabled
...
< nothing about boot param ignored >

System working fine without secure boot and with both options set:

CONFIG_IMA_APPRAISE_BOOTPARAM=y
CONFIG_IMA_ARCH_POLICY=y

Audit logs pointing to "missing-hash" but still being able to execute due to
ima_appraise=fix:

type=INTEGRITY_DATA msg=audit(07/09/2020 12:30:27.778:1691) : pid=4976
uid=root auid=root ses=2
subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 op=appraise_data
cause=missing-hash comm=bash name=/usr/bin/evmctl dev="dm-0" ino=493150
res=no

Cc: stable@vger.kernel.org
Fixes: d958083a8f64 ("x86/ima: define arch_get_ima_policy() for x86")
Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
---
Changelog:
v5:
  - add pr_info() to inform user the ima_appraise= boot param is being
	ignored due to secure boot enabled (Nayna)
  - add some testing results to commit log
v4:
  - instead of change arch_policy loading code, check secure boot state at
	"ima_appraise=" parameter handler (Mimi)
v3:
  - extend secure boot arch checker to also consider trusted boot
  - enforce IMA appraisal when secure boot is effectively enabled (Nayna)
  - fix ima_appraise flag assignment by or'ing it (Mimi)
v2:
  - pr_info() message prefix correction

 security/integrity/ima/Kconfig        | 2 +-
 security/integrity/ima/ima_appraise.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index edde88dbe576..62dc11a5af01 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -232,7 +232,7 @@ config IMA_APPRAISE_REQUIRE_POLICY_SIGS
 
 config IMA_APPRAISE_BOOTPARAM
 	bool "ima_appraise boot parameter"
-	depends on IMA_APPRAISE && !IMA_ARCH_POLICY
+	depends on IMA_APPRAISE
 	default y
 	help
 	  This option enables the different "ima_appraise=" modes
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index a9649b04b9f1..884de471b38a 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -19,6 +19,11 @@
 static int __init default_appraise_setup(char *str)
 {
 #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
+	if (arch_ima_get_secureboot()) {
+		pr_info("appraise boot param ignored: secure boot enabled");
+		return 1;
+	}
+
 	if (strncmp(str, "off", 3) == 0)
 		ima_appraise = 0;
 	else if (strncmp(str, "log", 3) == 0)
-- 
2.26.2

