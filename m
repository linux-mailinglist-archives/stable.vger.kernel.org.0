Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A066584A6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbiL1RAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235359AbiL1Q7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:59:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B1720BD0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76026613E9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:54:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7963DC433D2;
        Wed, 28 Dec 2022 16:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246486;
        bh=XknLPQW+r/NWKRWn+iQQ1a3zK3Edy3Qz6rW4qZq5W+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g9caV9ujxs2QmLAa6DhMYdxtr1NF2zLc62BDLAYMHS59eS+1isCmllsAQ1Wo6dobY
         Qlfh3NIx4kows3wLnXon1CpgQwPwVIbrmqejepKiBDCXemSyZpDqBm4i6v35IO7BaC
         KU1uxeLrDvbfAxgli6BHdvh1HNpApp8nVQ3MeF1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1054/1146] Revert "PCI: Clear PCI_STATUS when setting up device"
Date:   Wed, 28 Dec 2022 15:43:13 +0100
Message-Id: <20221228144358.931859454@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 44e985938e85503d0a69ec538e15fd33c1a4df05 ]

This reverts commit 6cd514e58f12b211d638dbf6f791fa18d854f09c.

Christophe Fergeau reported that 6cd514e58f12 ("PCI: Clear PCI_STATUS when
setting up device") causes boot failures when trying to start linux guests
with Apple's virtualization framework (for example using
https://developer.apple.com/documentation/virtualization/running_linux_in_a_virtual_machine?language=objc)

6cd514e58f12 only solved a cosmetic problem, so revert it to fix the boot
failures.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2137803
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b66fa42c4b1f..1d6f7b502020 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1891,9 +1891,6 @@ int pci_setup_device(struct pci_dev *dev)
 
 	dev->broken_intx_masking = pci_intx_mask_broken(dev);
 
-	/* Clear errors left from system firmware */
-	pci_write_config_word(dev, PCI_STATUS, 0xffff);
-
 	switch (dev->hdr_type) {		    /* header type */
 	case PCI_HEADER_TYPE_NORMAL:		    /* standard header */
 		if (class == PCI_CLASS_BRIDGE_PCI)
-- 
2.35.1



