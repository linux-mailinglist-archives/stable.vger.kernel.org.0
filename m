Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D577345C63C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351943AbhKXOGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356456AbhKXOEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1861A61A7F;
        Wed, 24 Nov 2021 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759461;
        bh=Bt+q9YLteaeVPTPzih/fySnXKnrWJVSHrvYFctOy03E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTotsOh0NrFebrW8R0XUMvXIFvrgbS0wlapp3grscORToyBeCOM4J1xXZ/MuZqFD6
         wqXvhv/XPRyZCKaNQaHOVN+H4kw7rN1x/fBZVI80/3AjzMKnuf+wbk37kAYRZ2qetE
         viO1ZHKcx4qW4VPPmeVwIM7kHG9uNlpHT8YfO0hQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.15 250/279] drm/nouveau: clean up all clients on device removal
Date:   Wed, 24 Nov 2021 12:58:57 +0100
Message-Id: <20211124115727.369121110@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Cline <jcline@redhat.com>

commit f55aaf63bde0d0336c3823bb3713bd4a464abbcf upstream.

The postclose handler can run after the device has been removed (or the
driver has been unbound) since userspace clients are free to hold the
file open as long as they want. Because the device removal callback
frees the entire nouveau_drm structure, any reference to it in the
postclose handler will result in a use-after-free.

To reproduce this, one must simply open the device file, unbind the
driver (or physically remove the device), and then close the device
file. This was found and can be reproduced easily with the IGT
core_hotunplug tests.

To avoid this, all clients are cleaned up in the device finalization
rather than deferring it to the postclose handler, and the postclose
handler is protected by a critical section which ensures the
drm_dev_unplug() and the postclose handler won't race.

This is not an ideal fix, since as I understand the proposed plan for
the kernel<->userspace interface for hotplug support, destroying the
client before the file is closed will cause problems. However, I believe
to properly fix this issue, the lifetime of the nouveau_drm structure
needs to be extended to match the drm_device, and this proved to be a
rather invasive change. Thus, I've broken this out so the fix can be
easily backported.

This fixes with the two previous commits CVE-2020-27820 (Karol).

Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Jeremy Cline <jcline@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Tested-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201125202648.5220-4-jcline@redhat.com
Link: https://gitlab.freedesktop.org/drm/nouveau/-/merge_requests/14
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -633,6 +633,7 @@ fail_alloc:
 static void
 nouveau_drm_device_fini(struct drm_device *dev)
 {
+	struct nouveau_cli *cli, *temp_cli;
 	struct nouveau_drm *drm = nouveau_drm(dev);
 
 	if (nouveau_pmops_runtime()) {
@@ -657,6 +658,24 @@ nouveau_drm_device_fini(struct drm_devic
 	nouveau_ttm_fini(drm);
 	nouveau_vga_fini(drm);
 
+	/*
+	 * There may be existing clients from as-yet unclosed files. For now,
+	 * clean them up here rather than deferring until the file is closed,
+	 * but this likely not correct if we want to support hot-unplugging
+	 * properly.
+	 */
+	mutex_lock(&drm->clients_lock);
+	list_for_each_entry_safe(cli, temp_cli, &drm->clients, head) {
+		list_del(&cli->head);
+		mutex_lock(&cli->mutex);
+		if (cli->abi16)
+			nouveau_abi16_fini(cli->abi16);
+		mutex_unlock(&cli->mutex);
+		nouveau_cli_fini(cli);
+		kfree(cli);
+	}
+	mutex_unlock(&drm->clients_lock);
+
 	nouveau_cli_fini(&drm->client);
 	nouveau_cli_fini(&drm->master);
 	nvif_parent_dtor(&drm->parent);
@@ -1112,6 +1131,16 @@ nouveau_drm_postclose(struct drm_device
 {
 	struct nouveau_cli *cli = nouveau_cli(fpriv);
 	struct nouveau_drm *drm = nouveau_drm(dev);
+	int dev_index;
+
+	/*
+	 * The device is gone, and as it currently stands all clients are
+	 * cleaned up in the removal codepath. In the future this may change
+	 * so that we can support hot-unplugging, but for now we immediately
+	 * return to avoid a double-free situation.
+	 */
+	if (!drm_dev_enter(dev, &dev_index))
+		return;
 
 	pm_runtime_get_sync(dev->dev);
 
@@ -1128,6 +1157,7 @@ nouveau_drm_postclose(struct drm_device
 	kfree(cli);
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
+	drm_dev_exit(dev_index);
 }
 
 static const struct drm_ioctl_desc


