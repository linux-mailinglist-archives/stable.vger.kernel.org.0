Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CA749217E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344805AbiARInH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344813AbiARInE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:43:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E37C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 00:43:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DED260BC5
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2FDC00446;
        Tue, 18 Jan 2022 08:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642495383;
        bh=ECzK/c8yL76TaQ1DTRBBhdm5E3sooJByd17jxwex9tU=;
        h=Subject:To:Cc:From:Date:From;
        b=ela5ArRa2ux4MO54g8JdFc5r97IR9aWfNRh+syJg6dy8R3rHmxIMIW9rd0m9uwyUe
         LVKiVy9PIKN0005r2K/nlLqBH1Il256beK1XT74nTeGT+DQHt+M8w1i/827lZfESGD
         z1rD5OHoKW+SPAmw9eH9m6Eq17I9YXpa0h+w2Lxs=
Subject: FAILED: patch "[PATCH] firmware: qemu_fw_cfg: fix sysfs information leak" failed to apply to 4.14-stable tree
To:     johan@kernel.org, mst@redhat.com, somlo@cmu.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Jan 2022 09:42:47 +0100
Message-ID: <164249536725446@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

