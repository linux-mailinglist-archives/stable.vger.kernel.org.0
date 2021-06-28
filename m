Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658EB3B607E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbhF1OZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232506AbhF1OXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:23:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FAB561C76;
        Mon, 28 Jun 2021 14:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890022;
        bh=bfqc03KbP+M36x2bY0Cu14nwEXvpv+kUEFrCEtTNsAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUXNC7flpn2URWO5qbi6pEWwC8uHDif4oNm9WBMzOgxzhBrMmuy+0eKM53k1sN8ik
         GeTcMczbAdCLF+52WcIHYCe0etGkGGauu09MS1Q0KYYaY1h7Qjrj8tKqE2cEqxnthQ
         06FLtX/nMmNi70OIYyiPPykqxrUgfeknZVShT0hc9esl7K2hrWfBcev6MRj2gGG4lv
         MqDO8MoxgKDoBMeTojm37fwJjq+xWxw0mDV0MepACGm/s+qsKBcb2h6GM4GBJ+fIfq
         V4EI0cFGf7gFSzwwhYHlnTqbRchw3Ha2cE1ty/XEy8DtMCuQmtSo0JKTYkLMJ2kaFn
         vKOYYX7mAmRZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Snowberg <eric.snowberg@oracle.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 107/110] certs: Move load_system_certificate_list to a common function
Date:   Mon, 28 Jun 2021 10:18:25 -0400
Message-Id: <20210628141828.31757-108-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Snowberg <eric.snowberg@oracle.com>

[ Upstream commit 2565ca7f5ec1a98d51eea8860c4ab923f1ca2c85 ]

Move functionality within load_system_certificate_list to a common
function, so it can be reused in the future.

DH Changes:
 - Added inclusion of common.h to common.c (Eric [1]).

Signed-off-by: Eric Snowberg <eric.snowberg@oracle.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: keyrings@vger.kernel.org
Link: https://lore.kernel.org/r/EDA280F9-F72D-4181-93C7-CDBE95976FF7@oracle.com/ [1]
Link: https://lore.kernel.org/r/20200930201508.35113-2-eric.snowberg@oracle.com/
Link: https://lore.kernel.org/r/20210122181054.32635-3-eric.snowberg@oracle.com/ # v5
Link: https://lore.kernel.org/r/161428672825.677100.7545516389752262918.stgit@warthog.procyon.org.uk/
Link: https://lore.kernel.org/r/161433311696.902181.3599366124784670368.stgit@warthog.procyon.org.uk/ # v2
Link: https://lore.kernel.org/r/161529605850.163428.7786675680201528556.stgit@warthog.procyon.org.uk/ # v3
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 certs/Makefile         |  2 +-
 certs/common.c         | 57 ++++++++++++++++++++++++++++++++++++++++++
 certs/common.h         |  9 +++++++
 certs/system_keyring.c | 49 +++---------------------------------
 4 files changed, 70 insertions(+), 47 deletions(-)
 create mode 100644 certs/common.c
 create mode 100644 certs/common.h

diff --git a/certs/Makefile b/certs/Makefile
index f4c25b67aad9..f4b90bad8690 100644
--- a/certs/Makefile
+++ b/certs/Makefile
@@ -3,7 +3,7 @@
 # Makefile for the linux kernel signature checking certificates.
 #
 
-obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o
+obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += system_keyring.o system_certificates.o common.o
 obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist.o
 ifneq ($(CONFIG_SYSTEM_BLACKLIST_HASH_LIST),"")
 obj-$(CONFIG_SYSTEM_BLACKLIST_KEYRING) += blacklist_hashes.o
