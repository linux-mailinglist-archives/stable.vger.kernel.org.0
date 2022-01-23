Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B472E497352
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 18:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239052AbiAWRBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 12:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiAWRBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 12:01:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21092C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 09:01:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1C5FB80D31
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF77C340E2;
        Sun, 23 Jan 2022 17:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642957281;
        bh=RX9Xy6x6RpXckaztDgIWpNBMG0FXzwxiRDEMwfc5HHE=;
        h=Subject:To:Cc:From:Date:From;
        b=yUkDge5NBl/GycDtY5Mv7dl3pl/bW/Eth7WmPfEOiPYEaE5sGcI82gML3En6US0Ul
         UvwuZEUPVlL9pWAOIIbHFt+uIfCAp6Ik6slnNTjJaNwcQ9R2n7J4Y8u+QkONYmZ5C4
         t5YM7n2IinJVQQ7bUbtssIB1SCrP/2Da2dr8cyis=
Subject: FAILED: patch "[PATCH] PCI: pci-bridge-emul: Make expansion ROM Base Address" failed to apply to 5.4-stable tree
To:     pali@kernel.org, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 18:01:18 +0100
Message-ID: <16429572781094@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1c1a3b4d3e86b997a313ffb297c1129540882859 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Wed, 24 Nov 2021 16:59:39 +0100
Subject: [PATCH] PCI: pci-bridge-emul: Make expansion ROM Base Address
 register read-only
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If expansion ROM is unsupported (which is the case of pci-bridge-emul.c
driver) then ROM Base Address register must be implemented as read-only
register that return 0 when read, same as for unused Base Address
registers.

Link: https://lore.kernel.org/r/20211124155944.1290-2-pali@kernel.org
Fixes: 23a5fba4d941 ("PCI: Introduce PCI bridge emulated config space common logic")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/pci-bridge-emul.c b/drivers/pci/pci-bridge-emul.c
index db97cddfc85e..5de8b8dde209 100644
--- a/drivers/pci/pci-bridge-emul.c
+++ b/drivers/pci/pci-bridge-emul.c
@@ -139,8 +139,13 @@ struct pci_bridge_reg_behavior pci_regs_behavior[PCI_STD_HEADER_SIZEOF / 4] = {
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

