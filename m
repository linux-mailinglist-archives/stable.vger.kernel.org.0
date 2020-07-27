Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136A422EFED
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731544AbgG0OUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731537AbgG0OUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232F52070A;
        Mon, 27 Jul 2020 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859624;
        bh=RLcNaTNA714BH6ClK6+z16LsGIqxCzLk7P66mk78IQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtpUKlidBSPpvAg2W5qGOJvG9BCSRgq1f7Ma3c6QHl2wI1EP/UNfMEtbAOxDEH6fj
         XFvUew3xUcTLcbLtivcRdcVmuZaOAPEztPy+yz1HioP7bkd/vvGe6cY5sgYaewZOuc
         rGnsyd8ZnUqhsJB5Dp0F44vgvDeHq77Q/LmdYNW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 042/179] efi/efivars: Expose RT service availability via efivars abstraction
Date:   Mon, 27 Jul 2020 16:03:37 +0200
Message-Id: <20200727134934.729499958@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit f88814cc2578c121e6edef686365036db72af0ed ]

Commit

  bf67fad19e493b ("efi: Use more granular check for availability for variable services")

introduced a check into the efivarfs, efi-pstore and other drivers that
aborts loading of the module if not all three variable runtime services
(GetVariable, SetVariable and GetNextVariable) are supported. However, this
results in efivarfs being unavailable entirely if only SetVariable support
is missing, which is only needed if you want to make any modifications.
Also, efi-pstore and the sysfs EFI variable interface could be backed by
another implementation of the 'efivars' abstraction, in which case it is
completely irrelevant which services are supported by the EFI firmware.

So make the generic 'efivars' abstraction dependent on the availibility of
the GetVariable and GetNextVariable EFI runtime services, and add a helper
'efivar_supports_writes()' to find out whether the currently active efivars
abstraction supports writes (and wire it up to the availability of
SetVariable for the generic one).

Then, use the efivar_supports_writes() helper to decide whether to permit
efivarfs to be mounted read-write, and whether to enable efi-pstore or the
sysfs EFI variable interface altogether.

Fixes: bf67fad19e493b ("efi: Use more granular check for availability for variable services")
Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/efi-pstore.c |  5 +----
 drivers/firmware/efi/efi.c        | 12 ++++++++----
 drivers/firmware/efi/efivars.c    |  5 +----
 drivers/firmware/efi/vars.c       |  6 ++++++
 fs/efivarfs/super.c               |  6 +++---
 include/linux/efi.h               |  1 +
 6 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index c2f1d4e6630b1..feb7fe6f2da76 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -356,10 +356,7 @@ static struct pstore_info efi_pstore_info = {
 
 static __init int efivars_pstore_init(void)
 {
-	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_VARIABLE_SERVICES))
-		return 0;
-
-	if (!efivars_kobject())
+	if (!efivars_kobject() || !efivar_supports_writes())
 		return 0;
 
 	if (efivars_pstore_disable)
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 20a7ba47a7924..99446b3847265 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -176,11 +176,13 @@ static struct efivar_operations generic_ops;
 static int generic_ops_register(void)
 {
 	generic_ops.get_variable = efi.get_variable;
-	generic_ops.set_variable = efi.set_variable;
-	generic_ops.set_variable_nonblocking = efi.set_variable_nonblocking;
 	generic_ops.get_next_variable = efi.get_next_variable;
 	generic_ops.query_variable_store = efi_query_variable_store;
 
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_SET_VARIABLE)) {
+		generic_ops.set_variable = efi.set_variable;
+		generic_ops.set_variable_nonblocking = efi.set_variable_nonblocking;
+	}
 	return efivars_register(&generic_efivars, &generic_ops, efi_kobj);
 }
 
@@ -382,7 +384,8 @@ static int __init efisubsys_init(void)
 		return -ENOMEM;
 	}
 
-	if (efi_rt_services_supported(EFI_RT_SUPPORTED_VARIABLE_SERVICES)) {
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
+				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME)) {
 		efivar_ssdt_load();
 		error = generic_ops_register();
 		if (error)
@@ -416,7 +419,8 @@ static int __init efisubsys_init(void)
 err_remove_group:
 	sysfs_remove_group(efi_kobj, &efi_subsys_attr_group);
 err_unregister:
-	if (efi_rt_services_supported(EFI_RT_SUPPORTED_VARIABLE_SERVICES))
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE |
+				      EFI_RT_SUPPORTED_GET_NEXT_VARIABLE_NAME))
 		generic_ops_unregister();
 err_put:
 	kobject_put(efi_kobj);
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 26528a46d99e9..dcea137142b3c 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -680,11 +680,8 @@ int efivars_sysfs_init(void)
 	struct kobject *parent_kobj = efivars_kobject();
 	int error = 0;
 
-	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_VARIABLE_SERVICES))
-		return -ENODEV;
-
 	/* No efivars has been registered yet */
-	if (!parent_kobj)
+	if (!parent_kobj || !efivar_supports_writes())
 		return 0;
 
 	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 5f2a4d162795c..973eef234b365 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -1229,3 +1229,9 @@ out:
 	return rv;
 }
 EXPORT_SYMBOL_GPL(efivars_unregister);
+
+int efivar_supports_writes(void)
+{
+	return __efivars && __efivars->ops->set_variable;
+}
+EXPORT_SYMBOL_GPL(efivar_supports_writes);
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12c66f5d92dd2..28bb5689333a5 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -201,6 +201,9 @@ static int efivarfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_d_op		= &efivarfs_d_ops;
 	sb->s_time_gran         = 1;
 
+	if (!efivar_supports_writes())
+		sb->s_flags |= SB_RDONLY;
+
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0, true);
 	if (!inode)
 		return -ENOMEM;
@@ -252,9 +255,6 @@ static struct file_system_type efivarfs_type = {
 
 static __init int efivarfs_init(void)
 {
-	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_VARIABLE_SERVICES))
-		return -ENODEV;
-
 	if (!efivars_kobject())
 		return -ENODEV;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 9430d01c0c3d3..650794abfa326 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -991,6 +991,7 @@ int efivars_register(struct efivars *efivars,
 int efivars_unregister(struct efivars *efivars);
 struct kobject *efivars_kobject(void);
 
+int efivar_supports_writes(void);
 int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		void *data, bool duplicates, struct list_head *head);
 
-- 
2.25.1



