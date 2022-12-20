Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605456517FA
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 02:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiLTBXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 20:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiLTBWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 20:22:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10B413F58;
        Mon, 19 Dec 2022 17:21:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58986B810FA;
        Tue, 20 Dec 2022 01:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B6EC433EF;
        Tue, 20 Dec 2022 01:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499298;
        bh=RGJDOU0CQ402OaMUXRraXDNKYQZybk4l++nVvWs5NCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sbx4fv3fxxsnmSQIakLZkKqRFXhcScNwS3RM/Wssv6MQc8ZE0P5PbnFvI447f0KuE
         k0VHd6OytjMY+2vMRqCYpUFbzd8iUvR4uChMsGUIjsb3uMNPRdS8VZ1Gl/KQ8a2n5u
         Ka8KCWKGWWTiyeDOdO3DJOVfbWGYHeMtZ5Hw3s73XThFHDIOaPYtjhwh3VIucUZ26B
         AZ/BzqzMSLQplfCLY4+M4jq3gPT/NiLImU05vdLSHikljqngTJdMiIUDVoIRjFtjC7
         by77/TAbszOZIGKEomQ7HQwjnyYa8l3tGDUEdENB9iuN1j9D2fX39/yaX1KrsjykHZ
         3EK9odNVJ1Uug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 05/16] Revert "PCI: Clear PCI_STATUS when setting up device"
Date:   Mon, 19 Dec 2022 20:21:15 -0500
Message-Id: <20221220012127.1222311-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221220012127.1222311-1-sashal@kernel.org>
References: <20221220012127.1222311-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index c5286b027f00..bdcad5e0f057 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1890,9 +1890,6 @@ int pci_setup_device(struct pci_dev *dev)
 
 	dev->broken_intx_masking = pci_intx_mask_broken(dev);
 
-	/* Clear errors left from system firmware */
-	pci_write_config_word(dev, PCI_STATUS, 0xffff);
-
 	switch (dev->hdr_type) {		    /* header type */
 	case PCI_HEADER_TYPE_NORMAL:		    /* standard header */
 		if (class == PCI_CLASS_BRIDGE_PCI)
-- 
2.35.1

