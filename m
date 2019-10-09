Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A015D1766
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 20:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbfJISPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 14:15:13 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39383 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbfJISPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 14:15:13 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so4743158qtb.6
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 11:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+lyTSZwX5XY7B2NrAxQvliQeI28fCgCMHjPWEUXwpgA=;
        b=hTzT6OVdd6PD3fdZnfkL8h6nk13LQVIR3bOnyceDIM8hVSJFGVdzMWXWUz9mjyi4fc
         eG/uCgkAvKyPLNAQ4jXB5m07DlU578vgsDa18R7CrflLLYQxUc/MwkKckGztUCZcuNnb
         716dHo2hPaVChQbWXE7FrNEmVS6BjSGONIQQGnnKseLiPVgpmP9JyZ0VRm3yxrwnQiTn
         es7+Qfv+9ZgYXM2tb1chLRyaCkTLz0JlH5Op3QzxQ1k0F8MklGvszZwsQEi2fBKxWbqL
         je4h7M1HAIVtx0MffQywcUGWjM8RmENv1wbPJ7ya4jU+ujeuHKtTjIDaCayY2+0qDjmY
         BXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+lyTSZwX5XY7B2NrAxQvliQeI28fCgCMHjPWEUXwpgA=;
        b=Ixmo1WiXn6S+EG/2Oz1ztmM07av0f7Yuvf7g+DbIfZ+z+17iiQR8hE+diSQSuo84gw
         jksCstHjZDSYzOh3u9T7q0dMn7HSukkLUDZLsPVmj99HcXf03lGqilyJM/JSs6BAvyXc
         A1bXSDXfOiRBxQvA1Db1CLztuTAzkHnF+iDsjAbY6zij6Vx1+1iAXrbrt9Fi/RzWA/Cz
         6qbVE+y4WY8hqrgNDNWjwPJx1nc95gK7ZdYNylltl5/0oF5efvdSvoGVrDAPcgcL9pl8
         XxE0GCcPRwt4inxkdk8lap1/PiTCO1WJ08tR2BMF+7Li2eZIZTGGHp+ZpJpsZ4SDNDym
         rl0w==
X-Gm-Message-State: APjAAAUSPGn69otfBer7GUv9AhpJQaB2C1C6Eblygl674Uh7FLklS6lp
        cK+QM0L964fwx2jFSCUGAXp11bS1
X-Google-Smtp-Source: APXvYqzWvRAfhYx4iNs2faVfsK+kH7tw1F/hz+AT/k2dV4IYDLnOm3NqWylJBtsxKiSA9MGrdKHEBQ==
X-Received: by 2002:ac8:240c:: with SMTP id c12mr5146364qtc.361.1570644912328;
        Wed, 09 Oct 2019 11:15:12 -0700 (PDT)
Received: from localhost.localdomain ([71.51.171.205])
        by smtp.gmail.com with ESMTPSA id n4sm1325553qkc.61.2019.10.09.11.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 11:15:11 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     amd-gfx@lists.freedesktop.org, kmahlkuc@linux.vnet.ibm.com
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org
Subject: [PATCH] Revert "drm/radeon: Fix EEH during kexec"
Date:   Wed,  9 Oct 2019 13:15:03 -0500
Message-Id: <20191009181503.20381-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 6f7fe9a93e6c09bf988c5059403f5f88e17e21e6.

This breaks some boards.  Maybe just enable this on PPC for
now?

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=205147
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/radeon/radeon_drv.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 4267cb55bc33..2bc56f829bf7 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -378,19 +378,11 @@ radeon_pci_remove(struct pci_dev *pdev)
 static void
 radeon_pci_shutdown(struct pci_dev *pdev)
 {
-	struct drm_device *ddev = pci_get_drvdata(pdev);
-
 	/* if we are running in a VM, make sure the device
 	 * torn down properly on reboot/shutdown
 	 */
 	if (radeon_device_is_virtual())
 		radeon_pci_remove(pdev);
-
-	/* Some adapters need to be suspended before a
-	* shutdown occurs in order to prevent an error
-	* during kexec.
-	*/
-	radeon_suspend_kms(ddev, true, true, false);
 }
 
 static int radeon_pmops_suspend(struct device *dev)
-- 
2.20.1

