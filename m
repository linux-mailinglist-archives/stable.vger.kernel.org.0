Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60E63F5492
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 02:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbhHXAzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 20:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234008AbhHXAzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B21861407;
        Tue, 24 Aug 2021 00:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766460;
        bh=TzDkHWbm1aqqP/QD0DwYRBsztmwOsXXIIpYLomeTdD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebKxEGuS8OpRiw55hcd3/cWlcx03MKXuJX0cH33pJwS6TyZfb0Rh632xm7S2g/pn4
         ye89+ZZWcogAdj9Y57rZ4GAmWBxdNA9btiZzLS4VcHBwmGmlOv92t00doRa3YsT6Dh
         zRzEqt0272j2WpIbjxfFqiWpr+GWoVnZJ+LNDrp8zN1g4ucvgDnjXdPuAztPuU5lvW
         BRxj06274DChCng0d4Pnm9NdTbCaLCCkwvgSesqmG5uPv9g4sKeFybciOA1WHhEGK1
         fSd0tfKTtlT1mHPEoy/3/odal4piciu1K271wJQGFi8d5GMRXrBm79fTr0fIe0CXy7
         HuTaffWe+uCeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Yacoub <markyacoub@google.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
        Mark Yacoub <markyacoub@chromium.org>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 18/26] drm: Copy drm_wait_vblank to user before returning
Date:   Mon, 23 Aug 2021 20:53:48 -0400
Message-Id: <20210824005356.630888-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005356.630888-1-sashal@kernel.org>
References: <20210824005356.630888-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Yacoub <markyacoub@google.com>

[ Upstream commit fa0b1ef5f7a694f48e00804a391245f3471aa155 ]

[Why]
Userspace should get back a copy of drm_wait_vblank that's been modified
even when drm_wait_vblank_ioctl returns a failure.

Rationale:
drm_wait_vblank_ioctl modifies the request and expects the user to read
it back. When the type is RELATIVE, it modifies it to ABSOLUTE and updates
the sequence to become current_vblank_count + sequence (which was
RELATIVE), but now it became ABSOLUTE.
drmWaitVBlank (in libdrm) expects this to be the case as it modifies
the request to be Absolute so it expects the sequence to would have been
updated.

The change is in compat_drm_wait_vblank, which is called by
drm_compat_ioctl. This change of copying the data back regardless of the
return number makes it en par with drm_ioctl, which always copies the
data before returning.

[How]
Return from the function after everything has been copied to user.

Fixes IGT:kms_flip::modeset-vs-vblank-race-interruptible
Tested on ChromeOS Trogdor(msm)

Reviewed-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Mark Yacoub <markyacoub@chromium.org>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20210812194917.1703356-1-markyacoub@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_ioc32.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 33390f02f5eb..e41d3a69a02a 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -856,8 +856,6 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	req.request.sequence = req32.request.sequence;
 	req.request.signal = req32.request.signal;
 	err = drm_ioctl_kernel(file, drm_wait_vblank_ioctl, &req, DRM_UNLOCKED);
-	if (err)
-		return err;
 
 	req32.reply.type = req.reply.type;
 	req32.reply.sequence = req.reply.sequence;
@@ -866,7 +864,7 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	if (copy_to_user(argp, &req32, sizeof(req32)))
 		return -EFAULT;
 
-	return 0;
+	return err;
 }
 
 #if defined(CONFIG_X86)
-- 
2.30.2

