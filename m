Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2932D3B63D0
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbhF1PAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235291AbhF1O6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41FF661D55;
        Mon, 28 Jun 2021 14:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891234;
        bh=mxIimWiACeddCVSoyJmIkO39lqBmr85dN1XDr12E3WA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7+kr7Xrh7bjBGen7koTe/U+W8p33P9m+HX2VryUMjSoF+XSYe0rPVNFn6X7ZOeNv
         moG4qc56TdJEPNfGcKEcQpu3X05iF2OXKBlSKbgFPqkygPcuh0pJ1nT4UaPTUiFIUX
         FPx5WfahjUefHFDgsHCvptqEtjXfW9tHD1x0gwxTTPF5SIZyKX4jk2jwszX/CFkNOW
         cNHJixoswJq3yHNKWx6t+Z/xOe1mGHimd9J6UGVZR5czMakpNrc4bYIlvbM7Zk9NOU
         hXAEc1RMk7RIt260TXSoBLAXk2Fb03c5fMz9/hgkfpM0WdBZGdnfAnj0iZHs9Vph2z
         WL7SGmRIyodFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linyu Yuan <linyyuan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 34/71] net: cdc_eem: fix tx fixup skb leak
Date:   Mon, 28 Jun 2021 10:39:26 -0400
Message-Id: <20210628144003.34260-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144003.34260-1-sashal@kernel.org>
References: <20210628144003.34260-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index f7180f8db39e..9c15e1a1261b 100644
--- a/drivers/net/usb/cdc_eem.c
+++ b/drivers/net/usb/cdc_eem.c
@@ -138,10 +138,10 @@ static struct sk_buff *eem_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
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

