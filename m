Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791721576B2
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBJMyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:54:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgBJMl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F162C20842;
        Mon, 10 Feb 2020 12:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338518;
        bh=uAeh9zkjHRT+u9dTO4iUkbDFjSg+FkJC2JZNbyTc5RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gw/yQe4ogbA75tBPOUR9LNBIQZQQHVIy6qyhs1WQ+VqpJTZBodsh0+rKomrQI7o8p
         +rvoIhJFQtwSDoCDM2NT2OLvMw7WQhQ3jWNRAC3Jbz81EIP+792VdohEAXzCngzZrf
         jRPqRbtDCjuANmpDEvQdcsRQu73b3cnGuvhYa7J4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 328/367] net: macb: Remove unnecessary alignment check for TSO
Date:   Mon, 10 Feb 2020 04:34:01 -0800
Message-Id: <20200210122453.187341846@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

[ Upstream commit 41c1ef978c8d0259c6636e6d2d854777e92650eb ]

The IP TSO implementation does NOT require the length to be a
multiple of 8. That is only a requirement for UFO as per IP
documentation. Hence, exit macb_features_check function in the
beginning if the protocol is not UDP. Only when it is UDP,
proceed further to the alignment checks. Update comments to
reflect the same. Also remove dead code checking for protocol
TCP when calculating header length.

Fixes: 1629dd4f763c ("cadence: Add LSO support.")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1752,16 +1752,14 @@ static netdev_features_t macb_features_c
 
 	/* Validate LSO compatibility */
 
-	/* there is only one buffer */
-	if (!skb_is_nonlinear(skb))
+	/* there is only one buffer or protocol is not UDP */
+	if (!skb_is_nonlinear(skb) || (ip_hdr(skb)->protocol != IPPROTO_UDP))
 		return features;
 
 	/* length of header */
 	hdrlen = skb_transport_offset(skb);
-	if (ip_hdr(skb)->protocol == IPPROTO_TCP)
-		hdrlen += tcp_hdrlen(skb);
 
-	/* For LSO:
+	/* For UFO only:
 	 * When software supplies two or more payload buffers all payload buffers
 	 * apart from the last must be a multiple of 8 bytes in size.
 	 */


