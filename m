Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6A1213F04
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 20:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgGCSBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 14:01:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42258 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgGCSA7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 14:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593799257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W7hX68Id9MrI9Dp1ohSoP6+dFWqqds4yeexuPF5eVaQ=;
        b=bc3R3Of9LSV6hUMkPN0UjfF37knQ68K2UmQKzrvuFpvS5/16VH3xpPkzblhqm2bMs3aCkR
        fhGRKnEQs8exGtBsCjXYVWJ5+/cotV3VB33wUGgsS+fC7ycFlLd5iVJTIZ8M0sci12jSbj
        1Eio+jlWOl3Fwt3iX7Wo4M4pXKtOXEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-F_NqQgogODmQd7163_VhmA-1; Fri, 03 Jul 2020 14:00:54 -0400
X-MC-Unique: F_NqQgogODmQd7163_VhmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F415B800C64;
        Fri,  3 Jul 2020 18:00:52 +0000 (UTC)
Received: from localhost (ovpn-116-12.gru2.redhat.com [10.97.116.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C28C19D9E;
        Fri,  3 Jul 2020 18:00:52 +0000 (UTC)
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zohar@linux.ibm.com, erichte@linux.ibm.com, nayna@linux.ibm.com,
        Bruno Meneguele <bmeneg@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v4] ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime
Date:   Fri,  3 Jul 2020 15:00:49 -0300
Message-Id: <20200703180049.15608-1-bmeneg@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

APPRAISE_BOOTPARAM has been marked as dependent on !ARCH_POLICY in compile
time, enforcing the appraisal whenever the kernel had the arch policy option
enabled.

However it breaks systems where the option is set but the system wasn't
booted in a "secure boot" platform. In this scenario, anytime an appraisal
policy (i.e. ima_policy=appraisal_tcb) is used it will be forced, giving no
chance to the user set the 'fix' state (ima_appraise=fix) to actually
measure system's files.

Considering the ARCH_POLICY is only effective when secure boot is actually
enabled this patch remove the compile time dependency and move it to a
runtime decision, based on the secure boot state of that platform.

Cc: stable@vger.kernel.org
Fixes: d958083a8f64 ("x86/ima: define arch_get_ima_policy() for x86")
Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
---
Changelog:
	v4:
	  - instead of change arch_policy loading code, check secure boot state
		at "ima_appraise=" parameter handler (Mimi)
	v3:
	  - extend secure boot arch checker to also consider trusted boot
	  - enforce IMA appraisal when secure boot is effectively enabled (Nayna)
	  - fix ima_appraise flag assignment by or'ing it (Mimi)
	v2:
	  - pr_info() message prefix correction

 security/integrity/ima/Kconfig        |  2 +-
 security/integrity/ima/ima_appraise.c | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

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
index a9649b04b9f1..4fc83b3fbd5c 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -18,14 +18,16 @@
 
 static int __init default_appraise_setup(char *str)
 {
-#ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
-	if (strncmp(str, "off", 3) == 0)
-		ima_appraise = 0;
-	else if (strncmp(str, "log", 3) == 0)
-		ima_appraise = IMA_APPRAISE_LOG;
-	else if (strncmp(str, "fix", 3) == 0)
-		ima_appraise = IMA_APPRAISE_FIX;
-#endif
+	if (IS_ENABLED(CONFIG_IMA_APPRAISE_BOOTPARAM) &&
+	    !arch_ima_get_secureboot()) {
+		if (strncmp(str, "off", 3) == 0)
+			ima_appraise = 0;
+		else if (strncmp(str, "log", 3) == 0)
+			ima_appraise = IMA_APPRAISE_LOG;
+		else if (strncmp(str, "fix", 3) == 0)
+			ima_appraise = IMA_APPRAISE_FIX;
+	}
+
 	return 1;
 }
 
-- 
2.26.2

