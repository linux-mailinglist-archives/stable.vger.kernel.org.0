Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CAEE686A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbfJ0VT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731590AbfJ0VT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:58 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD8E205C9;
        Sun, 27 Oct 2019 21:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211198;
        bh=MpeTyxLdGwSINKCEALywvaWEq2jpjZQmO+9Hqo0R9Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WM8svX4GU2RY2NXCOHjaP9bVjOcZPXrC186GnIF6mShSZnMnAuq6+nUYMZTqoaLmE
         EbEMvVO+qGc85lCcQd1z80KYnqA4Xl2jgDY5I7Uj7+HGZpysuuhSaUReY849M3Gs1d
         3VXXRHvfaiKWzxo0TN+wG+zW47SFOs0fRU0mbMJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 066/197] Revert "drm/radeon: Fix EEH during kexec"
Date:   Sun, 27 Oct 2019 21:59:44 +0100
Message-Id: <20191027203355.221286144@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 8d13c187c42e110625d60094668a8f778c092879 ]

This reverts commit 6f7fe9a93e6c09bf988c5059403f5f88e17e21e6.

This breaks some boards.  Maybe just enable this on PPC for
now?

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=205147
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_drv.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 5cc0fbb04ab14..7033f3a38c878 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -380,19 +380,11 @@ radeon_pci_remove(struct pci_dev *pdev)
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



