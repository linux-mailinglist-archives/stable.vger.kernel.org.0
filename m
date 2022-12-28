Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6959E657FF4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiL1QM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234525AbiL1QLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:11:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA351A227
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:09:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FE0360D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B30C433D2;
        Wed, 28 Dec 2022 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243787;
        bh=Jjc9H8ByxV5FEEeucXxpjQhNtP17Ff7Lp2ToEYiH7mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0J03gbc21X3m6YX5Gtk0YRdcz9GLF6G7SbE+Bsh+U93vzIX38Jjd6Stt4pX2CtUX
         M780WlUAeMk7JQ11Hq+VrBGUkr9ZPa/xFAba3NALQBFuwqUFayyEsXQ3Od4CM6E4a1
         xPdlpBfS9d0OgSYP2X6kz8j4b2kJuEFWSCC1HXVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nirmal Patel <nirmal.patel@linux.intel.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0588/1073] PCI: vmd: Disable MSI remapping after suspend
Date:   Wed, 28 Dec 2022 15:36:16 +0100
Message-Id: <20221228144344.018276579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmal Patel <nirmal.patel@linux.intel.com>

[ Upstream commit d899aa668498c07ff217b666ae9712990306e682 ]

MSI remapping is disabled by VMD driver for Intel's Icelake and
newer systems in order to improve performance by setting
VMCONFIG_MSI_REMAP. By design VMCONFIG_MSI_REMAP register is cleared
by firmware during boot. The same register gets cleared when system
is put in S3 power state. VMD driver needs to set this register again
in order to avoid interrupt issues with devices behind VMD if MSI
remapping was disabled before.

Link: https://lore.kernel.org/r/20221109142652.450998-1-nirmal.patel@linux.intel.com
Fixes: ee81ee84f873 ("PCI: vmd: Disable MSI-X remapping when possible")
Signed-off-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index e06e9f4fc50f..98e0746e681c 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -980,6 +980,11 @@ static int vmd_resume(struct device *dev)
 	struct vmd_dev *vmd = pci_get_drvdata(pdev);
 	int err, i;
 
+       if (vmd->irq_domain)
+               vmd_set_msi_remapping(vmd, true);
+       else
+               vmd_set_msi_remapping(vmd, false);
+
 	for (i = 0; i < vmd->msix_count; i++) {
 		err = devm_request_irq(dev, vmd->irqs[i].virq,
 				       vmd_irq, IRQF_NO_THREAD,
-- 
2.35.1



