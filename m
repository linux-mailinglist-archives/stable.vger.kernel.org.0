Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 557DA18B708
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgCSNU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730038AbgCSNU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:20:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 785002098B;
        Thu, 19 Mar 2020 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624055;
        bh=0taveyrClKRSFHcmYXfJ0NNt6YlS9nmIS9zwpPLOoYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCA2z9DT+R7Zszrn6xWiQUDrDdJ69BbBnK5GNPpdo/Y/umkI+YIXlHA83oGSOh8op
         9YyXYiArwOYTlyyN4nbtQuYBDf+qK8i9/4Qfbyu+OrMfNYnwZZSMWqIOAPpvY8mi4T
         hKN4vqZfBQLH/RUpxiKLpJ9k86CVxS9E4WIMZqZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Huang <cjhuang@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 42/48] net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
Date:   Thu, 19 Mar 2020 14:04:24 +0100
Message-Id: <20200319123916.071662618@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>

commit ce57785bf91b1ceaef4f4bffed8a47dc0919c8da upstream.

The len used for skb_put_padto is wrong, it need to add len of hdr.

In qrtr_node_enqueue, local variable size_t len is assign with
skb->len, then skb_push(skb, sizeof(*hdr)) will add skb->len with
sizeof(*hdr), so local variable size_t len is not same with skb->len
after skb_push(skb, sizeof(*hdr)).

Then the purpose of skb_put_padto(skb, ALIGN(len, 4)) is to add add
pad to the end of the skb's data if skb->len is not aligned to 4, but
unfortunately it use len instead of skb->len, at this line, skb->len
is 32 bytes(sizeof(*hdr)) more than len, for example, len is 3 bytes,
then skb->len is 35 bytes(3 + 32), and ALIGN(len, 4) is 4 bytes, so
__skb_put_padto will do nothing after check size(35) < len(4), the
correct value should be 36(sizeof(*hdr) + ALIGN(len, 4) = 32 + 4),
then __skb_put_padto will pass check size(35) < len(36) and add 1 byte
to the end of skb's data, then logic is correct.

function of skb_push:
void *skb_push(struct sk_buff *skb, unsigned int len)
{
	skb->data -= len;
	skb->len  += len;
	if (unlikely(skb->data < skb->head))
		skb_under_panic(skb, len, __builtin_return_address(0));
	return skb->data;
}

function of skb_put_padto
static inline int skb_put_padto(struct sk_buff *skb, unsigned int len)
{
	return __skb_put_padto(skb, len, true);
}

function of __skb_put_padto
static inline int __skb_put_padto(struct sk_buff *skb, unsigned int len,
				  bool free_on_error)
{
	unsigned int size = skb->len;

	if (unlikely(size < len)) {
		len -= size;
		if (__skb_pad(skb, len, free_on_error))
			return -ENOMEM;
		__skb_put(skb, len);
	}
	return 0;
}

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Cc: Doug Anderson <dianders@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/qrtr/qrtr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -203,7 +203,7 @@ static int qrtr_node_enqueue(struct qrtr
 	hdr->size = cpu_to_le32(len);
 	hdr->confirm_rx = 0;
 
-	skb_put_padto(skb, ALIGN(len, 4));
+	skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
 
 	mutex_lock(&node->ep_lock);
 	if (node->ep)


