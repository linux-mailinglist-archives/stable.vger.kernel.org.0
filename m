Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DCA4A61FE
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 18:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiBARLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 12:11:53 -0500
Received: from nef2.ens.fr ([129.199.96.40]:49501 "EHLO nef.ens.fr"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230451AbiBARLw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Feb 2022 12:11:52 -0500
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1643735511; bh=iFLA7nai2by0cVp1g8+jxCbQVWQkk8KIRz2FVJMZbTI=;
        h=From:To:Cc:Subject:Date:From;
        b=U6Qpc2GikO58Cihu7hREvoNJW+EhoXALERFdpDTKMw1NbY81WxU7XnfM3/ca8n9gd
         NTOuYg0q4EpPgCdgK4+8Vr3EEoRqCDK8VBHU4rYVC8/aRTsYcJIRhA0hdtO88j2Q2A
         dzpzqXlBjlTJE0+hdFYQFeV0SYnZtc8bJF5b78eg=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 211HBojb013058
          ; Tue, 1 Feb 2022 18:11:50 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 211HBgsq077955 ; Tue, 1 Feb 2022 18:11:50 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH stable 4.4] Revert "drm/radeon/ci: disable mclk switching for high refresh rates (v2)"
Date:   Tue,  1 Feb 2022 18:11:13 +0100
Message-Id: <1643735473-14635-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 01 Feb 2022 18:11:50 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 0157e2a8a71978c58a7d6cfb3616ab17d9726631.

The reverted commit was backported and applied twice on the stable branch:
- First as commit 15de2e4c90b7 ("drm/radeon/ci: disable mclk switching for
high refresh rates (v2)")
- Then as commit 0157e2a8a719 ("drm/radeon/ci: disable mclk switching for
high refresh rates (v2)")

Fixes: 0157e2a8a719 ("drm/radeon/ci: disable mclk switching for high refresh rates (v2)")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>

---
 drivers/gpu/drm/radeon/ci_dpm.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ci_dpm.c b/drivers/gpu/drm/radeon/ci_dpm.c
index 8e1bf9e..c8baa06 100644
--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -782,12 +782,6 @@ bool ci_dpm_vblank_too_short(struct radeon_device *rdev)
 	if (r600_dpm_get_vrefresh(rdev) > 120)
 		return true;

-	/* disable mclk switching if the refresh is >120Hz, even if the
-        * blanking period would allow it
-        */
-	if (r600_dpm_get_vrefresh(rdev) > 120)
-		return true;
-
 	if (vblank_time < switch_limit)
 		return true;
 	else
--
2.7.4

