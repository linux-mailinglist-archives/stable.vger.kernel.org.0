Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805773B6176
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhF1OgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234631AbhF1Odm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:33:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B2861CE0;
        Mon, 28 Jun 2021 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890473;
        bh=E/Pl6uYmGs31k+2sPZqoBcF8IfWm8rVBrvX/Sz9IVk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSaB12GfZQZiS0tCatB9kN5lRulvo6YdcLEEoqqd112flWDwgHwOQxFjJaPTMPTtt
         ZHyceTVnbgddsqjAJi3I9G3wqKVODt61Chv2q2KCa9JcT1MDMW8jMCnesNePrbXVTg
         01hYC+BBZKCLDzE8zS4jIHMRD3f7GV/8rby6TillDlpHL5k39cHMJW8u7xaecvteGt
         7TYhAfe7W8PXqVmWyi9XEMxW71qxxxip5uPtZ8bcX0c7ZZC8MWz6iI2nvpO7DYW5w1
         TPwfgkSHBSwRw2LmmSXl4ImU/R+jB8r8FOJoI+oYLrECTajv/r4VJdi2WvvcEQ+aeu
         s+XZ0fADTFEgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Snowberg <eric.snowberg@oracle.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, keyrings@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/101] certs: Add ability to preload revocation certs
Date:   Mon, 28 Jun 2021 10:26:05 -0400
Message-Id: <20210628142607.32218-100-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Snowberg <eric.snowberg@oracle.com>

[ Upstream commit d1f044103dad70c1cec0a8f3abdf00834fec8b98 ]

Add a new Kconfig option called SYSTEM_REVOCATION_KEYS. If set,
this option should be the filename of a PEM-formated file containing
X.509 certificates to be included in the default blacklist keyring.

DH Changes:
 - Make the new Kconfig option depend on SYSTEM_REVOCATION_LIST.
 - Fix SYSTEM_REVOCATION_KEYS=n, but CONFIG_SYSTEM_REVOCATION_LIST=y[1][2].
 - Use CONFIG_SYSTEM_REVOCATION_LIST for extract-cert[3].
 - Use CONFIG_SYSTEM_REVOCATION_LIST for revocation_certificates.o[3].

Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Randy Dunlap <rdunlap@infradead.org>
cc: keyrings@vger.kernel.org
Link: https://lore.kernel.org/r/e1c15c74-82ce-3a69-44de-a33af9b320ea@infradead.org/ [1]
Link: https://lore.kernel.org/r/20210303034418.106762-1-eric.snowberg@oracle.com/ [2]
Link: https://lore.kernel.org/r/20210304175030.184131-1-eric.snowberg@oracle.com/ [3]
Link: https://lore.kernel.org/r/20200930201508.35113-3-eric.snowberg@oracle.com/
Link: https://lore.kernel.org/r/20210122181054.32635-4-eric.snowberg@oracle.com/ # v5
Link: https://lore.kernel.org/r/161428673564.677100.4112098280028451629.stgit@warthog.procyon.org.uk/
Link: https://lore.kernel.org/r/161433312452.902181.4146169951896577982.stgit@warthog.procyon.org.uk/ # v2
Link: https://lore.kernel.org/r/161529606657.163428.3340689182456495390.stgit@warthog.procyon.org.uk/ # v3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 certs/Kconfig                   |  8 ++++++++
 certs/Makefile                  | 19 +++++++++++++++++--
 certs/blacklist.c               | 21 +++++++++++++++++++++
 certs/revocation_certificates.S | 21 +++++++++++++++++++++
 scripts/Makefile                |  1 +
 5 files changed, 68 insertions(+), 2 deletions(-)
 create mode 100644 certs/revocation_certificates.S

diff --git a/certs/Kconfig b/certs/Kconfig
index 76e469b56a77..ab88d2a7f3c7 100644
--- a/certs/Kconfig
+++ b/certs/Kconfig
@@ -92,4 +92,12 @@ config SYSTEM_REVOCATION_LIST
 	  blacklist keyring and implements a hook whereby a PKCS#7 message can
 	  be checked to see if it matches such a certificate.
 
+config SYSTEM_REVOCATION_KEYS
+	string "X.509 certificates to be preloaded into the system blacklist keyring"
+	depends on SYSTEM_REVOCATION_LIST
+	help
+	  If set, this option should be the filename of a PEM-formatted file
+	  containing X.509 certificates to be included in the default blacklist
+	  keyring.
+
 endmenu
diff --git a/certs/Makefile b/certs/Makefile
index f4b90bad8690..b6db52ebf0be 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -4,7 +4,8 @@
 #
 
 obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o common.o
-obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist.o
+obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist.o common.o
+obj-$(CONFIG_SYSTEM_REVOCATION_LIST) += revocation_certificates.o
 ifneq ($(CONFIG_SYSTEM_BLACKLIST_HASH_LIST),"")
 obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist_hashes.o
 else
