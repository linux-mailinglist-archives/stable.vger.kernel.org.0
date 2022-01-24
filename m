Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D377498D66
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344018AbiAXTcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347073AbiAXT1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:27:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199D9C08E7BF;
        Mon, 24 Jan 2022 11:12:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC106B8122F;
        Mon, 24 Jan 2022 19:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34347C340E8;
        Mon, 24 Jan 2022 19:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051570;
        bh=N8Rgi53AUy+5nlRNc2Il+oQgNwWJTC8Or3+tDrNCYHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9xReAzji9iIjedf3BxmJuhuZzhI0r11+gkq4l3DcGZQ/5w51b0+l8fDgluQONEGz
         0NFMH8eqf5/RaJ+nItYEO3JzNdMqY49WWh30VpVbggjudMeqz2NoNurE2b6T7xKzjx
         VHovutbhtltDZSux8TQ1OWRGw4J2f0hNg2u2iHPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gabriel Somlo <somlo@cmu.edu>,
        Johan Hovold <johan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 4.19 018/239] firmware: qemu_fw_cfg: fix sysfs information leak
Date:   Mon, 24 Jan 2022 19:40:56 +0100
Message-Id: <20220124183943.701260030@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
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
@@ -598,7 +598,7 @@ static int fw_cfg_register_file(const st
 	/* set file entry information */
 	entry->size = be32_to_cpu(f->size);
 	entry->select = be16_to_cpu(f->select);
-	memcpy(entry->name, f->name, FW_CFG_MAX_FILE_PATH);
+	strscpy(entry->name, f->name, FW_CFG_MAX_FILE_PATH);
 
 	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
 	err = kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,


