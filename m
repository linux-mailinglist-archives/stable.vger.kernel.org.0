Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6828A2F7B48
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732559AbhAOM7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733164AbhAOMd2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:33:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E58CD22473;
        Fri, 15 Jan 2021 12:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713993;
        bh=J6O/mf9ck4oPkLeLET+XSr0OwSoEPyFSgeJupcGvwyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GkFt14O3M9fzGRZxW8zst2imTB6slE/GLd1fKT8pVppgjh0vCKtyBLUfsGSbShNrZ
         1rdHX34M/OUsS5Jvnr18XZiSQcGj6HesqL72SLcr9Mi1jkRDioUAOrTpKHWfggWM1z
         Wnw8zi0QpDEJNr0U9iC0m2cAQw5XbGKjGa1MZLbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7010af67ced6105e5ab6@syzkaller.appspotmail.com,
        Vasily Averin <vvs@virtuozzo.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 42/43] net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet
Date:   Fri, 15 Jan 2021 13:28:12 +0100
Message-Id: <20210115121959.081252851@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 54970a2fbb673f090b7f02d7f57b10b2e0707155 upstream.

syzbot reproduces BUG_ON in skb_checksum_help():
tun creates (bogus) skb with huge partial-checksummed area and
small ip packet inside. Then ip_rcv trims the skb based on size
of internal ip packet, after that csum offset points beyond of
trimmed skb. Then checksum_tg() called via netfilter hook
triggers BUG_ON:

        offset = skb_checksum_start_offset(skb);
        BUG_ON(offset >= skb_headlen(skb));

To work around the problem this patch forces pskb_trim_rcsum_slow()
to return -EINVAL in described scenario. It allows its callers to
drop such kind of packets.

Link: https://syzkaller.appspot.com/bug?id=b419a5ca95062664fe1a60b764621eb4526e2cd0
Reported-by: syzbot+7010af67ced6105e5ab6@syzkaller.appspotmail.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/1b2494af-2c56-8ee2-7bc0-923fcad1cdf8@virtuozzo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skbuff.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1853,6 +1853,12 @@ int pskb_trim_rcsum_slow(struct sk_buff
 		skb->csum = csum_block_sub(skb->csum,
 					   skb_checksum(skb, len, delta, 0),
 					   len);
+	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		int hdlen = (len > skb_headlen(skb)) ? skb_headlen(skb) : len;
+		int offset = skb_checksum_start_offset(skb) + skb->csum_offset;
+
+		if (offset + sizeof(__sum16) > hdlen)
+			return -EINVAL;
 	}
 	return __pskb_trim(skb, len);
 }


