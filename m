Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 070D415C543
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgBMPZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbgBMPZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:51 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADE5B24693;
        Thu, 13 Feb 2020 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607550;
        bh=sDVloQ0gtz8WZ3p0QvAxsOXSizQEKXzw5W9VDqyug68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2BcFmESyhdI4QCuEXFJ51nY397k8bEe4jw+etfYM0K4dp1MKXVslgGrn2Oh3TSum
         RQSv91UCc1LgPeT6fuKRqqZpvWOYhsEB1OorwWkA6peGVLOE/WB3wNDCur8B470Ou5
         A/0ZyPMu5rsr7lKFAb20xrp9uuEqGUte3h3CSVmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 115/173] net: macb: Remove unnecessary alignment check for TSO
Date:   Thu, 13 Feb 2020 07:20:18 -0800
Message-Id: <20200213152001.489242907@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
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
@@ -1577,16 +1577,14 @@ static netdev_features_t macb_features_c
 
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


