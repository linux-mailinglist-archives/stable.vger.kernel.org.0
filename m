Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599AE330E80
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhCHMhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:37:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231265AbhCHMhA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:37:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86A8965210;
        Mon,  8 Mar 2021 12:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615207020;
        bh=9laLJkxViT8GzsCkcgnBq6DX8/D4RF9Pf+i5XHtp2wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiEWv3ZiFK/2vhPQ5VkcUTHH0LcH8k/cyuNSSA6scJcLMcdgW8+/o1ekbd9QbQwVY
         4TXzCJw0fz/GEgid2vg4RxYxYUR3d6FxHbOCySMmBqmztVuW++8zrjrZVbpFGmVSeU
         g/6E1luvisFvnBb96YHqjInd9rxa0+ZIRRGT6EVY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 44/44] r8169: fix resuming from suspend on RTL8105e if machine runs on battery
Date:   Mon,  8 Mar 2021 13:35:22 +0100
Message-Id: <20210308122720.705591052@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
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
 drivers/net/ethernet/realtek/r8169_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2208,6 +2208,7 @@ static void rtl_pll_power_down(struct rt
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
@@ -2235,6 +2236,7 @@ static void rtl_pll_power_up(struct rtl8
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:


