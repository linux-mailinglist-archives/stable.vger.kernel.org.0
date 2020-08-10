Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3951C2408D1
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgHJPZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgHJPZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802EB20855;
        Mon, 10 Aug 2020 15:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073132;
        bh=QWK7XBR5gvkHC3LExaNmD7qFaj0SX1A+sVIAOWe7vgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LGP4cupAHkDULejeqtybmsDaNf5/9aXeSyhfmeXqecs3KocLdFC+OaFXtJNCmD3E
         mKobAoXHA8JA65AiPPihDiCV5k3JSBT9Edv9k8BQBVcLNuYwzNtVpEHwMm4LRqmdfa
         seOCsrCRntwxU08B+1IMGgJSpKk+p5zim6X4uYbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Meneguele <bmeneg@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.7 78/79] ima: move APPRAISE_BOOTPARAM dependency on ARCH_POLICY to runtime
Date:   Mon, 10 Aug 2020 17:21:37 +0200
Message-Id: <20200810151816.065858854@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bruno Meneguele <bmeneg@redhat.com>

commit 311aa6aafea446c2f954cc19d66425bfed8c4b0b upstream.

The IMA_APPRAISE_BOOTPARAM config allows enabling different "ima_appraise="
modes - log, fix, enforce - at run time, but not when IMA architecture
specific policies are enabled.  This prevents properly labeling the
filesystem on systems where secure boot is supported, but not enabled on the
platform.  Only when secure boot is actually enabled should these IMA
appraise modes be disabled.

This patch removes the compile time dependency and makes it a runtime
decision, based on the secure boot state of that platform.

Test results as follows:

-> x86-64 with secure boot enabled

[    0.015637] Kernel command line: <...> ima_policy=appraise_tcb ima_appraise=fix
[    0.015668] ima: Secure boot enabled: ignoring ima_appraise=fix boot parameter option

-> powerpc with secure boot disabled

[    0.000000] Kernel command line: <...> ima_policy=appraise_tcb ima_appraise=fix
[    0.000000] Secure boot mode disabled

-> Running the system without secure boot and with both options set:

CONFIG_IMA_APPRAISE_BOOTPARAM=y
CONFIG_IMA_ARCH_POLICY=y

Audit prompts "missing-hash" but still allow execution and, consequently,
filesystem labeling:

type=INTEGRITY_DATA msg=audit(07/09/2020 12:30:27.778:1691) : pid=4976
uid=root auid=root ses=2
subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 op=appraise_data
cause=missing-hash comm=bash name=/usr/bin/evmctl dev="dm-0" ino=493150
res=no

Cc: stable@vger.kernel.org
Fixes: d958083a8f64 ("x86/ima: define arch_get_ima_policy() for x86")
Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>
Cc: stable@vger.kernel.org # 5.0
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/Kconfig        |    2 +-
 security/integrity/ima/ima_appraise.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

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
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -19,6 +19,12 @@
 static int __init default_appraise_setup(char *str)
 {
 #ifdef CONFIG_IMA_APPRAISE_BOOTPARAM
+	if (arch_ima_get_secureboot()) {
+		pr_info("Secure boot enabled: ignoring ima_appraise=%s boot parameter option",
+			str);
+		return 1;
+	}
+
 	if (strncmp(str, "off", 3) == 0)
 		ima_appraise = 0;
 	else if (strncmp(str, "log", 3) == 0)


