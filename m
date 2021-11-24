Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9145BA48
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242446AbhKXMJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242026AbhKXMHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A87096108B;
        Wed, 24 Nov 2021 12:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755471;
        bh=pI6gY5vXND49CJamqzjMf8A7/EWXeHtBvDrPyc32C5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhZ5vHY92Lja7q+HmOSrQRfJA8NBnubGURlOigxawu5X8UX4dHHYFo75/4ehpY/dt
         nllF0b40s6jMiAy5OMaGT4sGHY7KkBBHaMknmpLotVXXzrV8cOLBQn05qNTCUlYWET
         lunki3lLOrpzZwsmyi99oQVq/8r4UXcbq124p6IA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 107/162] nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails
Date:   Wed, 24 Nov 2021 12:56:50 +0100
Message-Id: <20211124115701.794200757@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chengfeng Ye <cyeaa@connect.ust.hk>

[ Upstream commit 9fec40f850658e00a14a7dd9e06f7fbc7e59cc4a ]

skb is already freed by dev_kfree_skb in pn533_fill_fragment_skbs,
but follow error handler branch when pn533_fill_fragment_skbs()
fails, skb is freed again, results in double free issue. Fix this
by not free skb in error path of pn533_fill_fragment_skbs.

Fixes: 963a82e07d4e ("NFC: pn533: Split large Tx frames in chunks")
Fixes: 93ad42020c2d ("NFC: pn533: Target mode Tx fragmentation support")
Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 001c12867e430..9e0d74a08d584 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -2592,7 +2592,7 @@ static int pn533_fill_fragment_skbs(struct pn533 *dev, struct sk_buff *skb)
 		frag = pn533_alloc_skb(dev, frag_size);
 		if (!frag) {
 			skb_queue_purge(&dev->fragment_skb);
-			break;
+			return -ENOMEM;
 		}
 
 		if (!dev->tgt_mode) {
@@ -2662,7 +2662,7 @@ static int pn533_transceive(struct nfc_dev *nfc_dev,
 		/* jumbo frame ? */
 		if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 			rc = pn533_fill_fragment_skbs(dev, skb);
-			if (rc <= 0)
+			if (rc < 0)
 				goto error;
 
 			skb = skb_dequeue(&dev->fragment_skb);
@@ -2734,7 +2734,7 @@ static int pn533_tm_send(struct nfc_dev *nfc_dev, struct sk_buff *skb)
 	/* let's split in multiple chunks if size's too big */
 	if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 		rc = pn533_fill_fragment_skbs(dev, skb);
-		if (rc <= 0)
+		if (rc < 0)
 			goto error;
 
 		/* get the first skb */
-- 
2.33.0



