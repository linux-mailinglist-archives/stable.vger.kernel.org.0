Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53A12F14EB
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbhAKNPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732238AbhAKNPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C8D521973;
        Mon, 11 Jan 2021 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370874;
        bh=voa17hyhicDaoIa5/Ekbhr46NkGW059LLvqZ3jV7pH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgRTdVQ8W0t+rC7lTjSb4NBRSt3UWfoe5tnruhHmAkUAacuKwE0ldSAWBUZ4wxRVq
         pWKlnfHh5UAENRh/qtqtUcDXb8jYGjgpxvremw+R6WcQnkAEA/I66K9KT2MqPSLs/K
         g/9es/2IV9TCWIVbvomAO7wnH+rx2HWTTjJHlleE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 042/145] r8169: work around power-saving bug on some chip versions
Date:   Mon, 11 Jan 2021 14:01:06 +0100
Message-Id: <20210111130050.542486628@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit e80bd76fbf563cc7ed8c9e9f3bbcdf59b0897f69 ]

A user reported failing network with RTL8168dp (a quite rare chip
version). Realtek confirmed that few chip versions suffer from a PLL
power-down hw bug.

Fixes: 07df5bd874f0 ("r8169: power down chip in probe")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/a1c39460-d533-7f9e-fa9d-2b8990b02426@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2243,7 +2243,8 @@ static void rtl_pll_power_down(struct rt
 	}
 
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
+	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
 	case RTL_GIGA_MAC_VER_43:
@@ -2269,7 +2270,8 @@ static void rtl_pll_power_down(struct rt
 static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
+	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
 	case RTL_GIGA_MAC_VER_43:


