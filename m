Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EEA304B27
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbhAZEvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730507AbhAYSrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:47:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 194ED2310A;
        Mon, 25 Jan 2021 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600388;
        bh=51aHdVLXDLt3PsUVQ8e6XiJdc+h8t2YBjzF49iWhIbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNR4IrRYnTeHJC+wIuTAHXHz8Wfrk7UQgoT77JPLa0pabpxPjB2gSk4mDS9qcCixf
         JXkEI5mQejwfGw+DWB/89WrSysv9S7ApJoM0djOqN3wmSJslst2BIzX5cs9fH918LC
         z72WjuIaW0dLS5600XPvG7TFBCdtmF9zLCbuXF6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 83/86] net: Disable NETIF_F_HW_TLS_RX when RXCSUM is disabled
Date:   Mon, 25 Jan 2021 19:40:05 +0100
Message-Id: <20210125183204.554206537@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

commit a3eb4e9d4c9218476d05c52dfd2be3d6fdce6b91 upstream.

With NETIF_F_HW_TLS_RX packets are decrypted in HW. This cannot be
logically done when RXCSUM offload is off.

Fixes: 14136564c8ee ("net: Add TLS RX offload feature")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
Link: https://lore.kernel.org/r/20210117151538.9411-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/dev.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8692,6 +8692,11 @@ static netdev_features_t netdev_fix_feat
 		}
 	}
 
+	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
+		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
+		features &= ~NETIF_F_HW_TLS_RX;
+	}
+
 	return features;
 }
 


