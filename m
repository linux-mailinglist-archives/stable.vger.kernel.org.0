Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C80F492AC3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347099AbiARQNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:13:00 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41456 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347200AbiARQLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:11:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1AF5CE1A30;
        Tue, 18 Jan 2022 16:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D54C00446;
        Tue, 18 Jan 2022 16:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522278;
        bh=9OtNLgBZCevG6a5ICRwisDy1q+BlBNTtwsIeLoU+79w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nRBvYsOHcE152IIfbn+xO7pGFso9PhH2z2ev71SMNCLiQ7iB7RsiGVZv5itPSsA9i
         aHDTc48Uk6KKvL3qFPUV8Safusn5P2mWGD0NBivNnwXgHwu7uHH0IDL0HoYRJX6yBB
         PW+QZcb5jjDedTOqnHhJ5qW313PWmC7cWdJPQBHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Somlo <somlo@cmu.edu>,
        Johan Hovold <johan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.16 18/28] firmware: qemu_fw_cfg: fix sysfs information leak
Date:   Tue, 18 Jan 2022 17:06:13 +0100
Message-Id: <20220118160453.008663385@linuxfoundation.org>
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

commit 1b656e9aad7f4886ed466094d1dc5ee4dd900d20 upstream.

Make sure to always NUL-terminate file names retrieved from the firmware
to avoid accessing data beyond the entry slab buffer and exposing it
through sysfs in case the firmware data is corrupt.

Fixes: 75f3e8e47f38 ("firmware: introduce sysfs driver for QEMU's fw_cfg device")
Cc: stable@vger.kernel.org      # 4.6
Cc: Gabriel Somlo <somlo@cmu.edu>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211201132528.30025-4-johan@kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qemu_fw_cfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -601,7 +601,7 @@ static int fw_cfg_register_file(const st
 	/* set file entry information */
 	entry->size = be32_to_cpu(f->size);
 	entry->select = be16_to_cpu(f->select);
-	memcpy(entry->name, f->name, FW_CFG_MAX_FILE_PATH);
+	strscpy(entry->name, f->name, FW_CFG_MAX_FILE_PATH);
 
 	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
 	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,


