Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933C529F3A7
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 18:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgJ2RzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 13:55:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37849 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgJ2RzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 13:55:00 -0400
Received: from 2.general.dannf.us.vpn ([10.172.65.1] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dann.frazier@canonical.com>)
        id 1kYC8Y-0003Pf-HJ; Thu, 29 Oct 2020 17:54:58 +0000
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org
Cc:     Michael Schaller <misch@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Jeremy Kerr <jk@ozlabs.org>, linux-efi@vger.kernel.org
Subject: [PATCH 4.4-5.9] efivarfs: Replace invalid slashes with exclamation marks in dentries.
Date:   Thu, 29 Oct 2020 11:54:42 -0600
Message-Id: <20201029175442.564282-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Schaller <misch@google.com>

commit 336af6a4686d885a067ecea8c3c3dd129ba4fc75 upstream

Without this patch efivarfs_alloc_dentry creates dentries with slashes in
their name if the respective EFI variable has slashes in its name. This in
turn causes EIO on getdents64, which prevents a complete directory listing
of /sys/firmware/efi/efivars/.

This patch replaces the invalid shlashes with exclamation marks like
kobject_set_name_vargs does for /sys/firmware/efi/vars/ to have consistently
named dentries under /sys/firmware/efi/vars/ and /sys/firmware/efi/efivars/.

Signed-off-by: Michael Schaller <misch@google.com>
Link: https://lore.kernel.org/r/20200925074502.150448-1-misch@google.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

---

This addresses an issue that breaks Ubuntu installs on platforms that have
variable names as described above. One of our installers needs to sort
the BootOrder to keep BootCurrent at the front, but this fails when the
variable BootCurrent points at appears to not exist due to this issue.

Ref: https://bugs.launchpad.net/bugs/1899993

fs/efivarfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 28bb5689333a..15880a68faad 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -141,6 +141,9 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 
 	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
 
+	/* replace invalid slashes like kobject_set_name_vargs does for /sys/firmware/efi/vars. */
+	strreplace(name, '/', '!');
+
 	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0,
 				   is_removable);
 	if (!inode)
-- 
2.29.1

