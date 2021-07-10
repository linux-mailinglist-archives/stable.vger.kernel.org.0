Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9263C2DC1
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhGJCZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231908AbhGJCY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:24:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 220BF613BE;
        Sat, 10 Jul 2021 02:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883733;
        bh=8s8TEK/Xbj+pB8AdCTlyVxz3O5KUi40VYYY3jTVFzuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh1jPYxfHtSzjUBd+cDRW4/DmOehqB/QGgo3udlF66AYZ8UDeQGvd8wa5ib2V84+x
         tTKR2YSpceS5XJ+RkykKi3OfEB4ByxxGzYNNF+k7axoOzFvB7erQqKSLerUaUXDHU/
         4YtbcZvGp2+rcaRZeY/mfmBog47bQ3/UJ0CxByfS8t1kh+QWIn/FA2K2wi8eKHOajl
         WqWnybVF3VwrwQTFFCElq3z3HlPSZHDwtz1jTbPc8fa3GcIHVhsh7LIEsCdj/gRcGI
         AOuoPg7kABpm8F89uTPS5YQ5Q3qVt5Y9HFN4+WEUzV+llIXkN3bSwayP7k3B5nRNLX
         ujt+/j3z290Wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 013/104] misc: alcor_pci: fix null-ptr-deref when there is no PCI bridge
Date:   Fri,  9 Jul 2021 22:20:25 -0400
Message-Id: <20210710022156.3168825-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 3ce3e45cc333da707d4d6eb433574b990bcc26f5 ]

There is an issue with the ASPM(optional) capability checking function.
A device might be attached to root complex directly, in this case,
bus->self(bridge) will be NULL, thus priv->parent_pdev is NULL.
Since alcor_pci_init_check_aspm(priv->parent_pdev) checks the PCI link's
ASPM capability and populate parent_cap_off, which will be used later by
alcor_pci_aspm_ctrl() to dynamically turn on/off device, what we can do
here is to avoid checking the capability if we are on the root complex.
This will make pdev_cap_off 0 and alcor_pci_aspm_ctrl() will simply
return when bring called, effectively disable ASPM for the device.

[    1.246492] BUG: kernel NULL pointer dereference, address: 00000000000000c0
[    1.248731] RIP: 0010:pci_read_config_byte+0x5/0x40
[    1.253998] Call Trace:
[    1.254131]  ? alcor_pci_find_cap_offset.isra.0+0x3a/0x100 [alcor_pci]
[    1.254476]  alcor_pci_probe+0x169/0x2d5 [alcor_pci]

Co-developed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Link: https://lore.kernel.org/r/20210513040732.1310159-1-ztong0001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/alcor_pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/cardreader/alcor_pci.c b/drivers/misc/cardreader/alcor_pci.c
index cd402c89189e..0a62307f7ffb 100644
--- a/drivers/misc/cardreader/alcor_pci.c
+++ b/drivers/misc/cardreader/alcor_pci.c
@@ -139,7 +139,13 @@ static void alcor_pci_init_check_aspm(struct alcor_pci_priv *priv)
 	u32 val32;
 
 	priv->pdev_cap_off    = alcor_pci_find_cap_offset(priv, priv->pdev);
-	priv->parent_cap_off = alcor_pci_find_cap_offset(priv,
+	/*
+	 * A device might be attached to root complex directly and
+	 * priv->parent_pdev will be NULL. In this case we don't check its
+	 * capability and disable ASPM completely.
+	 */
+	if (!priv->parent_pdev)
+		priv->parent_cap_off = alcor_pci_find_cap_offset(priv,
 							 priv->parent_pdev);
 
 	if ((priv->pdev_cap_off == 0) || (priv->parent_cap_off == 0)) {
-- 
2.30.2

