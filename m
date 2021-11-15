Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79124450C4C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbhKORhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238250AbhKORdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB2F6325E;
        Mon, 15 Nov 2021 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996939;
        bh=rCtr6bpO4O8OVea8WTdmqgIsgLofSsTjC1wjW8B5/+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qv2qo8XBRbwWZyTL/eCUH78E9DNiGoHa7cbqZ9p0WLZitPOPJVuOEZvFAXRtOrhMT
         02i/h9BHqsEV8udaAUKKfF+elTGmIjIq4d4sBh6+wpy049NVmU3f+AdZ+XzEKrTmWc
         Wusu36nkARBsbxhmKfZcls4rKWAJBwioZufdAhoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chengfeng Ye <cyeaa@connect.ust.hk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 324/355] nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails
Date:   Mon, 15 Nov 2021 18:04:08 +0100
Message-Id: <20211115165324.213523830@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
 drivers/nfc/pn533/pn533.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 3ea38ce86cc9f..807b7b37d9dce 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2072,7 +2072,7 @@ static int pn533_fill_fragment_skbs(struct pn533 *dev, struct sk_buff *skb)
 		frag = pn533_alloc_skb(dev, frag_size);
 		if (!frag) {
 			skb_queue_purge(&dev->fragment_skb);
-			break;
+			return -ENOMEM;
 		}
 
 		if (!dev->tgt_mode) {
@@ -2143,7 +2143,7 @@ static int pn533_transceive(struct nfc_dev *nfc_dev,
 		/* jumbo frame ? */
 		if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 			rc = pn533_fill_fragment_skbs(dev, skb);
-			if (rc <= 0)
+			if (rc < 0)
 				goto error;
 
 			skb = skb_dequeue(&dev->fragment_skb);
@@ -2215,7 +2215,7 @@ static int pn533_tm_send(struct nfc_dev *nfc_dev, struct sk_buff *skb)
 	/* let's split in multiple chunks if size's too big */
 	if (skb->len > PN533_CMD_DATAEXCH_DATA_MAXLEN) {
 		rc = pn533_fill_fragment_skbs(dev, skb);
-		if (rc <= 0)
+		if (rc < 0)
 			goto error;
 
 		/* get the first skb */
-- 
2.33.0



