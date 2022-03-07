Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40A24CF865
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbiCGJxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbiCGJuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1136F723C1;
        Mon,  7 Mar 2022 01:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1504261224;
        Mon,  7 Mar 2022 09:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108DBC340F3;
        Mon,  7 Mar 2022 09:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646228;
        bh=pTjuL6BPXjGQj8a+GNkF6+8a01Bmr4IZIrwdI89SEF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5uKPs/vtW6zDMPrTwRhyige+UeLoQ5Wi8iDKtlB0lr2OTkd0wwJDJA2rFYj62yub
         KUNSf4oio0Sw0ecPkZiAN1HjT65DtQ3HlnaMDbc823huVNACNkg1wqaGz5V/TNYJ3U
         dbjCN/r/NSnt3NDPxIvdpXBTzvGK1SfoyY4pqfhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Palus <jpalus@fastmail.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/262] PCI: mvebu: Fix device enumeration regression
Date:   Mon,  7 Mar 2022 10:17:58 +0100
Message-Id: <20220307091706.238853666@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c49ae619905eebd3f54598a84e4cd2bd58ba8fe9 ]

Jan reported that on Turris Omnia (Armada 385), no PCIe devices were
detected after upgrading from v5.16.1 to v5.16.3 and identified the cause
as the backport of 91a8d79fc797 ("PCI: mvebu: Fix configuring secondary bus
of PCIe Root Port via emulated bridge"), which appeared in v5.17-rc1.

91a8d79fc797 was incorrectly applied from mailing list patch [1] to the
linux git repository [2] probably due to resolving merge conflicts
incorrectly. Fix it now.

[1] https://lore.kernel.org/r/20211125124605.25915-12-pali@kernel.org
[2] https://git.kernel.org/linus/91a8d79fc797

[bhelgaas: commit log]
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215540
Fixes: 91a8d79fc797 ("PCI: mvebu: Fix configuring secondary bus of PCIe Root Port via emulated bridge")
Link: https://lore.kernel.org/r/20220214110228.25825-1-pali@kernel.org
Link: https://lore.kernel.org/r/20220127234917.GA150851@bhelgaas
Reported-by: Jan Palus <jpalus@fastmail.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index 357e9a293edf7..2a3bf82aa4e26 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -1288,7 +1288,8 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
 		 * indirectly via kernel emulated PCI bridge driver.
 		 */
 		mvebu_pcie_setup_hw(port);
-		mvebu_pcie_set_local_dev_nr(port, 0);
+		mvebu_pcie_set_local_dev_nr(port, 1);
+		mvebu_pcie_set_local_bus_nr(port, 0);
 	}
 
 	pcie->nports = i;
-- 
2.34.1



