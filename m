Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB962A59DA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgKCWPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:15:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729085AbgKCWPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 17:15:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604441723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SXIMwG+24v0kPGbcpgSikfVX/4K8JgtSXH6lhtDLzEo=;
        b=KBU/kruDJYrvw8jyGFF2aQck9o1/M33QWiqz7nn9E5Q9CwwyE7OMy66GsvRtrmr2x2aUK2
        UktONvAk4a6l/8f5w8cGtttXcgKG4bs3k3flXWQHQVxhjjSpikCvnW0jYAU9W7ODU2f+gb
        /Uj6ACAZTzx5HJ8q1VStmf7HCSQbzIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-UmyNEj-5PHqDzrZS2RN4Wg-1; Tue, 03 Nov 2020 17:15:22 -0500
X-MC-Unique: UmyNEj-5PHqDzrZS2RN4Wg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A11A7803F46;
        Tue,  3 Nov 2020 22:15:19 +0000 (UTC)
Received: from Whitewolf.lyude.net (ovpn-119-236.rdu2.redhat.com [10.10.119.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E505960BF1;
        Tue,  3 Nov 2020 22:15:14 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     Ilia Mirkin <imirkin@alum.mit.edu>, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Kees Cook <keescook@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] drm/edid: Fix uninitialized variable in drm_cvt_modes()
Date:   Tue,  3 Nov 2020 17:15:10 -0500
Message-Id: <20201103221510.575827-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Noticed this when trying to compile with -Wall on a kernel fork. We potentially
don't set width here, which causes the compiler to complain about width
potentially being uninitialized in drm_cvt_modes(). So, let's fix that.

Changes since v1:
* Don't emit an error as this code isn't reachable, just mark it as such

Signed-off-by: Lyude Paul <lyude@redhat.com>

Cc: <stable@vger.kernel.org> # v5.9+
Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
Signed-off-by: Lyude Paul <lyude@redhat.com>
---
 drivers/gpu/drm/drm_edid.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 631125b46e04..0643b98c6383 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3094,6 +3094,7 @@ static int drm_cvt_modes(struct drm_connector *connector,
 
 	for (i = 0; i < 4; i++) {
 		int width, height;
+		u8 cvt_aspect_ratio;
 
 		cvt = &(timing->data.other_data.data.cvt[i]);
 
@@ -3101,7 +3102,8 @@ static int drm_cvt_modes(struct drm_connector *connector,
 			continue;
 
 		height = (cvt->code[0] + ((cvt->code[1] & 0xf0) << 4) + 1) * 2;
-		switch (cvt->code[1] & 0x0c) {
+		cvt_aspect_ratio = cvt->code[1] & 0x0c;
+		switch (cvt_aspect_ratio) {
 		case 0x00:
 			width = height * 4 / 3;
 			break;
@@ -3114,6 +3116,8 @@ static int drm_cvt_modes(struct drm_connector *connector,
 		case 0x0c:
 			width = height * 15 / 9;
 			break;
+		default:
+			unreachable();
 		}
 
 		for (j = 1; j < 5; j++) {
-- 
2.28.0

