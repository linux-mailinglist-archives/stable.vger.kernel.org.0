Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4109E0B4
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbfH0IFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731410AbfH0IFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3677206BA;
        Tue, 27 Aug 2019 08:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893100;
        bh=zSt9OyuCCf+/314BuRfbHEIHr6Hl7XP/JOfES86IgzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUphbPD58LjUtc9t4EyTJ38Bfb5tUXnFpbcUDHj7keiDK1Wy68UC97eyIyoQ+htZr
         mGsIlGxJx+EBo8b8rNb8KrqmQa7TNPUiOB1gcw6VJRRO+CBnHobmo2Ufcdykk98l0V
         PaUtMzzVp88HHwWRz2cUqhSB7mV85d0G5UHm+ZOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.2 121/162] scsi: ufs: Fix NULL pointer dereference in ufshcd_config_vreg_hpm()
Date:   Tue, 27 Aug 2019 09:50:49 +0200
Message-Id: <20190827072742.673224680@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 7c7cfdcf7f1777c7376fc9a239980de04b6b5ea1 upstream.

Fix the following BUG:

  [ 187.065689] BUG: kernel NULL pointer dereference, address: 000000000000001c
  [ 187.065790] RIP: 0010:ufshcd_vreg_set_hpm+0x3c/0x110 [ufshcd_core]
  [ 187.065938] Call Trace:
  [ 187.065959] ufshcd_resume+0x72/0x290 [ufshcd_core]
  [ 187.065980] ufshcd_system_resume+0x54/0x140 [ufshcd_core]
  [ 187.065993] ? pci_pm_restore+0xb0/0xb0
  [ 187.066005] ufshcd_pci_resume+0x15/0x20 [ufshcd_pci]
  [ 187.066017] pci_pm_thaw+0x4c/0x90
  [ 187.066030] dpm_run_callback+0x5b/0x150
  [ 187.066043] device_resume+0x11b/0x220

Voltage regulators are optional, so functions must check they exist
before dereferencing.

Note this issue is hidden if CONFIG_REGULATORS is not set, because the
offending code is optimised away.

Notes for stable:

The issue first appears in commit 57d104c153d3 ("ufs: add UFS power
management support") but is inadvertently fixed in commit 60f0187031c0
("scsi: ufs: disable vccq if it's not needed by UFS device") which in
turn was reverted by commit 730679817d83 ("Revert "scsi: ufs: disable vccq
if it's not needed by UFS device""). So fix applies v3.18 to v4.5 and
v5.1+

Fixes: 57d104c153d3 ("ufs: add UFS power management support")
Fixes: 730679817d83 ("Revert "scsi: ufs: disable vccq if it's not needed by UFS device"")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7032,6 +7032,9 @@ static inline int ufshcd_config_vreg_lpm
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
 


