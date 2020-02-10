Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C93157907
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbgBJMiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:38:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbgBJMiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:52 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8422D20873;
        Mon, 10 Feb 2020 12:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338331;
        bh=lUGMPVwglRWAlieNZ5OqxlF4gbbFWvhR6+24MzY3r+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuQZDbrNREbhAuIjwqyp/8a2wWwl7Xbfg9Y7oPeqDCLBTjzG9bohmwqZMNMOkg640
         Uio/Sv//7oHsnLkMxjSjzwpi6Gd4kkPjhY3qkMK4xAUNjjXcoyVNaJyYSvu4by9uaJ
         xaBY0gpuNlswW3+Y+XCT2UgNJ+XEPjSIsq7cKc/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 275/309] net: macb: Remove unnecessary alignment check for TSO
Date:   Mon, 10 Feb 2020 04:33:51 -0800
Message-Id: <20200210122433.059511653@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
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
@@ -1664,16 +1664,14 @@ static netdev_features_t macb_features_c
 
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


