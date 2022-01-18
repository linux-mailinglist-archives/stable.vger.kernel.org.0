Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EC2492AAA
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346925AbiARQMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346502AbiARQKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:10:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F653C061783;
        Tue, 18 Jan 2022 08:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1482BCE1A30;
        Tue, 18 Jan 2022 16:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA71C00446;
        Tue, 18 Jan 2022 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522209;
        bh=9OtNLgBZCevG6a5ICRwisDy1q+BlBNTtwsIeLoU+79w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xykmXWqSgrVQWbanaf/nBR9tbbpckRRccmxxNTe8TEYub++/GvvfC/eaY+GTE339r
         b4IeGaBq99qFhQRKuhElhHnzxjdIXApD0ETXu6txoaX7imNRL3qbwLOLsh8MeIaCzD
         B4QKXJRSR4Xm2EbecA/hz5VhFVQ8C9CQv4EmB47M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Somlo <somlo@cmu.edu>,
        Johan Hovold <johan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 16/28] firmware: qemu_fw_cfg: fix sysfs information leak
Date:   Tue, 18 Jan 2022 17:06:02 +0100
Message-Id: <20220118160452.418984487@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
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


