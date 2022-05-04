Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CF851A99A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356099AbiEDRSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357178AbiEDROw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00498541A5
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EE5061940
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F2DC385B4;
        Wed,  4 May 2022 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683481;
        bh=FLs2a5xZY5CZ3hC370JczBIhfl5+QTXLD/1JRocAJ24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1073US+qYBQYUZqqfsV4yKkBO4oZqKH50bspxlxJWmbCz+b0/aAQTG9NFEbVSzcF
         oGmmKGYBdHbRcb3l+Ge1/93eXVRVx45od0DrJ6FymW3h4PX7aWW9CW8bjZnWDx489R
         +gMlrvXaAnyt5RANNN0fo9XQ93fsDL0yeCf66vT+aGW0c+aBKM6o50lckl8ZMpjhdR
         nYEef9KCixFpDFmRm/WpEcyDrqTGwXZFdjgmteleC+7nqsPOl22vlrhsInhLsYZRxO
         mAeW+TRpNVRd+hrPQitu+Xd4PL8ucaUl4h+uf3DgbR0HZM5WZ/YqOOzZwxgttkimnn
         firmVg02OpbTA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 01/30] PCI: pci-bridge-emul: Add description for class_revision field
Date:   Wed,  4 May 2022 18:57:26 +0200
Message-Id: <20220504165755.30002-2-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165755.30002-1-kabel@kernel.org>
References: <20220504165755.30002-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 9319230ac147067652b58fe849ffe0ceec098665 upstream.

The current assignment to the class_revision member

  class_revision |= cpu_to_le32(PCI_CLASS_BRIDGE_PCI << 16);

can make the reader think that class is at high 16 bits of the member and
revision at low 16 bits.

In reality, class is at high 24 bits, but the class for PCI Bridge Normal
Decode is PCI_CLASS_BRIDGE_PCI << 8.

Change the assignment and add a comment to make this clearer.

Link: https://lore.kernel.org/r/20211130172913.9727-2-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/pci-bridge-emul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index 37504c2cce9b..0a4e71301537 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -284,7 +284,11 @@ int pci_bridge_emul_init(struct pci_bridge_emul *bridge,
 {
 	BUILD_BUG_ON(sizeof(bridge->conf) != PCI_BRIDGE_CONF_END);
 
-	bridge->conf.class_revision |= cpu_to_le32(PCI_CLASS_BRIDGE_PCI << 16);
+	/*
+	 * class_revision: Class is high 24 bits and revision is low 8 bit of this member,
+	 * while class for PCI Bridge Normal Decode has the 24-bit value: PCI_CLASS_BRIDGE_PCI << 8
+	 */
+	bridge->conf.class_revision |= cpu_to_le32((PCI_CLASS_BRIDGE_PCI << 8) << 8);
 	bridge->conf.header_type = PCI_HEADER_TYPE_BRIDGE;
 	bridge->conf.cache_line_size = 0x10;
 	bridge->conf.status = cpu_to_le16(PCI_STATUS_CAP_LIST);
-- 
2.35.1

