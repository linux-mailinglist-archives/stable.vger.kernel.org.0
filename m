Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED9F333E6D
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhCJN0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232832AbhCJNZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E4336509D;
        Wed, 10 Mar 2021 13:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382727;
        bh=/njeAngNDUY7boyAqABp6iWVkUY+jhqRBquVjom9DS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASmu0TCWfrELG0KQx9G8mYF9wh9aiRQT99MyvW6/ORA8Cse7NAkp+HGF8zyuenR6N
         kFP3xZITU3Ko4sdrJSfHpxioo31YghltDxrdiPG8nsqG6e5R85+GTuMeDZ0PXxLuQM
         moLzKRRJ4V7KAfhdmq/EL902VKknkefL1eECsvbY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 20/39] r8169: fix resuming from suspend on RTL8105e if machine runs on battery
Date:   Wed, 10 Mar 2021 14:24:28 +0100
Message-Id: <20210310132320.357631522@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
References: <20210310132319.708237392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 drivers/net/ethernet/realtek/r8169.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4238,6 +4238,7 @@ static void r8168_pll_power_down(struct
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
@@ -4265,6 +4266,7 @@ static void r8168_pll_power_up(struct rt
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:


