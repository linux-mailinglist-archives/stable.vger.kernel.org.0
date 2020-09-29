Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C47B27C39D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgI2LHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728541AbgI2LG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:06:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4907B21D43;
        Tue, 29 Sep 2020 11:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377616;
        bh=jk5yCf6vWpbB1vuIMvJZXyL+/2yga0Fm05br/6Wq3BI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixNXykypfxp7HsCYYUoVl6C35vV0wcS7LUhzdRGeUEFQVbObxUIlI7tHfRELfLZVW
         CNVx2qprrbAGNRcxlmxPCg7DYm7mvfOQD3g4hUAuxzniYDH/aeuB5EsMaGieJnf671
         oLuStk/0iRexGcHbPC9sVaYZtE7Chx2/EC4Zd6v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 011/121] net/hsr: Check skb_put_padto() return value
Date:   Tue, 29 Sep 2020 12:59:15 +0200
Message-Id: <20200929105930.740203542@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 414e7d76af6d3ec2dd4e9079927dbe0e2e4ca914 upstream.

skb_put_padto() will free the sk_buff passed as reference in case of
errors, but we still need to check its return value and decide what to
do.

Detected by CoverityScan, CID#1416688 ("CHECKED_RETURN")

Fixes: ee1c27977284 ("net/hsr: Added support for HSR v1")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/hsr/hsr_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -315,7 +315,8 @@ static void send_hsr_supervision_frame(s
 	hsr_sp = (typeof(hsr_sp)) skb_put(skb, sizeof(struct hsr_sup_payload));
 	ether_addr_copy(hsr_sp->MacAddressA, master->dev->dev_addr);
 
-	skb_put_padto(skb, ETH_ZLEN + HSR_HLEN);
+	if (skb_put_padto(skb, ETH_ZLEN + HSR_HLEN))
+		return;
 
 	hsr_forward_skb(skb, master);
 	return;


