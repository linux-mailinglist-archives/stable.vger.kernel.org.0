Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42AB511B454
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732670AbfLKP0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:59940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732849AbfLKP0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:26:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5715E2173E;
        Wed, 11 Dec 2019 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077994;
        bh=R3PzLCaQxu/5uzwlhPBNV+2f/XzqMhM97bQjyE6C6FA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dU+l8kdY9wYOtZiQrzCrrlFHcm0p7nYAbFf/nNPHU0tzpoEZtkdOLVO5D/Z4+Va9V
         2IEli08ZiDn29HdyxxIUj1pWneoU7fDaZKqhAWKZV+mhO0lYn1aWp6aXJR+d9Iaz8E
         vynPmb5REI503hn5xKMzMu3m4F7EfBKoHvpEDGA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sharvari Harisangam <sharvari@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>
Subject: [PATCH 4.19 236/243] mwifiex: update set_mac_address logic
Date:   Wed, 11 Dec 2019 16:06:38 +0100
Message-Id: <20191211150355.265549381@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sharvari Harisangam <sharvari@marvell.com>

commit 7afb94da3cd8a28ed7ae268143117bf1ac8a3371 upstream.

In set_mac_address, driver check for interfaces with same bss_type
For first STA entry, this would return 3 interfaces since all priv's have
bss_type as 0 due to kzalloc. Thus mac address gets changed for STA
unexpected. This patch adds check for first STA and avoids mac address
change. This patch also adds mac_address change for p2p based on bss_num
type.

Signed-off-by: Sharvari Harisangam <sharvari@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Cc: Brian Norris <briannorris@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -960,10 +960,10 @@ int mwifiex_set_mac_address(struct mwifi
 
 		mac_addr = old_mac_addr;
 
-		if (priv->bss_type == MWIFIEX_BSS_TYPE_P2P)
+		if (priv->bss_type == MWIFIEX_BSS_TYPE_P2P) {
 			mac_addr |= BIT_ULL(MWIFIEX_MAC_LOCAL_ADMIN_BIT);
-
-		if (mwifiex_get_intf_num(priv->adapter, priv->bss_type) > 1) {
+			mac_addr += priv->bss_num;
+		} else if (priv->adapter->priv[0] != priv) {
 			/* Set mac address based on bss_type/bss_num */
 			mac_addr ^= BIT_ULL(priv->bss_type + 8);
 			mac_addr += priv->bss_num;


