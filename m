Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0C04725D1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhLMJqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:46:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58028 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhLMJob (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:44:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA0EFB80E23;
        Mon, 13 Dec 2021 09:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A762C00446;
        Mon, 13 Dec 2021 09:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388667;
        bh=v8sDFuNm0OB9rrbzdrg2J85zpwIIIL8wrbxInuL6A5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjmtiyOeh33h8hdCxoUfJknodAZBFCwWf8zezvat9SfTI3t1cAY0ticwlhkCQ9hU/
         mI+rm0J50Cu1B7EpYN4mubOS7ojXxFM2YzUOqHnuR3q5KjPLO4+ouK9dR2tRxRTo+S
         QKjrIoqGn9fEqjghr7+9GGFGs+gk4eKxPSq/Y9f8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 23/88] udp: using datalen to cap max gso segments
Date:   Mon, 13 Dec 2021 10:29:53 +0100
Message-Id: <20211213092934.015054757@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

commit 158390e45612ef0fde160af0826f1740c36daf21 upstream.

The max number of UDP gso segments is intended to cap to UDP_MAX_SEGMENTS,
this is checked in udp_send_skb():

    if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
        kfree_skb(skb);
        return -EINVAL;
    }

skb->len contains network and transport header len here, we should use
only data len instead.

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/900742e5-81fb-30dc-6e0b-375c6cdd7982@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -845,7 +845,7 @@ static int udp_send_skb(struct sk_buff *
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
+		if (datalen > cork->gso_size * UDP_MAX_SEGMENTS) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}


