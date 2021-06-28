Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACE63B6287
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhF1OsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235051AbhF1OoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3962061CD9;
        Mon, 28 Jun 2021 14:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890832;
        bh=AqvEMT3XnDcwxvMx/LyiQkIfQLfstaqypsUfRnYpv2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnLkX31cLMgHjopDkisLkEOtc9JSBAxhF6CNlTiwfVaVOMyZWVdKhdumqYu8pMl2A
         ByGUUYecvwT85pAoENq+Xe3XdsF2uPLRosyLWaofdle/SMTMzqqC2UUtTLNvUeJ7QD
         m0IQRowRpS5g2LJWWjJXBNP3gyEi9LhZeVOB03U7ANLC0zrC38nmH+11NJXtpdWm0d
         iqCrLH/MrP5a4qYx48m9+K2dQSXy0KB6B9PMUXZERHSAH+jyA5e48o9+KatD3d6pxN
         O2QqEwWHVMeDbwuhCK8/1sUCS6lvIKDVhtXTKCOFnw2RgMpwiyolsWrrmucURLOX3r
         fmTL3MCkv7msA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linyu Yuan <linyyuan@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 051/109] net: cdc_eem: fix tx fixup skb leak
Date:   Mon, 28 Jun 2021 10:32:07 -0400
Message-Id: <20210628143305.32978-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index 61ea4eaace5d..e3f108080af1 100644
--- a/drivers/net/usb/cdc_eem.c
+++ b/drivers/net/usb/cdc_eem.c
@@ -135,10 +135,10 @@ static struct sk_buff *eem_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
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

