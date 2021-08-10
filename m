Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1753E7FEF
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhHJRoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235389AbhHJRmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF866121F;
        Tue, 10 Aug 2021 17:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617128;
        bh=ds95olJJ+7kX4/0RgKJvkgLNm/tIFeYsUMXbUmJtMbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9QOjF8Txs8BEEw6GnsHxLa81hhoFBhMoHt/za/0JKbQMWOHtNjUcBkKqZ0oPDwKD
         CfbWkFiyxZppuSH/btuY9IkMCyI0zgi/7EoE8AKK0Lq/eXIPs78l5PvPotgFLFODKc
         0l9Wp57kYqQuAZBIUVOE5vJBM21hTLVA9NRt/l9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+de271708674e2093097b@syzkaller.appspotmail.com,
        Shuah Khan <skhan@linuxfoundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Subject: [PATCH 5.10 057/135] firmware_loader: fix use-after-free in firmware_fallback_sysfs
Date:   Tue, 10 Aug 2021 19:29:51 +0200
Message-Id: <20210810172957.625310898@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit 75d95e2e39b27f733f21e6668af1c9893a97de5e upstream.

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
 drivers/base/firmware_loader/fallback.c |   12 ++++++++----
 drivers/base/firmware_loader/firmware.h |   10 +++++++++-
 drivers/base/firmware_loader/main.c     |    2 ++
 3 files changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -89,12 +89,11 @@ static void __fw_load_abort(struct fw_pr
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
 
@@ -280,7 +279,6 @@ static ssize_t firmware_loading_store(st
 			 * Same logic as fw_load_abort, only the DONE bit
 			 * is ignored and we set ABORT only on failure.
 			 */
-			list_del_init(&fw_priv->pending_list);
 			if (rc) {
 				fw_state_aborted(fw_priv);
 				written = rc;
@@ -513,6 +511,11 @@ static int fw_load_sysfs_fallback(struct
 	}
 
 	mutex_lock(&fw_lock);
+	if (fw_state_is_aborted(fw_priv)) {
+		mutex_unlock(&fw_lock);
+		retval = -EINTR;
+		goto out;
+	}
 	list_add(&fw_priv->pending_list, &pending_fw_head);
 	mutex_unlock(&fw_lock);
 
@@ -538,6 +541,7 @@ static int fw_load_sysfs_fallback(struct
 	} else if (fw_priv->is_paged_buf && !fw_priv->data)
 		retval = -ENOMEM;
 
+out:
 	device_del(f_dev);
 err_put_dev:
 	put_device(f_dev);
--- a/drivers/base/firmware_loader/firmware.h
+++ b/drivers/base/firmware_loader/firmware.h
@@ -117,8 +117,16 @@ static inline void __fw_state_set(struct
 
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
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -781,8 +781,10 @@ static void fw_abort_batch_reqs(struct f
 		return;
 
 	fw_priv = fw->priv;
+	mutex_lock(&fw_lock);
 	if (!fw_state_is_aborted(fw_priv))
 		fw_state_aborted(fw_priv);
+	mutex_unlock(&fw_lock);
 }
 
 /* called from request_firmware() and request_firmware_work_func() */