@@ -29,7 +30,7 @@ $(obj)/x509_certificate_list: scripts/extract-cert $(SYSTEM_TRUSTED_KEYS_SRCPREF
 	$(call if_changed,extract_certs,$(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(CONFIG_SYSTEM_TRUSTED_KEYS))
 endif # CONFIG_SYSTEM_TRUSTED_KEYRING
 
-clean-files := x509_certificate_list .x509.list
+clean-files := x509_certificate_list .x509.list x509_revocation_list
 
 ifeq ($(CONFIG_MODULE_SIG),y)
 ###############################################################################
@@ -104,3 +105,17 @@ targets += signing_key.x509
 $(obj)/signing_key.x509: scripts/extract-cert $(X509_DEP) FORCE
 	$(call if_changed,extract_certs,$(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_SIG_KEY))
 endif # CONFIG_MODULE_SIG
+
+ifeq ($(CONFIG_SYSTEM_REVOCATION_LIST),y)
+
+$(eval $(call config_filename,SYSTEM_REVOCATION_KEYS))
+
+$(obj)/revocation_certificates.o: $(obj)/x509_revocation_list
+
+quiet_cmd_extract_certs  = EXTRACT_CERTS   $(patsubst "%",%,$(2))
+      cmd_extract_certs  = scripts/extract-cert $(2) $@
+
+targets += x509_revocation_list
+$(obj)/x509_revocation_list: scripts/extract-cert $(SYSTEM_REVOCATION_KEYS_SRCPREFIX)$(SYSTEM_REVOCATION_KEYS_FILENAME) FORCE
+	$(call if_changed,extract_certs,$(SYSTEM_REVOCATION_KEYS_SRCPREFIX)$(CONFIG_SYSTEM_REVOCATION_KEYS))
+endif
diff --git a/certs/blacklist.c b/certs/blacklist.c
index 59b2f106b294..c973de883cf0 100644
--- a/certs/blacklist.c
+++ b/certs/blacklist.c
@@ -16,9 +16,15 @@
 #include <linux/seq_file.h>
 #include <keys/system_keyring.h>
 #include "blacklist.h"
+#include "common.h"
 
 static struct key *blacklist_keyring;
 
+#ifdef CONFIG_SYSTEM_REVOCATION_LIST
+extern __initconst const u8 revocation_certificate_list[];
+extern __initconst const unsigned long revocation_certificate_list_size;
+#endif
+
 /*
  * The description must be a type prefix, a colon and then an even number of
  * hex digits.  The hash is kept in the description.
@@ -220,3 +226,18 @@ static int __init blacklist_init(void)
  * Must be initialised before we try and load the keys into the keyring.
  */
 device_initcall(blacklist_init);
+
+#ifdef CONFIG_SYSTEM_REVOCATION_LIST
+/*
+ * Load the compiled-in list of revocation X.509 certificates.
+ */
+static __init int load_revocation_certificate_list(void)
+{
+	if (revocation_certificate_list_size)
+		pr_notice("Loading compiled-in revocation X.509 certificates\n");
+
+	return load_certificate_list(revocation_certificate_list, revocation_certificate_list_size,
+				     blacklist_keyring);
+}
+late_initcall(load_revocation_certificate_list);
+#endif
diff --git a/certs/revocation_certificates.S b/certs/revocation_certificates.S
new file mode 100644
index 000000000000..f21aae8a8f0e
--- /dev/null
+++ b/certs/revocation_certificates.S
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/export.h>
+#include <linux/init.h>
+
+	__INITRODATA
+
+	.align 8
+	.globl revocation_certificate_list
+revocation_certificate_list:
+__revocation_list_start:
+	.incbin "certs/x509_revocation_list"
+__revocation_list_end:
+
+	.align 8
+	.globl revocation_certificate_list_size
+revocation_certificate_list_size:
+#ifdef CONFIG_64BIT
+	.quad __revocation_list_end - __revocation_list_start
+#else
+	.long __revocation_list_end - __revocation_list_start
+#endif
diff --git a/scripts/Makefile b/scripts/Makefile
index c36106bce80e..9adb6d247818 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -14,6 +14,7 @@ hostprogs-always-$(CONFIG_ASN1)				+= asn1_compiler
 hostprogs-always-$(CONFIG_MODULE_SIG_FORMAT)		+= sign-file
 hostprogs-always-$(CONFIG_SYSTEM_TRUSTED_KEYRING)	+= extract-cert
 hostprogs-always-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE)	+= insert-sys-cert
+hostprogs-always-$(CONFIG_SYSTEM_REVOCATION_LIST)	+= extract-cert
 
 HOSTCFLAGS_sorttable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
-- 
2.30.2

