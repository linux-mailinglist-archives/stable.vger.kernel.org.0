Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76EFCA51CB
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 10:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbfIBIdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 04:33:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60406 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbfIBIdw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 04:33:52 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1i4hmV-0001ln-NX; Mon, 02 Sep 2019 08:33:48 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     harry.wentland@amd.com, sunpeng.li@amd.com,
        alexander.deucher@amd.com, christian.koenig@amd.com,
        David1.Zhou@amd.com
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/amd/display: Restore backlight brightness after system resume
Date:   Mon,  2 Sep 2019 16:33:42 +0800
Message-Id: <20190902083342.27393-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Laptops with AMD APU doesn't restore display backlight brightness after
system resume.

This issue started when DC was introduced.

Let's use BL_CORE_SUSPENDRESUME so the backlight core calls
update_status callback after system resume to restore the backlight
level.

Tested on Dell Inspiron 3180 (Stoney Ridge) and Dell Latitude 5495
(Raven Ridge).

Cc: <stable@vger.kernel.org>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 1b0949dd7808..183ef18ac6f3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2111,6 +2111,7 @@ static int amdgpu_dm_backlight_get_brightness(struct backlight_device *bd)
 }
 
 static const struct backlight_ops amdgpu_dm_backlight_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
 	.get_brightness = amdgpu_dm_backlight_get_brightness,
 	.update_status	= amdgpu_dm_backlight_update_status,
 };
-- 
2.17.1

