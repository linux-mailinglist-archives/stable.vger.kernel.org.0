Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9323A373A76
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhEEMKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231437AbhEEMJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C009613EC;
        Wed,  5 May 2021 12:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216497;
        bh=Igo1WVPFrmwofjl9l41M+rRDy5nT8Cc3Jia6nEkAyMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d4Gx5K1K7r9Kzg8/0GQkl4UUPZrkpxFUWXVRQVQ8QUnhyx0bBcIGARyP/ZDd/Igqs
         7GluLnR1fxPVleyPVYVLpwa/O+ouCDfwKUU4qQK0ytd1buX9VCgcWkqXDQaKeziOx0
         biI/icVT0RsdCfWtmDKfHYesux5oRRjMjzECTtDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 07/17] net: qrtr: Avoid potential use after free in MHI send
Date:   Wed,  5 May 2021 14:06:02 +0200
Message-Id: <20210505112325.195251818@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.956720416@linuxfoundation.org>
References: <20210505112324.956720416@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 47a017f33943278570c072bc71681809b2567b3a upstream.

It is possible that the MHI ul_callback will be invoked immediately
following the queueing of the skb for transmission, leading to the
callback decrementing the refcount of the associated sk and freeing the
skb.

As such the dereference of skb and the increment of the sk refcount must
happen before the skb is queued, to avoid the skb to be used after free
and potentially the sk to drop its last refcount..

Fixes: 6e728f321393 ("net: qrtr: Add MHI transport layer")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/mhi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -50,6 +50,9 @@ static int qcom_mhi_qrtr_send(struct qrt
 	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
 	int rc;
 
+	if (skb->sk)
+		sock_hold(skb->sk);
+
 	rc = skb_linearize(skb);
 	if (rc)
 		goto free_skb;
@@ -59,12 +62,11 @@ static int qcom_mhi_qrtr_send(struct qrt
 	if (rc)
 		goto free_skb;
 
-	if (skb->sk)
-		sock_hold(skb->sk);
-
 	return rc;
 
 free_skb:
+	if (skb->sk)
+		sock_put(skb->sk);
 	kfree_skb(skb);
 
 	return rc;


