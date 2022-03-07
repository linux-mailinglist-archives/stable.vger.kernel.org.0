Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC44CF50A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiCGJYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbiCGJYL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:24:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387B3574A0;
        Mon,  7 Mar 2022 01:23:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D310BB810B2;
        Mon,  7 Mar 2022 09:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DC0C340E9;
        Mon,  7 Mar 2022 09:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644994;
        bh=wghIGJkzpuodDEQFADyhIM+kLpXkawWG1rofmq3dkMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnWpyyOHp8ddj50uFnkoMEw4un7lRkeH2wxaCepTUt7ruSOFwXYp8lrzKltDHjuqY
         VaCfqw7bAu1d85bcxqPGP3N1jTb2MgVVHyJiB8Y18hOECPnPrqJm1eyS88vuSEPjf0
         9O7H2KsBg2+DwddyOYV9kKjajKy2e3AyVi6T6jvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Somlo <somlo@cmu.edu>,
        Johan Hovold <johan@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 27/42] firmware: qemu_fw_cfg: fix kobject leak in probe error path
Date:   Mon,  7 Mar 2022 10:19:01 +0100
Message-Id: <20220307091636.941846628@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qemu_fw_cfg.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -461,15 +461,13 @@ static int fw_cfg_register_file(const st
 	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
 	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,
 				   fw_cfg_sel_ko, "%d", entry->f.select);
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
 	fw_cfg_build_symlink(fw_cfg_fname_kset, &entry->kobj, entry->f.name);
@@ -478,9 +476,10 @@ static int fw_cfg_register_file(const st
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
 


