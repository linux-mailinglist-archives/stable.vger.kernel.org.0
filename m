Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA73464ED2
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349538AbhLANfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 08:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349510AbhLANfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 08:35:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCC4C061748;
        Wed,  1 Dec 2021 05:32:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94DD5B81EE5;
        Wed,  1 Dec 2021 13:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F2EC53FCF;
        Wed,  1 Dec 2021 13:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638365537;
        bh=EMNfiMydvF4mhB/qZzPFrK+R0Fcj8elSL0Bwu4kKVlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRQgs1gfoXgUTOgNWHewyQNJi7E4o+ei6p2x9v38Fyrws5upYt7OIUTFKZk8rBlxu
         tv+Oo0jRCvNYwDETYBNRGnrnZ/bRTjG71BBWCLE9Us/r02QS1ey+yuceV1HmXqxIna
         sZX/X7sH+Xe/A23W+YG9KNJJzTth7YIYP1RtfcJGbI7r9upHHugbjZKBYtIymLfly/
         3axKNKTBePfWGeIebn7DRIa5j8JFVoXdDFDrkIaU4KlMMw8QzpsSMo6go7WLK+lYDi
         i3Y4lxKz/GtVGN82G8c8JR8bTAIN/OMkVXPK1HwSTSlMLw+A/71TuI2bzOxbigsnG2
         gbgkJ5HLze2xA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1msPiH-0007ru-T1; Wed, 01 Dec 2021 14:31:57 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Gabriel Somlo <somlo@cmu.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>
Subject: [PATCH 1/4] firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
Date:   Wed,  1 Dec 2021 14:25:25 +0100
Message-Id: <20211201132528.30025-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201132528.30025-1-johan@kernel.org>
References: <20211201132528.30025-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/firmware/qemu_fw_cfg.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/firmware/qemu_fw_cfg.c b/drivers/firmware/qemu_fw_cfg.c
index 172c751a4f6c..a9c64ebfc49a 100644
--- a/drivers/firmware/qemu_fw_cfg.c
+++ b/drivers/firmware/qemu_fw_cfg.c
@@ -388,9 +388,7 @@ static void fw_cfg_sysfs_cache_cleanup(void)
 	struct fw_cfg_sysfs_entry *entry, *next;
 
 	list_for_each_entry_safe(entry, next, &fw_cfg_entry_cache, list) {
-		/* will end up invoking fw_cfg_sysfs_cache_delist()
-		 * via each object's release() method (i.e. destructor)
-		 */
+		fw_cfg_sysfs_cache_delist(entry);
 		kobject_put(&entry->kobj);
 	}
 }
@@ -448,7 +446,6 @@ static void fw_cfg_sysfs_release_entry(struct kobject *kobj)
 {
 	struct fw_cfg_sysfs_entry *entry = to_entry(kobj);
 
-	fw_cfg_sysfs_cache_delist(entry);
 	kfree(entry);
 }
 
-- 
2.32.0

