Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD276CC299
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbjC1Oqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbjC1Oqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238A7D526
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DA70B80976
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC03EC4339B;
        Tue, 28 Mar 2023 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014763;
        bh=ELgJb/TfF+6wHFOaPQM9e1OqRYvHRsL/KSmNhtPisxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pStOdjq4nxUJYGh+GbaqzDVA6kPBCeNfJrRhYUa0hpHhUySfhOiGdU48rE0IWebf7
         ZWME1jdJ7gvW+oeC+ccH3pCa6+ZH8DBLiHHCsFqvsPdVlo5jWyuzqBiytbJxfXHo0U
         rxtIyzS+6xUBWZi65Cqkcktz/pOMQvxQXvu+e6KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrea Righi <andrea.righi@canonical.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 044/240] arm64: efi: Use SMBIOS processor version to key off Ampere quirk
Date:   Tue, 28 Mar 2023 16:40:07 +0200
Message-Id: <20230328142621.544265000@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit eb684408f3ea4856639675d6465f0024e498e4b1 ]

Instead of using the SMBIOS type 1 record 'family' field, which is often
modified by OEMs, use the type 4 'processor ID' and 'processor version'
fields, which are set to a small set of probe-able values on all known
Ampere EFI systems in the field.

Fixes: 550b33cfd4452968 ("arm64: efi: Force the use of ...")
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/arm64.c   | 39 +++++++++++++++++++-----
 drivers/firmware/efi/libstub/efistub.h | 41 ++++++++++++++++++++++++--
 drivers/firmware/efi/libstub/smbios.c  | 13 ++++++--
 3 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index 4501652e11ab6..84d94443c601d 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -16,20 +16,43 @@
 
 static bool system_needs_vamap(void)
 {
-	const u8 *type1_family = efi_get_smbios_string(1, family);
+	const struct efi_smbios_type4_record *record;
+	const u32 __aligned(1) *socid;
+	const u8 *version;
 
 	/*
 	 * Ampere eMAG, Altra, and Altra Max machines crash in SetTime() if
-	 * SetVirtualAddressMap() has not been called prior.
+	 * SetVirtualAddressMap() has not been called prior. Most Altra systems
+	 * can be identified by the SMCCC soc ID, which is conveniently exposed
+	 * via the type 4 SMBIOS records. Otherwise, test the processor version
+	 * field. eMAG systems all appear to have the processor version field
+	 * set to "eMAG".
 	 */
-	if (!type1_family || (
-	    strcmp(type1_family, "eMAG") &&
-	    strcmp(type1_family, "Altra") &&
-	    strcmp(type1_family, "Altra Max")))
+	record = (struct efi_smbios_type4_record *)efi_get_smbios_record(4);
+	if (!record)
 		return false;
 
-	efi_warn("Working around broken SetVirtualAddressMap()\n");
-	return true;
+	socid = (u32 *)record->processor_id;
+	switch (*socid & 0xffff000f) {
+		static char const altra[] = "Ampere(TM) Altra(TM) Processor";
+		static char const emag[] = "eMAG";
+
+	default:
+		version = efi_get_smbios_string(&record->header, 4,
+						processor_version);
+		if (!version || (strncmp(version, altra, sizeof(altra) - 1) &&
+				 strncmp(version, emag, sizeof(emag) - 1)))
+			break;
+
+		fallthrough;
+
+	case 0x0a160001:	// Altra
+	case 0x0a160002:	// Altra Max
+		efi_warn("Working around broken SetVirtualAddressMap()\n");
+		return true;
+	}
+
+	return false;
 }
 
 efi_status_t check_platform_features(void)
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 5b8f2c411ed82..f527816abab3e 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -1054,6 +1054,8 @@ struct efi_smbios_record {
 	u16	handle;
 };
 
+const struct efi_smbios_record *efi_get_smbios_record(u8 type);
+
 struct efi_smbios_type1_record {
 	struct efi_smbios_record	header;
 
@@ -1067,13 +1069,46 @@ struct efi_smbios_type1_record {
 	u8				family;
 };
 
-#define efi_get_smbios_string(__type, __name) ({			\
+struct efi_smbios_type4_record {
+	struct efi_smbios_record	header;
+
+	u8				socket;
+	u8				processor_type;
+	u8				processor_family;
+	u8				processor_manufacturer;
+	u8				processor_id[8];
+	u8				processor_version;
+	u8				voltage;
+	u16				external_clock;
+	u16				max_speed;
+	u16				current_speed;
+	u8				status;
+	u8				processor_upgrade;
+	u16				l1_cache_handle;
+	u16				l2_cache_handle;
+	u16				l3_cache_handle;
+	u8				serial_number;
+	u8				asset_tag;
+	u8				part_number;
+	u8				core_count;
+	u8				enabled_core_count;
+	u8				thread_count;
+	u16				processor_characteristics;
+	u16				processor_family2;
+	u16				core_count2;
+	u16				enabled_core_count2;
+	u16				thread_count2;
+	u16				thread_enabled;
+};
+
+#define efi_get_smbios_string(__record, __type, __name) ({		\
 	int size = sizeof(struct efi_smbios_type ## __type ## _record);	\
 	int off = offsetof(struct efi_smbios_type ## __type ## _record,	\
 			   __name);					\
-	__efi_get_smbios_string(__type, off, size);			\
+	__efi_get_smbios_string((__record), __type, off, size);		\
 })
 
-const u8 *__efi_get_smbios_string(u8 type, int offset, int recsize);
+const u8 *__efi_get_smbios_string(const struct efi_smbios_record *record,
+				  u8 type, int offset, int recsize);
 
 #endif
diff --git a/drivers/firmware/efi/libstub/smbios.c b/drivers/firmware/efi/libstub/smbios.c
index aadb422b9637d..f9c159c28f461 100644
--- a/drivers/firmware/efi/libstub/smbios.c
+++ b/drivers/firmware/efi/libstub/smbios.c
@@ -22,19 +22,28 @@ struct efi_smbios_protocol {
 	u8 minor_version;
 };
 
-const u8 *__efi_get_smbios_string(u8 type, int offset, int recsize)
+const struct efi_smbios_record *efi_get_smbios_record(u8 type)
 {
 	struct efi_smbios_record *record;
 	efi_smbios_protocol_t *smbios;
 	efi_status_t status;
 	u16 handle = 0xfffe;
-	const u8 *strtable;
 
 	status = efi_bs_call(locate_protocol, &EFI_SMBIOS_PROTOCOL_GUID, NULL,
 			     (void **)&smbios) ?:
 		 efi_call_proto(smbios, get_next, &handle, &type, &record, NULL);
 	if (status != EFI_SUCCESS)
 		return NULL;
+	return record;
+}
+
+const u8 *__efi_get_smbios_string(const struct efi_smbios_record *record,
+				  u8 type, int offset, int recsize)
+{
+	const u8 *strtable;
+
+	if (!record)
+		return NULL;
 
 	strtable = (u8 *)record + record->length;
 	for (int i = 1; i < ((u8 *)record)[offset]; i++) {
-- 
2.39.2



