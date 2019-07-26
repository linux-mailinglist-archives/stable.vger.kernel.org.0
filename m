Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC4076DD9
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389004AbfGZPaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388997AbfGZPaH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:30:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4A7222CB9;
        Fri, 26 Jul 2019 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155006;
        bh=qV1uPx44c/lDnu2VPvoFyoVq2I1KcqlgPo8CaBaqsCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zasXpcDCukye0AHExWq3WMInTFB+i8I84OfjsgH9StxqSObXMaw9XtDJbuCToG79B
         fWeEUadGrsnn4LNVJEI3OvVtk9QrXZMWK4NuhWNHCCkT+XA5Pa80zsoU/duf9EjWjh
         g3X5w2WOyhnVtxxGEIUTrkC736VfW28qhSOSmJnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Steinmetz <ast@domdv.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 33/62] macsec: fix checksumming after decryption
Date:   Fri, 26 Jul 2019 17:24:45 +0200
Message-Id: <20190726152305.271918226@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
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
@@ -869,6 +869,7 @@ static void macsec_reset_skb(struct sk_b
 
 static void macsec_finalize_skb(struct sk_buff *skb, u8 icv_len, u8 hdr_len)
 {
+	skb->ip_summed = CHECKSUM_NONE;
 	memmove(skb->data + hdr_len, skb->data, 2 * ETH_ALEN);
 	skb_pull(skb, hdr_len);
 	pskb_trim_unique(skb, skb->len - icv_len);