diff --git a/certs/common.c b/certs/common.c
new file mode 100644
index 000000000000..16a220887a53
--- /dev/null
+++ b/certs/common.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/kernel.h>
+#include <linux/key.h>
+#include "common.h"
+
+int load_certificate_list(const u8 cert_list[],
+			  const unsigned long list_size,
+			  const struct key *keyring)
+{
+	key_ref_t key;
+	const u8 *p, *end;
+	size_t plen;
+
+	p = cert_list;
+	end = p + list_size;
+	while (p < end) {
+		/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
+		 * than 256 bytes in size.
+		 */
+		if (end - p < 4)
+			goto dodgy_cert;
+		if (p[0] != 0x30 &&
+		    p[1] != 0x82)
+			goto dodgy_cert;
+		plen = (p[2] << 8) | p[3];
+		plen += 4;
+		if (plen > end - p)
+			goto dodgy_cert;
+
+		key = key_create_or_update(make_key_ref(keyring, 1),
+					   "asymmetric",
+					   NULL,
+					   p,
+					   plen,
+					   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					   KEY_USR_VIEW | KEY_USR_READ),
+					   KEY_ALLOC_NOT_IN_QUOTA |
+					   KEY_ALLOC_BUILT_IN |
+					   KEY_ALLOC_BYPASS_RESTRICTION);
+		if (IS_ERR(key)) {
+			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
+			       PTR_ERR(key));
+		} else {
+			pr_notice("Loaded X.509 cert '%s'\n",
+				  key_ref_to_ptr(key)->description);
+			key_ref_put(key);
+		}
+		p += plen;
+	}
+
+	return 0;
+
+dodgy_cert:
+	pr_err("Problem parsing in-kernel X.509 certificate list\n");
+	return 0;
+}
diff --git a/certs/common.h b/certs/common.h
new file mode 100644
index 000000000000..abdb5795936b
--- /dev/null
+++ b/certs/common.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _CERT_COMMON_H
+#define _CERT_COMMON_H
+
+int load_certificate_list(const u8 cert_list[], const unsigned long list_size,
+			  const struct key *keyring);
+
+#endif
diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index ed98754d5795..0c9a4795e847 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -16,6 +16,7 @@
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
 #include <crypto/pkcs7.h>
+#include "common.h"
 
 static struct key *builtin_trusted_keys;
 #ifdef CONFIG_SECONDARY_TRUSTED_KEYRING
@@ -137,54 +138,10 @@ device_initcall(system_trusted_keyring_init);
  */
 static __init int load_system_certificate_list(void)
 {
-	key_ref_t key;
-	const u8 *p, *end;
-	size_t plen;
-
 	pr_notice("Loading compiled-in X.509 certificates\n");
 
-	p = system_certificate_list;
-	end = p + system_certificate_list_size;
-	while (p < end) {
-		/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
-		 * than 256 bytes in size.
-		 */
-		if (end - p < 4)
-			goto dodgy_cert;
-		if (p[0] != 0x30 &&
-		    p[1] != 0x82)
-			goto dodgy_cert;
-		plen = (p[2] << 8) | p[3];
-		plen += 4;
-		if (plen > end - p)
-			goto dodgy_cert;
-
-		key = key_create_or_update(make_key_ref(builtin_trusted_keys, 1),
-					   "asymmetric",
-					   NULL,
-					   p,
-					   plen,
-					   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
-					   KEY_USR_VIEW | KEY_USR_READ),
-					   KEY_ALLOC_NOT_IN_QUOTA |
-					   KEY_ALLOC_BUILT_IN |
-					   KEY_ALLOC_BYPASS_RESTRICTION);
-		if (IS_ERR(key)) {
-			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
-			       PTR_ERR(key));
-		} else {
-			pr_notice("Loaded X.509 cert '%s'\n",
-				  key_ref_to_ptr(key)->description);
-			key_ref_put(key);
-		}
-		p += plen;
-	}
-
-	return 0;
-
-dodgy_cert:
-	pr_err("Problem parsing in-kernel X.509 certificate list\n");
-	return 0;
+	return load_certificate_list(system_certificate_list, system_certificate_list_size,
+				     builtin_trusted_keys);
 }
 late_initcall(load_system_certificate_list);
 
-- 
2.30.2

