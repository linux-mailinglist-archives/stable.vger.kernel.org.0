Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0933CE229
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346527AbhGSP3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348265AbhGSPYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B596146B;
        Mon, 19 Jul 2021 16:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710639;
        bh=8s8TEK/Xbj+pB8AdCTlyVxz3O5KUi40VYYY3jTVFzuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPS2bbhq3eqgvNCDpiBuGQE12aReudFvawRaf32RKrVFQo3lxV1QA6jQmjQ4pi1mq
         pZF2Dqd1Om+vihj/NoQnBb/o4B+WFH7a5LkU1nESOOlNJpNRbxNzdwYJHgEpTeFkad
         1T3izOgLBP4QSG/1h/4S/V5W3fBKuBu7GpHHMndg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Zhang <ztong0001@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 052/351] misc: alcor_pci: fix null-ptr-deref when there is no PCI bridge
Date:   Mon, 19 Jul 2021 16:49:58 +0200
Message-Id: <20210719144946.265970755@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



