Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD137F298
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405526AbfHBJqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405507AbfHBJqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8505E206A2;
        Fri,  2 Aug 2019 09:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739178;
        bh=q6j2Oy95N+QPY+zJoAuPKajBTnbLyEzpTRDwFMYELTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFn7sf5DpFtW8+YQKB+XXRrISsdw9z4xi0tXNBTPMHKV80dB3r3gI/RuLjdfWAx0P
         jsSoLh+hUWOnj0yIb306lPKhAI60W02Fuw2kTSstxohjvgzbhFqof7i+GcU7zVZXaU
         7uVPRbODcA4eFr/v/GqU3sYnw/aIh/lVzSc12T1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Steinmetz <ast@domdv.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 143/223] macsec: fix checksumming after decryption
Date:   Fri,  2 Aug 2019 11:36:08 +0200
Message-Id: <20190802092247.932551385@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Steinmetz <ast@domdv.de>

[ Upstream commit 7d8b16b9facb0dd81d1469808dd9a575fa1d525a ]

Fix checksumming after decryption.

Signed-off-by: Andreas Steinmetz <ast@domdv.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -867,6 +867,7 @@ static void macsec_reset_skb(struct sk_b
 
 static void macsec_finalize_skb(struct sk_buff *skb, u8 icv_len, u8 hdr_len)
 {
+	skb->ip_summed = CHECKSUM_NONE;
 	memmove(skb->data + hdr_len, skb->data, 2 * ETH_ALEN);
 	skb_pull(skb, hdr_len);
 	pskb_trim_unique(skb, skb->len - icv_len);


