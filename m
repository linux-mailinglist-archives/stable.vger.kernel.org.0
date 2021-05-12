Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B570D37CCA3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244442AbhELQp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239454AbhELQjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 002D961E2B;
        Wed, 12 May 2021 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835410;
        bh=zCWNzPnSjRIm15SvtBgEAAkQMnFavHcUKs4jMKgd/Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tp79N3eBvv7ZwJnoFTnQi676zMIvJo7A5aNLDEZEvC6n8Z6/MhuRUKOdwzBFLGxyX
         0p6D/rqBrAV0I2jpFKcF/BgK3DmK5OO/o7il8sZyoWUx9giQM52mVZZ16RV874uStQ
         4h/AcbQvVpjZRlhS7bQscftvIfw5kOMSr0DWFkTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Chris von Recklinghausen <crecklin@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 332/677] PM: hibernate: x86: Use crc32 instead of md5 for hibernation e820 integrity check
Date:   Wed, 12 May 2021 16:46:18 +0200
Message-Id: <20210512144848.297389097@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris von Recklinghausen <crecklin@redhat.com>

[ Upstream commit f5d1499ae2096d7ea301023c4cc54e427300eb0a ]

Hibernation fails on a system in fips mode because md5 is used for the e820
integrity check and is not available. Use crc32 instead.

The check is intended to detect whether the E820 memory map provided
by the firmware after cold boot unexpectedly differs from the one that
was in use when the hibernation image was created. In this case, the
hibernation image cannot be restored, as it may cover memory regions
that are no longer available to the OS.

A non-cryptographic checksum such as CRC-32 is sufficient to detect such
inadvertent deviations.

Fixes: 62a03defeabd ("PM / hibernate: Verify the consistent of e820 memory map by md5 digest")
Reviewed-by: Eric Biggers <ebiggers@google.com>
Tested-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Chris von Recklinghausen <crecklin@redhat.com>
[ rjw: Subject edit ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/e820.c     |  4 +-
 arch/x86/power/hibernate.c | 89 ++++++--------------------------------
 2 files changed, 16 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 22aad412f965..629c4994f165 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -31,8 +31,8 @@
  *       - inform the user about the firmware's notion of memory layout
  *         via /sys/firmware/memmap
  *
- *       - the hibernation code uses it to generate a kernel-independent MD5
- *         fingerprint of the physical memory layout of a system.
+ *       - the hibernation code uses it to generate a kernel-independent CRC32
+ *         checksum of the physical memory layout of a system.
  *
  * - 'e820_table_kexec': a slightly modified (by the kernel) firmware version
  *   passed to us by the bootloader - the major difference between
diff --git a/arch/x86/power/hibernate.c b/arch/x86/power/hibernate.c
index cd3914fc9f3d..e94e0050a583 100644
--- a/arch/x86/power/hibernate.c
+++ b/arch/x86/power/hibernate.c
@@ -13,8 +13,8 @@
 #include <linux/kdebug.h>
 #include <linux/cpu.h>
 #include <linux/pgtable.h>
-
-#include <crypto/hash.h>
+#include <linux/types.h>
+#include <linux/crc32.h>
 
 #include <asm/e820/api.h>
 #include <asm/init.h>
@@ -54,95 +54,33 @@ int pfn_is_nosave(unsigned long pfn)
 	return pfn >= nosave_begin_pfn && pfn < nosave_end_pfn;
 }
 
-
-#define MD5_DIGEST_SIZE 16
-
 struct restore_data_record {
 	unsigned long jump_address;
 	unsigned long jump_address_phys;
 	unsigned long cr3;
 	unsigned long magic;
-	u8 e820_digest[MD5_DIGEST_SIZE];
+	unsigned long e820_checksum;
 };
 
-#if IS_BUILTIN(CONFIG_CRYPTO_MD5)
 /**
- * get_e820_md5 - calculate md5 according to given e820 table
+ * compute_e820_crc32 - calculate crc32 of a given e820 table
  *
  * @table: the e820 table to be calculated
- * @buf: the md5 result to be stored to
+ *
+ * Return: the resulting checksum
  */
-static int get_e820_md5(struct e820_table *table, void *buf)
+static inline u32 compute_e820_crc32(struct e820_table *table)
 {
-	struct crypto_shash *tfm;
-	struct shash_desc *desc;
-	int size;
-	int ret = 0;
-
-	tfm = crypto_alloc_shash("md5", 0, 0);
-	if (IS_ERR(tfm))
-		return -ENOMEM;
-
-	desc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
-		       GFP_KERNEL);
-	if (!desc) {
-		ret = -ENOMEM;
-		goto free_tfm;
-	}
-
-	desc->tfm = tfm;
-
-	size = offsetof(struct e820_table, entries) +
+	int size = offsetof(struct e820_table, entries) +
 		sizeof(struct e820_entry) * table->nr_entries;
 
-	if (crypto_shash_digest(desc, (u8 *)table, size, buf))
-		ret = -EINVAL;
-
-	kfree_sensitive(desc);
-
-free_tfm:
-	crypto_free_shash(tfm);
-	return ret;
-}
-
-static int hibernation_e820_save(void *buf)
-{
-	return get_e820_md5(e820_table_firmware, buf);
-}
-
-static bool hibernation_e820_mismatch(void *buf)
-{
-	int ret;
-	u8 result[MD5_DIGEST_SIZE];
-
-	memset(result, 0, MD5_DIGEST_SIZE);
-	/* If there is no digest in suspend kernel, let it go. */
-	if (!memcmp(result, buf, MD5_DIGEST_SIZE))
-		return false;
-
-	ret = get_e820_md5(e820_table_firmware, result);
-	if (ret)
-		return true;
-
-	return memcmp(result, buf, MD5_DIGEST_SIZE) ? true : false;
-}
-#else
-static int hibernation_e820_save(void *buf)
-{
-	return 0;
-}
-
-static bool hibernation_e820_mismatch(void *buf)
-{
-	/* If md5 is not builtin for restore kernel, let it go. */
-	return false;
+	return ~crc32_le(~0, (unsigned char const *)table, size);
 }
-#endif
 
 #ifdef CONFIG_X86_64
-#define RESTORE_MAGIC	0x23456789ABCDEF01UL
+#define RESTORE_MAGIC	0x23456789ABCDEF02UL
 #else
-#define RESTORE_MAGIC	0x12345678UL
+#define RESTORE_MAGIC	0x12345679UL
 #endif
 
 /**
@@ -179,7 +117,8 @@ int arch_hibernation_header_save(void *addr, unsigned int max_size)
 	 */
 	rdr->cr3 = restore_cr3 & ~CR3_PCID_MASK;
 
-	return hibernation_e820_save(rdr->e820_digest);
+	rdr->e820_checksum = compute_e820_crc32(e820_table_firmware);
+	return 0;
 }
 
 /**
@@ -200,7 +139,7 @@ int arch_hibernation_header_restore(void *addr)
 	jump_address_phys = rdr->jump_address_phys;
 	restore_cr3 = rdr->cr3;
 
-	if (hibernation_e820_mismatch(rdr->e820_digest)) {
+	if (rdr->e820_checksum != compute_e820_crc32(e820_table_firmware)) {
 		pr_crit("Hibernate inconsistent memory map detected!\n");
 		return -ENODEV;
 	}
-- 
2.30.2



