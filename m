Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90A742911B
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244463AbhJKOPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244125AbhJKONj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:13:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C649F6128C;
        Mon, 11 Oct 2021 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961073;
        bh=H2wGtonXRQ3ezGksb3GjljlWURjnBFJHwrubRUy7DTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOb+JHv7Q7b+urTJnvZkCeXJvy6wxZAdD3D3TxkGlFQQDXn2pkQt9XdOsadraJsny
         YlQezrCMQMbYWeiisV7YorRTUD4jx4nfQojOfuRcLHXgVmjUI5Bg7r81fx1GBph1lk
         KgAdSAQlAX2UlmNWJbo6Za2rcyR1/5cqqBrnasG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 151/151] dsa: tag_dsa: Fix mask for trunked packets
Date:   Mon, 11 Oct 2021 15:47:03 +0200
Message-Id: <20211011134522.723553019@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

commit b44d52a50bc6f191f0ae03f65de8401f3ef039b3 upstream.

A packet received on a trunk will have bit 2 set in Forward DSA tagged
frame. Bit 1 can be either 0 or 1 and is otherwise undefined and bit 0
indicates the frame CFI. Masking with 7 thus results in frames as
being identified as being from a trunk when in fact they are not. Fix
the mask to just look at bit 2.

Fixes: 5b60dadb71db ("net: dsa: tag_dsa: Support reception of packets from LAG devices")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/tag_dsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -176,7 +176,7 @@ static struct sk_buff *dsa_rcv_ll(struct
 	case DSA_CMD_FORWARD:
 		skb->offload_fwd_mark = 1;
 
-		trunk = !!(dsa_header[1] & 7);
+		trunk = !!(dsa_header[1] & 4);
 		break;
 
 	case DSA_CMD_TO_CPU:


