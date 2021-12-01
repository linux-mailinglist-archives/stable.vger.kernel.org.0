Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6666464ED1
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 14:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349512AbhLANfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 08:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349463AbhLANfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 08:35:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A610EC061574;
        Wed,  1 Dec 2021 05:32:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DD76B81EE2;
        Wed,  1 Dec 2021 13:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3036AC53FCD;
        Wed,  1 Dec 2021 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638365537;
        bh=IjPToeYOH6L/JHRMA5azJJ2/4WG6GqgvrsNjOEzc+FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZQOUpAY4+3G29SCPheWO/jpzdSEJLQ79z+KR9U4Fd+AKCp+KgyfHcLIwQF6DFdnb
         p0UZT8mVz6aV/++acDdfzvZ3A0ZhKewiVMwyg1MtHFjI5sQxAakcxSZXtgcXqoEeal
         1OF8bZxvJWi1LzYM/702UAu5Gw40DhsEz40c/ODFYvfkgfnYxUUmX5t9FWxgXwZmRY
         ArmAB3dwnX65psfobyiCcAHLG4Fg7xdgkSeKo8p9t1Q8JDJmLZ50OYUvT1N6sgPZq/
         0YQxSEmvsQfKgOa7SApobJTFZpsc3sD4PoyfrcdNrwwpq4BGkvHf5GbCL+u59ZSzdz
         qdKtBDnX0fLIg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1msPiI-0007s0-1c; Wed, 01 Dec 2021 14:31:58 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Gabriel Somlo <somlo@cmu.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] firmware: qemu_fw_cfg: fix sysfs information leak
Date:   Wed,  1 Dec 2021 14:25:27 +0100
Message-Id: <20211201132528.30025-4-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201132528.30025-1-johan@kernel.org>
References: <20211201132528.30025-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to always NUL-terminate file names retrieved from the firmware
to avoid accessing data beyond the entry slab buffer and exposing it
through sysfs in case the firmware data is corrupt.

Fixes: 75f3e8e47f38 ("firmware: introduce sysfs driver for QEMU's fw_cfg device")
Cc: stable@vger.kernel.org      # 4.6
Cc: Gabriel Somlo <somlo@cmu.edu>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/firmware/qemu_fw_cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.32.0

