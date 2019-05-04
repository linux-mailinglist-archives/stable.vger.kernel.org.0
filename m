Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAE613900
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfEDK10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbfEDK10 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:27:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F153B20859;
        Sat,  4 May 2019 10:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965645;
        bh=oyxowGJZUWZSwIngobzJpxJkdNTsS5uLUzAv/L0Q1vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsLLW8FcjmEjJ6LfwxY4UqVyijJneLjTgIRN8FUWkpFmGmfnEDCNHW1G7LxNEgILU
         umRBgfwN1iFaRSH2a+U1yNeknyxQqZmGBs6R7pJxfY8aTLhRsqIeg9DF1nTXJU4YEO
         Grb/3/42an8mee2Rd9lwAnWbijzbc5ilfnIXGjuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 18/23] net/tls: dont copy negative amounts of data in reencrypt
Date:   Sat,  4 May 2019 12:25:20 +0200
Message-Id: <20190504102452.122933007@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102451.512405835@linuxfoundation.org>
References: <20190504102451.512405835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 97e1caa517e22d62a283b876fb8aa5f4672c83dd ]

There is no guarantee the record starts before the skb frags.
If we don't check for this condition copy amount will get
negative, leading to reads and writes to random memory locations.
Familiar hilarity ensues.

Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -600,14 +600,16 @@ static int tls_device_reencrypt(struct s
 	else
 		err = 0;
 
-	copy = min_t(int, skb_pagelen(skb) - offset,
-		     rxm->full_len - TLS_CIPHER_AES_GCM_128_TAG_SIZE);
+	if (skb_pagelen(skb) > offset) {
+		copy = min_t(int, skb_pagelen(skb) - offset,
+			     rxm->full_len - TLS_CIPHER_AES_GCM_128_TAG_SIZE);
 
-	if (skb->decrypted)
-		skb_store_bits(skb, offset, buf, copy);
+		if (skb->decrypted)
+			skb_store_bits(skb, offset, buf, copy);
 
-	offset += copy;
-	buf += copy;
+		offset += copy;
+		buf += copy;
+	}
 
 	skb_walk_frags(skb, skb_iter) {
 		copy = min_t(int, skb_iter->len,


