Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965F6E6962
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfJ0VH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbfJ0VHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:07:23 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 783932064A;
        Sun, 27 Oct 2019 21:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210443;
        bh=WbnXvxpwEoGnorjSiLoymXvZ3F79jV+5PNgIiuu3PTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXWyOkrdUWCarX94e8XY9osv6UXv4A21KFq7VOSlDs03aOPjxvyloid7TAF5oVjhe
         FDP0mqbCLfGeU8UMVDlvD37r5GkDW46kVLieYZ7uwWGG3vBFHypNDQQ/88d83jhfg7
         8S5POXdG+HYDd+qD8ajczoYAYOdSx5DwRFFvnT+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 017/119] Revert "drm/radeon: Fix EEH during kexec"
Date:   Sun, 27 Oct 2019 21:59:54 +0100
Message-Id: <20191027203304.817080909@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
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
index 54d97dd5780a1..f4becad0a78c0 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -368,19 +368,11 @@ radeon_pci_remove(struct pci_dev *pdev)
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



