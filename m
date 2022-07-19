Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B0E579B11
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238955AbiGSMY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239736AbiGSMYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2D961134;
        Tue, 19 Jul 2022 05:09:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09FDD6165C;
        Tue, 19 Jul 2022 12:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8FAC341C6;
        Tue, 19 Jul 2022 12:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232482;
        bh=+gmyvOgCkIdlZeHOrXPsGFQ4i4vUrAXEpwwq4tJ8hdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uD3hLWWWhvVfAzXvvKVCi4nXT+lqHWRIwFLRri5GmUcdvdmKTMRC/KJQ9amvK7HlF
         5AUZfTrCMM8PuJVRMv3STc5GhnB3QJr+nuiOd09PE0pSgXodlpjZ99+dBQ/WsXvF0A
         9zaMKmMfTGfJkLKxIUihH2EwAb6oaY9TQDSigvUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/112] net: atlantic: remove aq_nic_deinit() when resume
Date:   Tue, 19 Jul 2022 13:54:06 +0200
Message-Id: <20220719114633.549666637@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

[ Upstream commit 2e15c51fefaffaf9f72255eaef4fada05055e4c5 ]

aq_nic_deinit() has been called while suspending, so we don't have to call
it again on resume.
Actually, call it again leads to another hang issue when resuming from
S3.

Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992345] Call Trace:
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992346] <TASK>
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992348] aq_nic_deinit+0xb4/0xd0 [atlantic]
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992356] aq_pm_thaw+0x7f/0x100 [atlantic]
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992362] pci_pm_resume+0x5c/0x90
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992366] ? pci_pm_thaw+0x80/0x80
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992368] dpm_run_callback+0x4e/0x120
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992371] device_resume+0xad/0x200
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992373] async_resume+0x1e/0x40
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992374] async_run_entry_fn+0x33/0x120
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992377] process_one_work+0x220/0x3c0
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992380] worker_thread+0x4d/0x3f0
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992382] ? process_one_work+0x3c0/0x3c0
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992384] kthread+0x12a/0x150
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992386] ? set_kthread_struct+0x40/0x40
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992387] ret_from_fork+0x22/0x30
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992391] </TASK>
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992392] ---[ end trace 1ec8c79604ed5e0d ]---
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992394] PM: dpm_run_callback(): pci_pm_resume+0x0/0x90 returns -110
Jul 8 03:09:44 u-Precision-7865-Tower kernel: [ 5910.992397] atlantic 0000:02:00.0: PM: failed to resume async: error -110

Fixes: 1809c30b6e5a ("net: atlantic: always deep reset on pm op, fixing up my null deref regression")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Link: https://lore.kernel.org/r/20220713111224.1535938-2-acelan.kao@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 8c05b2b79339..a0ce213c473b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -419,9 +419,6 @@ static int atl_resume_common(struct device *dev)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	/* Reinitialize Nic/Vecs objects */
-	aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);
-
 	if (netif_running(nic->ndev)) {
 		ret = aq_nic_init(nic);
 		if (ret)
-- 
2.35.1



