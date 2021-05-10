Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4463378553
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbhEJLAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234107AbhEJKzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C522B616EC;
        Mon, 10 May 2021 10:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643431;
        bh=RWpexhPvp66+Tff5MbWUMpq+NMkNjRW/PLGWLjp8PVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsN37qfGk1tV2sW3a55oywVre72J6WuCcGETuJYhqfLxD4eTwv/wYLHch6l3K5LcP
         SpDI7uCZetkCn9HjUxtSsHPqhtSN87X9ISpnlojbmVLy65c+NfiR/tiNqt+0HWe+pw
         lkeBl5nLfC6hz9SXeRc3++MwWzoJGDG0Iev3ouUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.11 013/342] tpm: acpi: Check eventlog signature before using it
Date:   Mon, 10 May 2021 12:16:43 +0200
Message-Id: <20210510102010.544839801@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

commit 3dcd15665aca80197333500a4be3900948afccc1 upstream.

Check the eventlog signature before using it. This avoids using an
empty log, as may be the case when QEMU created the ACPI tables,
rather than probing the EFI log next. This resolves an issue where
the EFI log was empty since an empty ACPI log was used.

Cc: stable@vger.kernel.org
Fixes: 85467f63a05c ("tpm: Add support for event log pointer found in TPM2 ACPI table")
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/acpi.c |   33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -41,6 +41,27 @@ struct acpi_tcpa {
 	};
 };
 
+/* Check that the given log is indeed a TPM2 log. */
+static bool tpm_is_tpm2_log(void *bios_event_log, u64 len)
+{
+	struct tcg_efi_specid_event_head *efispecid;
+	struct tcg_pcr_event *event_header;
+	int n;
+
+	if (len < sizeof(*event_header))
+		return false;
+	len -= sizeof(*event_header);
+	event_header = bios_event_log;
+
+	if (len < sizeof(*efispecid))
+		return false;
+	efispecid = (struct tcg_efi_specid_event_head *)event_header->event;
+
+	n = memcmp(efispecid->signature, TCG_SPECID_SIG,
+		   sizeof(TCG_SPECID_SIG));
+	return n == 0;
+}
+
 /* read binary bios log */
 int tpm_read_log_acpi(struct tpm_chip *chip)
 {
@@ -52,6 +73,7 @@ int tpm_read_log_acpi(struct tpm_chip *c
 	struct acpi_table_tpm2 *tbl;
 	struct acpi_tpm2_phy *tpm2_phy;
 	int format;
+	int ret;
 
 	log = &chip->log;
 
@@ -112,6 +134,7 @@ int tpm_read_log_acpi(struct tpm_chip *c
 
 	log->bios_event_log_end = log->bios_event_log + len;
 
+	ret = -EIO;
 	virt = acpi_os_map_iomem(start, len);
 	if (!virt)
 		goto err;
@@ -119,11 +142,19 @@ int tpm_read_log_acpi(struct tpm_chip *c
 	memcpy_fromio(log->bios_event_log, virt, len);
 
 	acpi_os_unmap_iomem(virt, len);
+
+	if (chip->flags & TPM_CHIP_FLAG_TPM2 &&
+	    !tpm_is_tpm2_log(log->bios_event_log, len)) {
+		/* try EFI log next */
+		ret = -ENODEV;
+		goto err;
+	}
+
 	return format;
 
 err:
 	kfree(log->bios_event_log);
 	log->bios_event_log = NULL;
-	return -EIO;
+	return ret;
 
 }


