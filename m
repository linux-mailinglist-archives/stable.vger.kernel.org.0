Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF479492A63
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346749AbiARQJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346751AbiARQIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:08:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE286C061762;
        Tue, 18 Jan 2022 08:08:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB3A612B9;
        Tue, 18 Jan 2022 16:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117D7C340E0;
        Tue, 18 Jan 2022 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522121;
        bh=s3CsI5MmGWZgzICs6nkaVvUohwmFXDbrC1qDtryJsvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yP9uhP+RoS/FoX0VeVtKVEnbxBoNJDWXVuIF2XLB27+ILVO3IiuoeT7GL3hFqxh8H
         BH4nzwxpNAd6zE7QWKGnkn/eezJCUWn/h4KL1x7XOHTbYbD+dmVJoMikm60uc2U1Kd
         99F6n4pK/7aKFd3I/UtAk8+/I8CUPz1aYbVIlwfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Kees Cook <keescook@chromium.org>,
        Johan Hovold <johan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 14/23] firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
Date:   Tue, 18 Jan 2022 17:05:54 +0100
Message-Id: <20220118160451.723590076@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit d3e305592d69e21e36b76d24ca3c01971a2d09be upstream.

Commit fe3c60684377 ("firmware: Fix a reference count leak.") "fixed"
a kobject leak in the file registration helper by properly calling
kobject_put() for the entry in case registration of the object fails
(e.g. due to a name collision).

This would however result in a NULL pointer dereference when the
release function tries to remove the never added entry from the
fw_cfg_entry_cache list.

Fix this by moving the list-removal out of the release function.

Note that the offending commit was one of the benign looking umn.edu
fixes which was reviewed but not reverted. [1][2]

[1] https://lore.kernel.org/r/202105051005.49BFABCE@keescook
[2] https://lore.kernel.org/all/YIg7ZOZvS3a8LjSv@kroah.com

Fixes: fe3c60684377 ("firmware: Fix a reference count leak.")
Cc: stable@vger.kernel.org      # 5.8
Cc: Qiushi Wu <wu000273@umn.edu>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211201132528.30025-2-johan@kernel.org
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qemu_fw_cfg.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -388,9 +388,7 @@ static void fw_cfg_sysfs_cache_cleanup(v
 	struct fw_cfg_sysfs_entry *entry, *next;
 
 	list_for_each_entry_safe(entry, next, &fw_cfg_entry_cache, list) {
-		/* will end up invoking fw_cfg_sysfs_cache_delist()
-		 * via each object's release() method (i.e. destructor)
-		 */
+		fw_cfg_sysfs_cache_delist(entry);
 		kobject_put(&entry->kobj);
 	}
 }
@@ -448,7 +446,6 @@ static void fw_cfg_sysfs_release_entry(s
 {
 	struct fw_cfg_sysfs_entry *entry = to_entry(kobj);
 
-	fw_cfg_sysfs_cache_delist(entry);
 	kfree(entry);
 }
 


