Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9294649217B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344761AbiARIm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344813AbiARImw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:42:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ED1C06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 00:42:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40EFFB812A5
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB70C00446;
        Tue, 18 Jan 2022 08:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642495370;
        bh=LicsD3oxRr4FQ3dY7DMugRXeLSs3XojcAlEJWvItl3Y=;
        h=Subject:To:Cc:From:Date:From;
        b=g2CRaivfOMC0txSY02AYLdfx13GJoql5S9Cggg/qen9VJlzIyz+4fUDSHh0Iks1KX
         yloFl/d3BAkIKwKk+Xhh9HSyyuRG1UDylW5Mc4pAiJZRgxGWtGozPqYyVnmD35lrAk
         1+rlupjBSEMe8nE4it3Icq8+1t3q7TxHUpB60MEs=
Subject: FAILED: patch "[PATCH] firmware: qemu_fw_cfg: fix sysfs information leak" failed to apply to 4.9-stable tree
To:     johan@kernel.org, mst@redhat.com, somlo@cmu.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 09:42:47 +0100
Message-ID: <16424953678374@kroah.com>
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

From 1b656e9aad7f4886ed466094d1dc5ee4dd900d20 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 1 Dec 2021 14:25:27 +0100
Subject: [PATCH] firmware: qemu_fw_cfg: fix sysfs information leak

Make sure to always NUL-terminate file names retrieved from the firmware
to avoid accessing data beyond the entry slab buffer and exposing it
through sysfs in case the firmware data is corrupt.

Fixes: 75f3e8e47f38 ("firmware: introduce sysfs driver for QEMU's fw_cfg device")
Cc: stable@vger.kernel.org      # 4.6
Cc: Gabriel Somlo <somlo@cmu.edu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211201132528.30025-4-johan@kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index ccb7ed62452f..f08e056ed0ae 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -598,7 +598,7 @@ static int fw_cfg_register_file(const struct fw_cfg_file *f)
 	/* set file entry information */
 	entry->size = be32_to_cpu(f->size);
 	entry->select = be16_to_cpu(f->select);
-	memcpy(entry->name, f->name, FW_CFG_MAX_FILE_PATH);
+	strscpy(entry->name, f->name, FW_CFG_MAX_FILE_PATH);
 
 	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
 	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,

