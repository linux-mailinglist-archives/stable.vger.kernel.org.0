Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009FE492A15
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346219AbiARQGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346218AbiARQGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:06:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D9FC06161C;
        Tue, 18 Jan 2022 08:06:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78A29612CF;
        Tue, 18 Jan 2022 16:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C82CC00446;
        Tue, 18 Jan 2022 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522004;
        bh=OvvClgg8tVQtTWn8Qm3ypBSAwn/4B4w1SBC5HNpllfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DquNUtoIxqUREGHToGnx1KDFTuynORgX76fCA9W/q30qNmdbWb39tsuP+VZ5rgjMk
         Eh42+iSFfgL2C20aVfMgMVIrawB2LDlk7oIXl4Ev6YkYQlAWspUIjZBSxJB7Yr1C25
         BWzxkmJmi54R63xlOXyQ0qlLRG2Gs99jvC4FQ8aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Kees Cook <keescook@chromium.org>,
        Johan Hovold <johan@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.4 10/15] firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
Date:   Tue, 18 Jan 2022 17:05:49 +0100
Message-Id: <20220118160450.390919144@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160450.062004175@linuxfoundation.org>
References: <20220118160450.062004175@linuxfoundation.org>
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
@@ -385,9 +385,7 @@ static void fw_cfg_sysfs_cache_cleanup(v
 	struct fw_cfg_sysfs_entry *entry, *next;
 
 	list_for_each_entry_safe(entry, next, &fw_cfg_entry_cache, list) {
-		/* will end up invoking fw_cfg_sysfs_cache_delist()
-		 * via each object's release() method (i.e. destructor)
-		 */
+		fw_cfg_sysfs_cache_delist(entry);
 		kobject_put(&entry->kobj);
 	}
 }
@@ -445,7 +443,6 @@ static void fw_cfg_sysfs_release_entry(s
 {
 	struct fw_cfg_sysfs_entry *entry = to_entry(kobj);
 
-	fw_cfg_sysfs_cache_delist(entry);
 	kfree(entry);
 }
 


