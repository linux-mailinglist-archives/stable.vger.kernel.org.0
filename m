Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE731FFBF0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 21:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgFRTna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 15:43:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32325 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727070AbgFRTn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 15:43:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592509407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cBX34+Jjqml76C2Svn4EX3pnXJ1NO9Juk7OLBDMj9Lg=;
        b=jBZc8ghJO9U9R398rn1ldn+UijiLu4Ey2rZLI4JG/Tokg246Tcyyqota3wSkotqhzGHrnM
        sxkpqtETTPlJOble6T1GepcbgtkJBfh04JTkpm5EUTBETP7tFej9Qc91e/ae9wh6M/3EPH
        AEG2EpQRNLbV4LFY/1pUzLUeZ+PP/HE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-8DV_LZF3O-iZpVOoJZf6bQ-1; Thu, 18 Jun 2020 15:43:25 -0400
X-MC-Unique: 8DV_LZF3O-iZpVOoJZf6bQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CE5D8018AC;
        Thu, 18 Jun 2020 19:43:24 +0000 (UTC)
Received: from localhost (ovpn-116-72.gru2.redhat.com [10.97.116.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4E9C1002396;
        Thu, 18 Jun 2020 19:43:19 +0000 (UTC)
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zohar@linux.ibm.com, erichte@linux.ibm.com, nayna@linux.ibm.com,
        Bruno Meneguele <bmeneg@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime
Date:   Thu, 18 Jun 2020 16:43:10 -0300
Message-Id: <20200618194310.169197-1-bmeneg@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

IMA_APPRAISE_BOOTPARAM has been marked as dependent on !IMA_ARCH_POLICY in
compile time, enforcing the appraisal whenever the kernel had the arch
policy option enabled.

However it breaks systems where the option is actually set but the system
wasn't booted in a "secure boot" platform. In this scenario, anytime the
an appraisal policy (i.e. ima_policy=appraisal_tcb) is used it will be
forced, giving no chance to the user set the 'fix' state (ima_appraise=fix)
to actually measure system's files.

This patch remove this compile time dependency and move it to a runtime
decision, based on the arch policy loading failure/success.

Cc: stable@vger.kernel.org
Fixes: d958083a8f64 ("x86/ima: define arch_get_ima_policy() for x86")
Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
---
 security/integrity/ima/Kconfig      | 2 +-
 security/integrity/ima/ima_policy.c | 8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

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
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index e493063a3c34..d6f8f513f447 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -733,11 +733,15 @@ void __init ima_init_policy(void)
 	 * (Highest priority)
 	 */
 	arch_entries = ima_init_arch_policy();
-	if (!arch_entries)
+	if (!arch_entries) {
 		pr_info("No architecture policies found\n");
-	else
+	} else {
+		/* Force appraisal, preventing runtime xattr changes */
+		pr_info("ima: setting IMA appraisal to enforced\n");
+		ima_appraise = IMA_APPRAISE_ENFORCE;
 		add_rules(arch_policy_entry, arch_entries,
 			  IMA_DEFAULT_POLICY | IMA_CUSTOM_POLICY);
+	}
 
 	/*
 	 * Insert the builtin "secure_boot" policy rules requiring file
-- 
2.26.2

