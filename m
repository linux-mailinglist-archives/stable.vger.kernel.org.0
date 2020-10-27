Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5934429B7F3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902436AbgJ0P3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798308AbgJ0P0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6915520657;
        Tue, 27 Oct 2020 15:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812404;
        bh=7ZTEBiJnivOrooG7Btd7gzKnSddYnL4vYeWlsfZKq/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuFBrz+7YiDTZbBbOmOJgjUk/18BNhBdUI1T4aZEPC+M3EopxPT7v1EtukyPq6/tx
         tIFTmICeNQYP3GyL2SncFsaqOCX4J8mirENCX0iKHiD9A+rKWMzHKvyYOo24etV9Kd
         dElAcN3ntfR+3svLbgxVl5eqYJUwttnprZ/CMaew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 197/757] brcmfmac: check ndev pointer
Date:   Tue, 27 Oct 2020 14:47:27 +0100
Message-Id: <20201027135459.852965897@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 9c9f015bc9f8839831c7ba0a6d731a3853c464e2 ]

Clang static analysis reports this error

brcmfmac/core.c:490:4: warning: Dereference of null pointer
        (*ifp)->ndev->stats.rx_errors++;
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this block of code

	if (ret || !(*ifp) || !(*ifp)->ndev) {
		if (ret != -ENODATA && *ifp)
			(*ifp)->ndev->stats.rx_errors++;
		brcmu_pkt_buf_free_skb(skb);
		return -ENODATA;
	}

(*ifp)->ndev being NULL is caught as an error
But then it is used to report the error.

So add a check before using it.

Fixes: 91b632803ee4 ("brcmfmac: Use net_device_stats from struct net_device")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200802161804.6126-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index f89010a81ffbe..aa9ced3c86fbd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -486,7 +486,7 @@ static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
 	ret = brcmf_proto_hdrpull(drvr, true, skb, ifp);
 
 	if (ret || !(*ifp) || !(*ifp)->ndev) {
-		if (ret != -ENODATA && *ifp)
+		if (ret != -ENODATA && *ifp && (*ifp)->ndev)
 			(*ifp)->ndev->stats.rx_errors++;
 		brcmu_pkt_buf_free_skb(skb);
 		return -ENODATA;
-- 
2.25.1



