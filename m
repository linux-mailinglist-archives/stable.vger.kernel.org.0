Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631293B600F
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhF1OV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233180AbhF1OVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C19D661C8F;
        Mon, 28 Jun 2021 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889949;
        bh=HXZWMFTM4rc1VvbXjfrhFeBANb2/h4lWBdB8XBCt/d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbK6B8IN3u9+5Ad8Beg4jARH3j4ADRfDhqeAGa0MBTCFmQ/QtZOVnNJjEaF9vTut8
         7zJbMOFA06IdXOToo4TlZ2V+V88/0wLdj5j03mrLfzqOpoKBcoVgl+wYrb+9D9RpEX
         32/RP6oTfI6r7gJC8Ec/Xd+1tYX7Bu4w4/qspdFq1cSMGrkC5KPaR+zD+9Ffrfu687
         CvmIwoT3Hz51EMO644CdpoiQEjR32525zfawwLRC6M6mkGzJ6ktA0fY1cW4k2DE6bc
         JqV0BzLiuaPqsPWL8Yz2L1nUTq1I4ARof5xQkBGWqT6og5ptQodTbw/ODbAKYoYF5Z
         xpCOmz06QXyhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 046/110] qmi_wwan: Do not call netif_rx from rx_fixup
Date:   Mon, 28 Jun 2021 10:17:24 -0400
Message-Id: <20210628141828.31757-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

[ Upstream commit 057d49334c02a79af81c30a8d240e641bd6f1741 ]

When the QMI_WWAN_FLAG_PASS_THROUGH is set, netif_rx() is called from
qmi_wwan_rx_fixup(). When the call to netif_rx() is successful (which is
most of the time), usbnet_skb_return() is called (from rx_process()).
usbnet_skb_return() will then call netif_rx() a second time for the same
skb.

Simplify the code and avoid the redundant netif_rx() call by changing
qmi_wwan_rx_fixup() to always return 1 when QMI_WWAN_FLAG_PASS_THROUGH
is set. We then leave it up to the existing infrastructure to call
netif_rx().

Suggested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6700f1970b24..bc55ec739af9 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -575,7 +575,7 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 
 	if (info->flags & QMI_WWAN_FLAG_PASS_THROUGH) {
 		skb->protocol = htons(ETH_P_MAP);
-		return (netif_rx(skb) == NET_RX_SUCCESS);
+		return 1;
 	}
 
 	switch (skb->data[0] & 0xf0) {
-- 
2.30.2

