Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DEE203DE1
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 19:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgFVR2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 13:28:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22311 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729836AbgFVR2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 13:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592846885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=of2f8hWxB0T9whMxX/5yPSiVwyh1lT2tIyUWPF6B/bs=;
        b=CmrDGFkgHALIsG5U6lDUnyPSpexJHvgzYkDS/JSzrSEEhIP8HnqyRPQN8+fdTpDOLk/2i8
        V4YKOgqL900Mrdnggbry2CgZjcG0pxgSBji7GuNHozdbUQrD7+iqEf8h+NmZuTuqbbpF5b
        R7PC8/wPv2lgnHguYgjmEm1c7dLjyls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-OJrb7cknMvmVJ4IluHs5kQ-1; Mon, 22 Jun 2020 13:28:03 -0400
X-MC-Unique: OJrb7cknMvmVJ4IluHs5kQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1602809880;
        Mon, 22 Jun 2020 17:28:01 +0000 (UTC)
Received: from localhost (ovpn-116-68.gru2.redhat.com [10.97.116.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A2AA85BAEA;
        Mon, 22 Jun 2020 17:27:57 +0000 (UTC)
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zohar@linux.ibm.com, erichte@linux.ibm.com, nayna@linux.ibm.com,
        Bruno Meneguele <bmeneg@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime
Date:   Mon, 22 Jun 2020 14:27:54 -0300
Message-Id: <20200622172754.10763-1-bmeneg@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
changes from v1:
	- removed "ima:" prefix from pr_info() message

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
index e493063a3c34..c876617d4210 100644
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
+		pr_info("setting IMA appraisal to enforced\n");
+		ima_appraise = IMA_APPRAISE_ENFORCE;
 		add_rules(arch_policy_entry, arch_entries,
 			  IMA_DEFAULT_POLICY | IMA_CUSTOM_POLICY);
+	}
 
 	/*
 	 * Insert the builtin "secure_boot" policy rules requiring file
-- 
2.26.2

