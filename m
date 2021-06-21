Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE903AEFF5
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhFUQnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232896AbhFUQlm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C79536134F;
        Mon, 21 Jun 2021 16:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293054;
        bh=eTN+BlV+f0iQcq7YZMIiD7nRsr9dem6v+4GLnTTvicY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mk7eTNDVmetE7N2rGBn2zxJ2KTDwMMOTUthainfiKE2z7mXZYIoR+4vv+hA6gCY4W
         lr8gg66DSoK/sRzVB3XDwW+c4jQu46U4BXlXhIiEAb9ao+Fk0JGSf78mbG/aUFXQX8
         DbbaSkIzZJ3og0aC76BzpcSkzL82i7Pj3/v6VSag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linyu Yuan <linyyuan@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 081/178] net: cdc_eem: fix tx fixup skb leak
Date:   Mon, 21 Jun 2021 18:14:55 +0200
Message-Id: <20210621154925.381556757@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linyu Yuan <linyyuan@codeaurora.org>

[ Upstream commit c3b26fdf1b32f91c7a3bc743384b4a298ab53ad7 ]

when usbnet transmit a skb, eem fixup it in eem_tx_fixup(),
if skb_copy_expand() failed, it return NULL,
usbnet_start_xmit() will have no chance to free original skb.

fix it by free orginal skb in eem_tx_fixup() first,
then check skb clone status, if failed, return NULL to usbnet.

Fixes: 9f722c0978b0 ("usbnet: CDC EEM support (v5)")
Signed-off-by: Linyu Yuan <linyyuan@codeaurora.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_eem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_eem.c b/drivers/net/usb/cdc_eem.c
index 0eeec80bec31..e4a570366646 100644
--- a/drivers/net/usb/cdc_eem.c
+++ b/drivers/net/usb/cdc_eem.c
@@ -123,10 +123,10 @@ static struct sk_buff *eem_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	}
 
 	skb2 = skb_copy_expand(skb, EEM_HEAD, ETH_FCS_LEN + padlen, flags);
+	dev_kfree_skb_any(skb);
 	if (!skb2)
 		return NULL;
 
-	dev_kfree_skb_any(skb);
 	skb = skb2;
 
 done:
-- 
2.30.2



