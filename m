Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A784CF6E1
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbiCGJn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240769AbiCGJld (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157E666AD7;
        Mon,  7 Mar 2022 01:38:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F660B810CF;
        Mon,  7 Mar 2022 09:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8201C340E9;
        Mon,  7 Mar 2022 09:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645887;
        bh=Eh2WeKqTavGzTnH3f6/Gs+4fsRnL4WgUk8uScgtTKnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XagP2rc4YP4NphB6xYcQBiOXM/XokaitXh/Gbaga0U0+D+bbtLO+uOSuJ/j2g4m77
         mr1JyO9o5HLaRFQPUxriUkAGME+Z2Eq6sT8YTDsT7shDTvuwEHha6cUPeFz+XBVWLY
         2EAjyVOn/KQz1yhumARGuvJBFn/7FyBgk37zV0HY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/262] PCI: mvebu: Do not modify PCI IO type bits in conf_write
Date:   Mon,  7 Mar 2022 10:16:51 +0100
Message-Id: <20220307091704.394222002@linuxfoundation.org>
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

[ Upstream commit 2cf150216e5b5619d7c25180ccf2cc8ac7bebc13 ]

PCI IO type bits are already initialized in mvebu_pci_bridge_emul_init()
function and only when IO support is enabled. These type bits are read-only
and pci-bridge-emul.c code already does not allow to modify them from upper
layers.

When IO support is disabled then all IO registers should be read-only and
return zeros. Therefore do not modify PCI IO type bits in
mvebu_pci_bridge_emul_base_conf_write() callback.

Link: https://lore.kernel.org/r/20211125124605.25915-8-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index f4971fc72a772..5d5f23b1d355b 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -497,13 +497,6 @@ mvebu_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 	}
 
 	case PCI_IO_BASE:
-		/*
-		 * We keep bit 1 set, it is a read-only bit that
-		 * indicates we support 32 bits addressing for the
-		 * I/O
-		 */
-		conf->iobase |= PCI_IO_RANGE_TYPE_32;
-		conf->iolimit |= PCI_IO_RANGE_TYPE_32;
 		mvebu_pcie_handle_iobase_change(port);
 		break;
 
-- 
2.34.1



