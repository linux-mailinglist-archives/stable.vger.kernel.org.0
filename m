Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5CA3D6186
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhGZPcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238132AbhGZP3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0379B60C41;
        Mon, 26 Jul 2021 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315816;
        bh=3MUxDA/ipaemF8mrHDTU6gGRbdt2p2zGuhEsJYwkbLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SVooL+wLh/0ESDlsTlZX5MPlXpjGp9vjWb8n8hk2kjtja4eU865KlyiVT0GGCLbg
         o1RGYtDNIos42cOOt6VMpJdYXvVWMSgV4tCqzqQZRJKuldEqmaCOQFsUjr9EBKvkHc
         CDY9k9hxWoVWooWBGCo8fQrLnXrmWBBW3eSX4wro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 079/223] net: dsa: mv88e6xxx: NET_DSA_MV88E6XXX_PTP should depend on NET_DSA_MV88E6XXX
Date:   Mon, 26 Jul 2021 17:37:51 +0200
Message-Id: <20210726153848.835533236@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 99bb2ebab953435852340cdb198c5abbf0bb5dd3 ]

Making global2 support mandatory removed the Kconfig symbol
NET_DSA_MV88E6XXX_GLOBAL2.  This symbol also served as an intermediate
symbol to make NET_DSA_MV88E6XXX_PTP depend on NET_DSA_MV88E6XXX.  With
the symbol removed, the user is always asked about PTP support for
Marvell 88E6xxx switches, even if the latter support is not enabled.

Fix this by reinstating the dependency.

Fixes: 63368a7416df144b ("net: dsa: mv88e6xxx: Make global2 support mandatory")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 05af632b0f59..634a48e6616b 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -12,7 +12,7 @@ config NET_DSA_MV88E6XXX
 config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
-	depends on PTP_1588_CLOCK
+	depends on NET_DSA_MV88E6XXX && PTP_1588_CLOCK
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
-- 
2.30.2



