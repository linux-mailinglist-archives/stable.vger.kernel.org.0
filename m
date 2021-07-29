Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244A83DA776
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 17:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbhG2PWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 11:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237878AbhG2PWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 11:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5276E60F43;
        Thu, 29 Jul 2021 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627572157;
        bh=NeRNV+Ur3AUEEcemzb+pbUSoUZmjeTTIM/3gUNFMpsY=;
        h=Subject:To:From:Date:From;
        b=Qg4ljj6ZfLFzKg0jMYEF96/xxpO/RBq48ddj31gwv590LuR6AMaEUWrmlAiFi0kDf
         urN9mnMtHWE7YyyJUTia2BJDDS0dohvC9Ns2g01FhIiC1czjEzNQ2CQzCEbSoVINhq
         vd4d8zQuXtTQHmEntk1PmyMbjlsjjMFsdx+rtd0g=
Subject: patch "firmware_loader: fix use-after-free in firmware_fallback_sysfs" added to driver-core-linus
To:     mail@anirudhrb.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        skhan@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Jul 2021 17:22:27 +0200
Message-ID: <16275721471501@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    firmware_loader: fix use-after-free in firmware_fallback_sysfs

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 75d95e2e39b27f733f21e6668af1c9893a97de5e Mon Sep 17 00:00:00 2001
From: Anirudh Rayabharam <mail@anirudhrb.com>
Date: Wed, 28 Jul 2021 14:21:07 +0530
Subject: firmware_loader: fix use-after-free in firmware_fallback_sysfs

This use-after-free happens when a fw_priv object has been freed but
hasn't been removed from the pending list (pending_fw_head). The next
time fw_load_sysfs_fallback tries to insert into the list, it ends up
accessing the pending_list member of the previously freed fw_priv.

The root cause here is that all code paths that abort the fw load
don't delete it from the pending list. For example:

        _request_firmware()
          -> fw_abort_batch_reqs()
              -> fw_state_aborted()

To fix this, delete the fw_priv from the list in __fw_set_state() if
the new state is DONE or ABORTED. This way, all aborts will remove
the fw_priv from the list. Accordingly, remove calls to list_del_init
that were being made before calling fw_state_(aborted|done).

Also, in fw_load_sysfs_fallback, don't add the fw_priv to the pending
list if it is already aborted. Instead, just jump out and return early.

Fixes: bcfbd3523f3c ("firmware: fix a double abort case with fw_load_sysfs_fallback")
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+de271708674e2093097b@syzkaller.appspotmail.com
Tested-by: syzbot+de271708674e2093097b@syzkaller.appspotmail.com
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210728085107.4141-3-mail@anirudhrb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/firmware_loader/fallback.c | 12 ++++++++----
 drivers/base/firmware_loader/firmware.h | 10 +++++++++-
 drivers/base/firmware_loader/main.c     |  2 ++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 1a48be0a030e..d7d63c1aa993 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -89,12 +89,11 @@ static void __fw_load_abort(struct fw_priv *fw_priv)
 {
 	/*
 	 * There is a small window in which user can write to 'loading'
-	 * between loading done and disappearance of 'loading'
+	 * between loading done/aborted and disappearance of 'loading'
 	 */
-	if (fw_sysfs_done(fw_priv))
+	if (fw_state_is_aborted(fw_priv) || fw_sysfs_done(fw_priv))
 		return;
 
-	list_del_init(&fw_priv->pending_list);
 	fw_state_aborted(fw_priv);
 }
 
@@ -280,7 +279,6 @@ static ssize_t firmware_loading_store(struct device *dev,
 			 * Same logic as fw_load_abort, only the DONE bit
 			 * is ignored and we set ABORT only on failure.
 			 */
-			list_del_init(&fw_priv->pending_list);
 			if (rc) {
 				fw_state_aborted(fw_priv);
 				written = rc;
@@ -513,6 +511,11 @@ static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs, long timeout)
 	}
 
 	mutex_lock(&fw_lock);
+	if (fw_state_is_aborted(fw_priv)) {
+		mutex_unlock(&fw_lock);
+		retval = -EINTR;
+		goto out;
+	}
 	list_add(&fw_priv->pending_list, &pending_fw_head);
 	mutex_unlock(&fw_lock);
 
@@ -538,6 +541,7 @@ static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs, long timeout)
 	} else if (fw_priv->is_paged_buf && !fw_priv->data)
 		retval = -ENOMEM;
 
+out:
 	device_del(f_dev);
 err_put_dev:
 	put_device(f_dev);
diff --git a/drivers/base/firmware_loader/firmware.h b/drivers/base/firmware_loader/firmware.h
index 63bd29fdcb9c..a3014e9e2c85 100644
--- a/drivers/base/firmware_loader/firmware.h
+++ b/drivers/base/firmware_loader/firmware.h
@@ -117,8 +117,16 @@ static inline void __fw_state_set(struct fw_priv *fw_priv,
 
 	WRITE_ONCE(fw_st->status, status);
 
-	if (status == FW_STATUS_DONE || status == FW_STATUS_ABORTED)
+	if (status == FW_STATUS_DONE || status == FW_STATUS_ABORTED) {
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+		/*
+		 * Doing this here ensures that the fw_priv is deleted from
+		 * the pending list in all abort/done paths.
+		 */
+		list_del_init(&fw_priv->pending_list);
+#endif
 		complete_all(&fw_st->completion);
+	}
 }
 
 static inline void fw_state_aborted(struct fw_priv *fw_priv)
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 4fdb8219cd08..68c549d71230 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -783,8 +783,10 @@ static void fw_abort_batch_reqs(struct firmware *fw)
 		return;
 
 	fw_priv = fw->priv;
+	mutex_lock(&fw_lock);
 	if (!fw_state_is_aborted(fw_priv))
 		fw_state_aborted(fw_priv);
+	mutex_unlock(&fw_lock);
 }
 
 /* called from request_firmware() and request_firmware_work_func() */
-- 
2.32.0


