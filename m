Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853C09CBEF
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 10:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfHZIzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 04:55:32 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:45135 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbfHZIzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 04:55:31 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E101D367;
        Mon, 26 Aug 2019 04:55:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 04:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=psNQ7G
        0rJhXcrlRsuIT6wqLli40/TCBq5AN2Fut7pf0=; b=ViXQlcA+GHAjwpDAltbOZo
        ha/cAgEAmW66wLBqO7InTyVTcOMddB9Ap1EIO7RfX0wo9xYvMi4/VKKdWiAJWZ+g
        LZYW3gZ05059r1ExwYb2V4PdAhug6quH44SrnmNut9GXYx67erdKZTLW8fOc7xNb
        F1+HO+YhdUVinr/3GFQTym0q/xPAdrneFAGqaX0+phPE97HdRjAiDIX3SlnQW3vZ
        XAGOUtoEpd2dws/lrEUbx7mReKwwZStjHQNhR5DnmBTaCowM+o9TlUlPUQQz54zt
        7ba2gQZNG0B+BBhjXZ4yl9J7lZxwOA2iTXPp1Cx4lpMNFITmnXKsvKewvHHhZfIA
        ==
X-ME-Sender: <xms:gp5jXUNcb2bp0KgkSg5amxsIn_isxS_NZ8cbc27vp6FDi9aamba8Wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekledrvddthedruddvkedrvdegieenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:gp5jXXHF8NwUIS6TfHmtPaCxjZGdiSAMKAwmWAMdOIozKN3j3pQCBg>
    <xmx:gp5jXUizaCOxlHiSaGp5B13MZpZjcJIBKkZPrc5jXozQGIVeDNddIQ>
    <xmx:gp5jXbxq6i5Wam5RYnj5__Lfq5WLfzcAZrnxXfr0jTatQYwLTJOU9Q>
    <xmx:gp5jXfkRetY3qkfuUzFtP_4_ipytfdlTNGn08FDIADEWoKqTD0YWOQ>
Received: from localhost (unknown [89.205.128.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00C7F80059;
        Mon, 26 Aug 2019 04:55:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: ufs: Fix NULL pointer dereference in" failed to apply to 4.9-stable tree
To:     adrian.hunter@intel.com, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Aug 2019 10:55:25 +0200
Message-ID: <156680972516376@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c7cfdcf7f1777c7376fc9a239980de04b6b5ea1 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 14 Aug 2019 15:59:50 +0300
Subject: [PATCH] scsi: ufs: Fix NULL pointer dereference in
 ufshcd_config_vreg_hpm()

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

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e274053109d0..029da74bb2f5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7062,6 +7062,9 @@ static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
+	if (!vreg)
+		return 0;
+
 	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
 

