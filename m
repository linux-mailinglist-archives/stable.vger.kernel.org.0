Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13FDA17D4E0
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 17:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgCHQih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 12:38:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:56798 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgCHQih (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 12:38:37 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jAywj-0007Uz-GD; Sun, 08 Mar 2020 17:38:33 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 02D481C221C;
        Sun,  8 Mar 2020 17:38:33 +0100 (CET)
Date:   Sun, 08 Mar 2020 16:38:32 -0000
From:   "tip-bot2 for Vladis Dronov" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi: Add a sanity check to efivar_store_raw()
Cc:     Vladis Dronov <vdronov@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200305084041.24053-3-vdronov@redhat.com>
References: <20200305084041.24053-3-vdronov@redhat.com>
MIME-Version: 1.0
Message-ID: <158368551265.28353.5476421599260286182.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     d6c066fda90d578aacdf19771a027ed484a79825
Gitweb:        https://git.kernel.org/tip/d6c066fda90d578aacdf19771a027ed484a79825
Author:        Vladis Dronov <vdronov@redhat.com>
AuthorDate:    Sun, 08 Mar 2020 09:08:55 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Sun, 08 Mar 2020 09:56:48 +01:00

efi: Add a sanity check to efivar_store_raw()

Add a sanity check to efivar_store_raw() the same way
efivar_{attr,size,data}_read() and efivar_show_raw() have it.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200305084041.24053-3-vdronov@redhat.com
Link: https://lore.kernel.org/r/20200308080859.21568-25-ardb@kernel.org
---
 drivers/firmware/efi/efivars.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 69f13bc..aff3dfb 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -208,6 +208,9 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	u8 *data;
 	int err;
 
+	if (!entry || !buf)
+		return -EINVAL;
+
 	if (in_compat_syscall()) {
 		struct compat_efi_variable *compat;
 
