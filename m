Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42292326FD
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 23:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgG2Vhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 17:37:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39069 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727885AbgG2VhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 17:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596058644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+JQ8H1qRxbeXJCsAhz3cMJuwqIVhTmvjHZPRWUqAC/M=;
        b=HCrJ0bAZBq/uI2jY5OEhYuZ3aRfvATiBarA2vaN4EGDCFSJXCrHdKsX1XAJMGv7xXIuhy4
        u8oH+oXagO8Tr/es+7dBwAh1B7dnxasrU11FL3iRCeLYd1H5p4MJeI20P54qS7ygoBUY6g
        /zRadQF9DMkPCziadbHBt3fUdjNnkUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-4TTm5EAfO5GE5eT5ojlLqQ-1; Wed, 29 Jul 2020 17:37:21 -0400
X-MC-Unique: 4TTm5EAfO5GE5eT5ojlLqQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DD9191271;
        Wed, 29 Jul 2020 21:37:20 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-119-146.rdu2.redhat.com [10.10.119.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFF3B61176;
        Wed, 29 Jul 2020 21:37:19 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 9/9] drm/nouveau/kms: Handle -EINPROGRESS in nouveau_display_acpi_ntfy()
Date:   Wed, 29 Jul 2020 17:37:03 -0400
Message-Id: <20200729213703.119137-10-lyude@redhat.com>
In-Reply-To: <20200729213703.119137-1-lyude@redhat.com>
References: <20200729213703.119137-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This isn't an error, this just means there's multiple asynchronous
resume requests going at the same time. Treat it like a success.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 79e765ad665d ("drm/nouveau/drm/nouveau: Prevent handling ACPI HPD events too early")
Cc: stable@vger.kernel.org
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.19+
---
 drivers/gpu/drm/nouveau/nouveau_display.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index ad63d4f052deb..691bb8d37759e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -462,10 +462,10 @@ nouveau_display_acpi_ntfy(struct notifier_block *nb, unsigned long val,
 		return NOTIFY_DONE;
 
 	ret = pm_runtime_get(drm->dev->dev);
-	if (ret == 1 || ret == -EACCES) {
-		/* If the GPU is already awake, or in a state
-		 * where we can't wake it up, it can handle
-		 * it's own hotplug events.
+	if (ret == 1 || ret == -EACCES || ret == -EINPROGRESS) {
+		/* If the GPU is already awake, is waking up, or is in a state
+		 * where we can't wake it up, it can handle its own hotplug
+		 * events.
 		 */
 		pm_runtime_put_autosuspend(drm->dev->dev);
 	} else if (ret == 0) {
-- 
2.26.2

