Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D70492ACC
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347093AbiARQNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:13:14 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41534 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346878AbiARQLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:11:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 560B9CE1A47;
        Tue, 18 Jan 2022 16:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1A4C340E0;
        Tue, 18 Jan 2022 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522290;
        bh=UYYUMo1mUrFFL/7scIcn9NFrEorA5XJbOgmC+sLMyaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yybq71osKvpqsHMa0dwRIey7vsFWc1m32qO1LPN4lE6j/xqaQEN/zMB8XAXglAcXZ
         5p7mArqHSDrGNUNOKzgPtoqeyMKOE1uiT0LuWk/219I2F3L3GFnq7McPoR/Y4vBh9w
         LCORkPyumh3d5vJKkIcan1OF4Lw8/abPQJGCi7IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Somlo <somlo@cmu.edu>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.16 20/28] firmware: qemu_fw_cfg: fix kobject leak in probe error path
Date:   Tue, 18 Jan 2022 17:06:15 +0100
Message-Id: <20220118160453.070650749@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 47a1db8e797da01a1309bf42e0c0d771d4e4d4f3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qemu_fw_cfg.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -603,15 +603,13 @@ static int fw_cfg_register_file(const st
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
@@ -620,9 +618,10 @@ static int fw_cfg_register_file(const st
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
 


