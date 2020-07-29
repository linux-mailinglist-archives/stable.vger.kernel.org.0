Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A232326E3
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 23:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgG2VhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 17:37:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20552 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727823AbgG2VhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jul 2020 17:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596058636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WhkCWwPB9RkgFRVKaewK6/9aoLErXC4RnUkvrrja2Pw=;
        b=fKiB/NQJftA5RUH0ded5GHzlhPqErXXPhHfpzcUfoUrTM/0EnFee94qw6E1zVMKRWGqmvB
        Sx3mfki6nqEy3wzhnYKYeJX0PlMUiZvzI6fUFM0YhBOkGYP+okqWOi3TyPvGhLQXJImErm
        BAqNMnSnKleRVW9S1TiHwSvjSqAklZ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-GtqNS00LNMKFdWOJ8hygRQ-1; Wed, 29 Jul 2020 17:37:12 -0400
X-MC-Unique: GtqNS00LNMKFdWOJ8hygRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4E1A1005504;
        Wed, 29 Jul 2020 21:37:10 +0000 (UTC)
Received: from Ruby.redhat.com (ovpn-119-146.rdu2.redhat.com [10.10.119.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9E9A60C84;
        Wed, 29 Jul 2020 21:37:08 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Karol Herbst <kherbst@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/9] drm/nouveau/kms: Handle -EINPROGRESS in nouveau_connector_hotplug()
Date:   Wed, 29 Jul 2020 17:36:55 -0400
Message-Id: <20200729213703.119137-2-lyude@redhat.com>
In-Reply-To: <20200729213703.119137-1-lyude@redhat.com>
References: <20200729213703.119137-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks like that we forgot to handle -EINPROGRESS being returned by
pm_runtime_get(), which can happen if multiple callers try to
asynchronously resume the GPU before it wakes up. This is perfectly
normal and OK, so fix this by treating -EINPROGRESS as success.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 3e1a12754d4d ("drm/nouveau: Fix deadlocks in nouveau_connector_detect()")
Cc: stable@vger.kernel.org
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v4.19+
---
 drivers/gpu/drm/nouveau/nouveau_connector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 7674025a4bfe8..38e226b8cfd05 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1173,7 +1173,7 @@ nouveau_connector_hotplug(struct nvif_notify *notify)
 	}
 
 	ret = pm_runtime_get(drm->dev->dev);
-	if (ret == 0) {
+	if (ret == 0 || ret == -EINPROGRESS) {
 		/* We can't block here if there's a pending PM request
 		 * running, as we'll deadlock nouveau_display_fini() when it
 		 * calls nvif_put() on our nvif_notify struct. So, simply
-- 
2.26.2

