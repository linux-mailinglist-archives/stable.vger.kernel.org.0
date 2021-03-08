Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1D4330E1B
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhCHMfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhCHMex (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:34:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 883DA651C9;
        Mon,  8 Mar 2021 12:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206893;
        bh=OkDafQvKTcFdS2IodSiW4vL2ELzOLKubu5fv56H+DuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFlblVGCJfO8rgF4UvSaREL8o5dA5Loi682GNTf9qLeU4yIrsfNyjSAoIIrjzdlE7
         AuPpj0IPw1q2KMRSn1d8Td6fJzesiawReC3OGcVS22lEvP5VP3Bm8gXLZjEhLu36L2
         0l20FYVviVu2+mQMTz9bGwiCpl8+gwgwbNvivKdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 42/42] r8169: fix resuming from suspend on RTL8105e if machine runs on battery
Date:   Mon,  8 Mar 2021 13:31:08 +0100
Message-Id: <20210308122720.144343202@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

commit d2a04370817fc7b0172dad2ef2decf907e1a304e upstream.

Armin reported that after referenced commit his RTL8105e is dead when
resuming from suspend and machine runs on battery. This patch has been
confirmed to fix the issue.

Fixes: e80bd76fbf56 ("r8169: work around power-saving bug on some chip versions")
Reported-by: Armin Wolf <W_Armin@gmx.de>
Tested-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2244,6 +2244,7 @@ static void rtl_pll_power_down(struct rt
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
@@ -2271,6 +2272,7 @@ static void rtl_pll_power_up(struct rtl8
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:


