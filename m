Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F74450CF1
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbhKORqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:46:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238678AbhKORnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:43:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E28632FD;
        Mon, 15 Nov 2021 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997313;
        bh=FOB3JcWUyZ6enclwxHnf5UICU53aZC15a186Q7soA5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujz0fZ/armqI27iI6FdQGE32CdW2YT+JO4HP4l8k+dfQRJvY993/MzEOf5Ejujn3Y
         dXnMtuOjPwZ2WZVcFhVym6xZPkArpS/Xd/xUXy5k2bhhWKD3JbaSyzuHMETb+pBf+T
         VyoykUqpkFgV5B18awAZ5AcEmEwCm0R7rleHYkCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 102/575] ifb: Depend on netfilter alternatively to tc
Date:   Mon, 15 Nov 2021 17:57:07 +0100
Message-Id: <20211115165347.186522478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 046178e726c2977d686ba5e07105d5a6685c830e upstream.

IFB originally depended on NET_CLS_ACT for traffic redirection.
But since v4.5, that may be achieved with NFT_FWD_NETDEV as well.

Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.5+: bcfabee1afd9: netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -148,7 +148,7 @@ config NET_FC
 
 config IFB
 	tristate "Intermediate Functional Block support"
-	depends on NET_CLS_ACT
+	depends on NET_ACT_MIRRED || NFT_FWD_NETDEV
 	select NET_REDIRECT
 	help
 	  This is an intermediate driver that allows sharing of


