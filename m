Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4094E461E04
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378459AbhK2Sbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:31:36 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49632 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350661AbhK2S3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:29:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A232CE13D4;
        Mon, 29 Nov 2021 18:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37657C53FAD;
        Mon, 29 Nov 2021 18:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210374;
        bh=yTGCE+PKA82WQLG0BX+GiiinujxDF2/e9QBL1/RgVjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrpir4t+Ra33EQHbN505wVFo7kbaBG9eUFxD7cQVzLZ8oQUPcT/zqLJcP8Gi7Wp4m
         O0sE324SMy5M5je1UFidAsrj/Tp6c1QpMNIixWQNTtVC/tADBwI98e+mQ95XAUIiZS
         ll2Aixfl44pLiY7ULZFLyJNZnVAK+67+XtM9mxIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Thangavel <thangavel.k@hcl.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 65/92] net/ncsi : Add payload to be 32-bit aligned to fix dropped packets
Date:   Mon, 29 Nov 2021 19:18:34 +0100
Message-Id: <20211129181709.580523701@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Thangavel <kumarthangavel.hcl@gmail.com>

[ Upstream commit ac132852147ad303a938dda318970dd1bbdfda4e ]

Update NC-SI command handler (both standard and OEM) to take into
account of payload paddings in allocating skb (in case of payload
size is not 32-bit aligned).

The checksum field follows payload field, without taking payload
padding into account can cause checksum being truncated, leading to
dropped packets.

Fixes: fb4ee67529ff ("net/ncsi: Add NCSI OEM command support")
Signed-off-by: Kumar Thangavel <thangavel.k@hcl.com>
Acked-by: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-cmd.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index 0187e65176c05..114ef47db76d3 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -18,6 +18,8 @@
 #include "internal.h"
 #include "ncsi-pkt.h"
 
+static const int padding_bytes = 26;
+
 u32 ncsi_calculate_checksum(unsigned char *data, int len)
 {
 	u32 checksum = 0;
@@ -213,12 +215,17 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
 {
 	struct ncsi_cmd_oem_pkt *cmd;
 	unsigned int len;
+	int payload;
+	/* NC-SI spec DSP_0222_1.2.0, section 8.2.2.2
+	 * requires payload to be padded with 0 to
+	 * 32-bit boundary before the checksum field.
+	 * Ensure the padding bytes are accounted for in
+	 * skb allocation
+	 */
 
+	payload = ALIGN(nca->payload, 4);
 	len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
-		len += 26;
-	else
-		len += nca->payload;
+	len += max(payload, padding_bytes);
 
 	cmd = skb_put_zero(skb, len);
 	memcpy(&cmd->mfr_id, nca->data, nca->payload);
@@ -272,6 +279,7 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 	struct net_device *dev = nd->dev;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
+	int payload;
 	int len = hlen + tlen;
 	struct sk_buff *skb;
 	struct ncsi_request *nr;
@@ -281,14 +289,14 @@ static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
 		return NULL;
 
 	/* NCSI command packet has 16-bytes header, payload, 4 bytes checksum.
+	 * Payload needs padding so that the checksum field following payload is
+	 * aligned to 32-bit boundary.
 	 * The packet needs padding if its payload is less than 26 bytes to
 	 * meet 64 bytes minimal ethernet frame length.
 	 */
 	len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
-	if (nca->payload < 26)
-		len += 26;
-	else
-		len += nca->payload;
+	payload = ALIGN(nca->payload, 4);
+	len += max(payload, padding_bytes);
 
 	/* Allocate skb */
 	skb = alloc_skb(len, GFP_ATOMIC);
-- 
2.33.0



