Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D844F2E63C4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405167AbgL1Pmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405485AbgL1Nq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:46:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88D6D208BA;
        Mon, 28 Dec 2020 13:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163178;
        bh=DKL+32FwI2X1IU8ZsUn0Igqg12NRLvU6tKvA9/2KAns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXr6ErmyoYZcqQto+Fe8VFTpZXEsJupb7TQ3M56wkxgrIwektYJwzBsiC2GaLK5yh
         dhw2ohi8n2pR2thV9IDUlFY4/eBUnfsOZ5MHajnbTfHBMPrLm5DdQdSLHBcCyxcyOF
         McNkCK7eCfTvC0xDy1QSgT5r6gb3hzkqM5A86eYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/453] ath10k: Fix an error handling path
Date:   Mon, 28 Dec 2020 13:47:13 +0100
Message-Id: <20201228124946.692262149@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit ed3573bc3943c27d2d8e405a242f87ed14572ca1 ]

If 'ath10k_usb_create()' fails, we should release some resources and report
an error instead of silently continuing.

Fixes: 4db66499df91 ("ath10k: add initial USB support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201122170342.1346011-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 1e0343081be91..3f3675aa782fb 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1009,6 +1009,8 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 
 	ar_usb = ath10k_usb_priv(ar);
 	ret = ath10k_usb_create(ar, interface);
+	if (ret)
+		goto err;
 	ar_usb->ar = ar;
 
 	ar->dev_id = product_id;
-- 
2.27.0



