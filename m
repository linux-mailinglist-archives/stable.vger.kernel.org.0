Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99DB52C4908
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 21:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbgKYU1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 15:27:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729729AbgKYU1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 15:27:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606336038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mHKnvKojNg07maTXpdLc7opl7LeH8NxJHEW+j33de5M=;
        b=HJQA+Qt8G+IaoQGfVjSj7kMvJ23y3zxbNgAEUP6d5d+2up91JJ7ex1vO1v3ISdXHWsJyNF
        NrgpFlo5rrQiLM4Ely10j3B/DAjjkTDr2vsbDamkLMO3irwxMTu3D8q7lC1oO83lY7lYfy
        k7SgSsHugVDADtF5opH93SOa1xRx+L4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-NkbOk4J1NemeIitdTtDlaQ-1; Wed, 25 Nov 2020 15:27:16 -0500
X-MC-Unique: NkbOk4J1NemeIitdTtDlaQ-1
Received: by mail-qv1-f69.google.com with SMTP id o16so3270005qvq.4
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:27:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mHKnvKojNg07maTXpdLc7opl7LeH8NxJHEW+j33de5M=;
        b=O+uc5/SLuNbgGppNGBO0WAYdsFp35Lxn2TzZpycR17Tj0PduprXfX0zGi5XXnVhrnz
         m9t9MEy9a0iIewFXdWftbsbA9gKPDKTvXGxyv6+dO/VIWQoxyBqSk65/i9fejVakyl+G
         qpYwXvlCXlz8DjCl2SVfxZbBXWdZiBiNq4HyHauUwMiO5yVPsWe+OwZBz/8hRmZO8gBO
         lfW9JVsY/3pNgq9vZHZ9DmDnW2NxX4KNzS6OKNVlfeZhsD11MEdNiXUR4XwRHeq/g+ia
         oBLW7BXRReeybzNAN4OBLrY8IgEeMXeeolj6m3qWNxjQW7HrGA/OnjeK4CjAOhJap9V+
         OvxA==
X-Gm-Message-State: AOAM531bJOLB/sV6lJz38OYaDc3br2qYCkmHoOyMlxW4dmkgQfi7weqT
        0l8MJ0GoDNNbv0UIHpydxyzWh/2nEl0OQJEK6DNOJPZWum8lzPZv9rESmBLlp55Z8WL2MF19/wP
        oIIeMDOJ6R88aiFIt
X-Received: by 2002:a37:6f07:: with SMTP id k7mr645811qkc.423.1606336036383;
        Wed, 25 Nov 2020 12:27:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIW7/SCjK5C7le3XLJ7c7SswM/9Tbl2wvjAUiYOJaHFKIGoPwGq/hxgNfwbsf46D2m+6cudA==
X-Received: by 2002:a37:6f07:: with SMTP id k7mr645781qkc.423.1606336036152;
        Wed, 25 Nov 2020 12:27:16 -0800 (PST)
Received: from dev.jcline.org ([2605:a601:a638:b301:9966:d978:493:6a3d])
        by smtp.gmail.com with ESMTPSA id o187sm431772qkb.120.2020.11.25.12.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:27:15 -0800 (PST)
From:   Jeremy Cline <jcline@redhat.com>
To:     Ben Skeggs <bskeggs@redhat.com>
Cc:     Lyude Paul <lyude@redhat.com>, Karol Herbst <kherbst@redhat.com>,
        David Airlie <airlied@linux.ie>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jeremy Cline <jcline@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 3/3] drm/nouveau: clean up all clients on device removal
Date:   Wed, 25 Nov 2020 15:26:48 -0500
Message-Id: <20201125202648.5220-4-jcline@redhat.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125202648.5220-1-jcline@redhat.com>
References: <20201103194912.184413-1-jcline@redhat.com>
 <20201125202648.5220-1-jcline@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Cline <jcline@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 30 +++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 6ee1adc9bd40..afaf1774ee35 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -628,6 +628,7 @@ nouveau_drm_device_init(struct drm_device *dev)
 static void
 nouveau_drm_device_fini(struct drm_device *dev)
 {
+	struct nouveau_cli *cli, *temp_cli;
 	struct nouveau_drm *drm = nouveau_drm(dev);
 
 	if (nouveau_pmops_runtime()) {
@@ -652,6 +653,24 @@ nouveau_drm_device_fini(struct drm_device *dev)
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
@@ -1111,6 +1130,16 @@ nouveau_drm_postclose(struct drm_device *dev, struct drm_file *fpriv)
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
 
@@ -1127,6 +1156,7 @@ nouveau_drm_postclose(struct drm_device *dev, struct drm_file *fpriv)
 	kfree(cli);
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
+	drm_dev_exit(dev_index);
 }
 
 static const struct drm_ioctl_desc
-- 
2.28.0

