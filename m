Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139ED3A703
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfFIQp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729831AbfFIQpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:45:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E46FA2081C;
        Sun,  9 Jun 2019 16:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098725;
        bh=anG7b5l8TUD3kc7RKq39S5Thv10tZu2qz38hQsN+Xyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4+URRzdRt/NTI1+au331yjx72PgeAAjQvoGX8sdMj9bKq41JUbhz/JtVk4QuWL86
         W49q2IEUG9Q7AliNqpcswfqlQHVu0OQONLCobTpfHGWrWWA1skTv/hoJ9zcq/foGRx
         0kVB4ntHHvPLq/az/5NCY/DsVZw8osM0XoMh1lmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 06/70] net: mvpp2: Use strscpy to handle stat strings
Date:   Sun,  9 Jun 2019 18:41:17 +0200
Message-Id: <20190609164127.850991830@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit d37acd5aa99c57505b64913e0e2624ec3daed8c5 ]

Use a safe strscpy call to copy the ethtool stat strings into the
relevant buffers, instead of a memcpy that will be accessing
out-of-bound data.

Fixes: 118d6298f6f0 ("net: mvpp2: add ethtool GOP statistics")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1304,8 +1304,8 @@ static void mvpp2_ethtool_get_strings(st
 		int i;
 
 		for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_regs); i++)
-			memcpy(data + i * ETH_GSTRING_LEN,
-			       &mvpp2_ethtool_regs[i].string, ETH_GSTRING_LEN);
+			strscpy(data + i * ETH_GSTRING_LEN,
+			        mvpp2_ethtool_regs[i].string, ETH_GSTRING_LEN);
 	}
 }
 


