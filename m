Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D6F2A8B0D
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 00:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732181AbgKEX5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 18:57:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732035AbgKEX5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 18:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604620634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=i5YTCTculn7wAu7o7uqKEzANd6RxkS1YgfVbSqCO/rQ=;
        b=bdypQbRRaosoGyt7VLDOSMh6GUQurkfPRODy+nD2rOLq0R6jJgBocwiqbxkeNk34EDSVTD
        M9MrZ66DbdkzA3CvwYGUah6Mmtc8F51//85BSEKRzn6v730kWMsuXDCaW8bzRwT+8iCxWo
        6katS/Hb3ceXijS5Lap3dCmTjPFhz4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-X6GcLpfGNvCcG-T7R_okhg-1; Thu, 05 Nov 2020 18:57:12 -0500
X-MC-Unique: X6GcLpfGNvCcG-T7R_okhg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DC521006C83;
        Thu,  5 Nov 2020 23:57:09 +0000 (UTC)
Received: from Whitewolf.lyude.net (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 244E65B4B8;
        Thu,  5 Nov 2020 23:57:07 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Ilia Mirkin <imirkin@alum.mit.edu>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] drm/edid: Fix uninitialized variable in drm_cvt_modes()
Date:   Thu,  5 Nov 2020 18:57:02 -0500
Message-Id: <20201105235703.1328115-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Noticed this when trying to compile with -Wall on a kernel fork. We potentially
don't set width here, which causes the compiler to complain about width
potentially being uninitialized in drm_cvt_modes(). So, let's fix that.

Changes since v1:
* Don't emit an error as this code isn't reachable, just mark it as such
Changes since v2:
* Remove now unused variable

Signed-off-by: Lyude Paul <lyude@redhat.com>

Cc: <stable@vger.kernel.org> # v5.9+
Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
Signed-off-by: Lyude Paul <lyude@redhat.com>
---
 drivers/gpu/drm/drm_edid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 631125b46e04..b84efd538a70 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3114,6 +3114,8 @@ static int drm_cvt_modes(struct drm_connector *connector,
 		case 0x0c:
 			width = height * 15 / 9;
 			break;
+		default:
+			unreachable();
 		}
 
 		for (j = 1; j < 5; j++) {
-- 
2.28.0

