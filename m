Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F3249A9DB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323747AbiAYD3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376393AbiAXVFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22948C06809D;
        Mon, 24 Jan 2022 12:05:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B610E6091B;
        Mon, 24 Jan 2022 20:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE1CC340E5;
        Mon, 24 Jan 2022 20:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054749;
        bh=8kdnPAkKMFZeojypize7PQeSHKNwYqoEZAm1hMECNzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQQqEWuhZTwKoKleSPx8fxXnh6rd7hEVaZcLjTS0Nrvvf33jneVP4rhaYzsVn1WzU
         BGQVOdwQwb7Xl+7396NNUNUwRcsrdg59TaDa9VkLBHpJchp/Tw2W6Ksbgr8bWUZZsH
         59WnmuhErnKRzviY1gQxxJqQOrbPZ5E22hep6kOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.10 463/563] PCI: pci-bridge-emul: Make expansion ROM Base Address register read-only
Date:   Mon, 24 Jan 2022 19:43:48 +0100
Message-Id: <20220124184040.476639517@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 1c1a3b4d3e86b997a313ffb297c1129540882859 upstream.

If expansion ROM is unsupported (which is the case of pci-bridge-emul.c
driver) then ROM Base Address register must be implemented as read-only
register that return 0 when read, same as for unused Base Address
registers.

Link: https://lore.kernel.org/r/20211124155944.1290-2-pali@kernel.org
Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-bridge-emul.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -139,8 +139,13 @@ struct pci_bridge_reg_behavior pci_regs_
 		.ro = GENMASK(7, 0),
 	},
 
+	/*
+	 * If expansion ROM is unsupported then ROM Base Address register must
+	 * be implemented as read-only register that return 0 when read, same
+	 * as for unused Base Address registers.
+	 */
 	[PCI_ROM_ADDRESS1 / 4] = {
-		.rw = GENMASK(31, 11) | BIT(0),
+		.ro = ~0,
 	},
 
 	/*


