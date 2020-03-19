Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D475E18B621
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730470AbgCSNY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730330AbgCSNY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:24:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B201F207FC;
        Thu, 19 Mar 2020 13:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624268;
        bh=4IvRtb3rTiuw17XBaIXnTOo3FQHO7gh5aQDy2qP9z9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWdlLPx86jn/B29bmvTiKk1XKy04wCnrpeYCU/75ad80Se3/DGKqN65OQLKzQFL9X
         yf23iyIlHW2+4KuzVF1DeNJYx11m7rVioguwpOjE2yLYxD39P39/1HYOs8egIfbeXn
         a6Maarc3V4ldQGfYEuL0yEwiFN3mK31rylYzOg44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carl Huang <cjhuang@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 53/60] net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
Date:   Thu, 19 Mar 2020 14:04:31 +0100
Message-Id: <20200319123936.120009983@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
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
@@ -196,7 +196,7 @@ static int qrtr_node_enqueue(struct qrtr
 	hdr->size = cpu_to_le32(len);
 	hdr->confirm_rx = 0;
 
-	skb_put_padto(skb, ALIGN(len, 4));
+	skb_put_padto(skb, ALIGN(len, 4) + sizeof(*hdr));
 
 	mutex_lock(&node->ep_lock);
 	if (node->ep)


