Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFB6E669A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbfJ0VN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbfJ0VN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:13:27 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B756214AF;
        Sun, 27 Oct 2019 21:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210806;
        bh=cGKaG+sIJXN3R17mfFAZRimwr/pX/jFKKA3LlGWydfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1i4Bym/72usRsjojfcwN/Vc4kkkUT1i6RGuz8PgxaMvulKfD6WhdcTIf3Xij5JThz
         uof7kGZVav53ZsChgkb3b63E75Frk6IYKHHye43zdo25ygGtJE+Tx1oEHPHN2NzUPo
         5yXZXLcNgosxcLgQm4uy40Ya7FNojEtG/5neJhqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/93] Revert "drm/radeon: Fix EEH during kexec"
Date:   Sun, 27 Oct 2019 22:00:35 +0100
Message-Id: <20191027203256.048594990@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
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
index d83310751a8e4..c26f09b47ecb2 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -395,19 +395,11 @@ radeon_pci_remove(struct pci_dev *pdev)
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



