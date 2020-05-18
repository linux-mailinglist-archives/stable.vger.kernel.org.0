Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAEE1D8580
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbgERRzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbgERRzA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:55:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 889712083E;
        Mon, 18 May 2020 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824500;
        bh=svHddsaV96M/0BQ97tYSdQCU0OUWVwtFZXRg1loGZLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y37ff+rANrA/BHEeH6QGEm5ZkhaAFtwdaEqa6gr6NUcoD4iwftB1k+ikyXNOGYu16
         e8QTfehZc9TYMVD/7tJQ/L/kD0g9pL6fjl3CngxXvXXPenio4s73gLSwMeKMmPhT+Q
         wemXGn5Sy4w4DNX9UfX9al5w4Bo2nd1CxdXjdcBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Camale=C3=B3n?= <noelamac@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 035/147] r8169: re-establish support for RTL8401 chip version
Date:   Mon, 18 May 2020 19:35:58 +0200
Message-Id: <20200518173518.496434575@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1f8492df081bd66255764f3ce82ba1b2c37def49 ]

r8169 never had native support for the RTL8401, however it reportedly
worked with the fallback to RTL8101e [0]. Therefore let's add this
as an explicit assignment.

[0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=956868

Fixes: b4cc2dcc9c7c ("r8169: remove default chip versions")
Reported-by: Camaleón <noelamac@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2202,6 +2202,8 @@ static void rtl8169_get_mac_version(stru
 		{ 0x7cf, 0x348,	RTL_GIGA_MAC_VER_07 },
 		{ 0x7cf, 0x248,	RTL_GIGA_MAC_VER_07 },
 		{ 0x7cf, 0x340,	RTL_GIGA_MAC_VER_13 },
+		/* RTL8401, reportedly works if treated as RTL8101e */
+		{ 0x7cf, 0x240,	RTL_GIGA_MAC_VER_13 },
 		{ 0x7cf, 0x343,	RTL_GIGA_MAC_VER_10 },
 		{ 0x7cf, 0x342,	RTL_GIGA_MAC_VER_16 },
 		{ 0x7c8, 0x348,	RTL_GIGA_MAC_VER_09 },


