Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F84921A7
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344991AbiARIv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:51:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33930 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiARIv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:51:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA32B81223
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C64EC00446;
        Tue, 18 Jan 2022 08:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642495916;
        bh=mmbRE72LXYbOsY3SOlsfgoZ86qujado8EjYBxG74Afs=;
        h=Subject:To:Cc:From:Date:From;
        b=klWbUjqDDInj6oMyl4MX/uxHgzrpONq/y3ZjTiBTio1HQ/ZVvp0sSHhrmbc9hru14
         149LExtyJs3befFbALUSl0jCCxTL1Y3neYEkQJW8pzhUz6Qr2pzykBu/lh16f+nKxO
         LkTicCqnNEbZg/ObN9d26TG0egrab2x1eQ2mgiNg=
Subject: FAILED: patch "[PATCH] firmware: qemu_fw_cfg: fix kobject leak in probe error path" failed to apply to 4.9-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org, somlo@cmu.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 09:51:45 +0100
Message-ID: <16424959052209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 47a1db8e797da01a1309bf42e0c0d771d4e4d4f3 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 1 Dec 2021 14:25:26 +0100
Subject: [PATCH] firmware: qemu_fw_cfg: fix kobject leak in probe error path

An initialised kobject must be freed using kobject_put() to avoid
leaking associated resources (e.g. the object name).

Commit fe3c60684377 ("firmware: Fix a reference count leak.") "fixed"
the leak in the first error path of the file registration helper but
left the second one unchanged. This "fix" would however result in a NULL
pointer dereference due to the release function also removing the never
added entry from the fw_cfg_entry_cache list. This has now been
addressed.

Fix the remaining kobject leak by restoring the common error path and
adding the missing kobject_put().

Fixes: 75f3e8e47f38 ("firmware: introduce sysfs driver for QEMU's fw_cfg device")
Cc: stable@vger.kernel.org      # 4.6
Cc: Gabriel Somlo <somlo@cmu.edu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211201132528.30025-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index a9c64ebfc49a..ccb7ed62452f 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -603,15 +603,13 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)
 	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
 	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,
 				   fw_cfg_sel_ko, "%d", entry->select);
-	if (err) {
-		kobject_put(&entry->kobj);
-		return err;
-	}
+	if (err)
+		goto err_put_entry;
 
 	/* add raw binary content access */
 	err = sysfs_create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);
 	if (err)
-		goto err_add_raw;
+		goto err_del_entry;
 
 	/* try adding "/sys/firmware/qemu_fw_cfg/by_name/" symlink */
 	fw_cfg_build_symlink(fw_cfg_fname_kset, &entry->kobj, entry->name);
@@ -620,9 +618,10 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)
 	fw_cfg_sysfs_cache_enlist(entry);
 	return 0;
 
-err_add_raw:
+err_del_entry:
 	kobject_del(&entry->kobj);
-	kfree(entry);
+err_put_entry:
+	kobject_put(&entry->kobj);
 	return err;
 }
 

