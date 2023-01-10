Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABE76649AF
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbjAJSXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239346AbjAJSWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:22:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2237E9235D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:20:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFDFA61865
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C595BC433D2;
        Tue, 10 Jan 2023 18:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374839;
        bh=0qpt2WxXVJAOKL0pek8zJjOIL4XuD3ielMRG1ExgNK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLY6qAnwKUEwWHfyCsuzv4gFe6Cn37OYDwtRFyIMX59nh7qzove03uSBJJxWOq44P
         Nn7zO8F9R2DDgChKAGbqgGYYlHThz39nu+ir6I5XE6Ztt97nSJAabSvqSETxXX+Lge
         pqINT3wS0oY6FK6HjnzXePSxRO2Hr/o+VDpgjLdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ronald Wahl <ronald.wahl@raritan.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 133/159] net: dsa: qca8k: fix wrong length value for mgmt eth packet
Date:   Tue, 10 Jan 2023 19:04:41 +0100
Message-Id: <20230110180022.601506833@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Marangi <ansuelsmth@gmail.com>

commit 9807ae69746196ee4bbffe7d22d22ab2b61c6ed0 upstream.

The assumption that Documentation was right about how this value work was
wrong. It was discovered that the length value of the mgmt header is in
step of word size.

As an example to process 4 byte of data the correct length to set is 2.
To process 8 byte 4, 12 byte 6, 16 byte 8...

Odd values will always return the next size on the ack packet.
(length of 3 (6 byte) will always return 8 bytes of data)

This means that a value of 15 (0xf) actually means reading/writing 32 bytes
of data instead of 16 bytes. This behaviour is totally absent and not
documented in the switch Documentation.

In fact from Documentation the max value that mgmt eth can process is
16 byte of data while in reality it can process 32 bytes at once.

To handle this we always round up the length after deviding it for word
size. We check if the result is odd and we round another time to align
to what the switch will provide in the ack packet.
The workaround for the length limit of 15 is still needed as the length
reg max value is 0xf(15)

Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Fixes: 90386223f44e ("net: dsa: qca8k: add support for larger read/write size with mgmt Ethernet")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.18+
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c |   45 ++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 10 deletions(-)

--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -111,7 +111,16 @@ static void qca8k_rw_reg_ack_handler(str
 
 	command = get_unaligned_le32(&mgmt_ethhdr->command);
 	cmd = FIELD_GET(QCA_HDR_MGMT_CMD, command);
+
 	len = FIELD_GET(QCA_HDR_MGMT_LENGTH, command);
+	/* Special case for len of 15 as this is the max value for len and needs to
+	 * be increased before converting it from word to dword.
+	 */
+	if (len == 15)
+		len++;
+
+	/* We can ignore odd value, we always round up them in the alloc function. */
+	len *= sizeof(u16);
 
 	/* Make sure the seq match the requested packet */
 	if (get_unaligned_le32(&mgmt_ethhdr->seq) == mgmt_eth_data->seq)
@@ -158,17 +167,33 @@ static struct sk_buff *qca8k_alloc_mdio_
 	if (!skb)
 		return NULL;
 
-	/* Max value for len reg is 15 (0xf) but the switch actually return 16 byte
-	 * Actually for some reason the steps are:
-	 * 0: nothing
-	 * 1-4: first 4 byte
-	 * 5-6: first 12 byte
-	 * 7-15: all 16 byte
+	/* Hdr mgmt length value is in step of word size.
+	 * As an example to process 4 byte of data the correct length to set is 2.
+	 * To process 8 byte 4, 12 byte 6, 16 byte 8...
+	 *
+	 * Odd values will always return the next size on the ack packet.
+	 * (length of 3 (6 byte) will always return 8 bytes of data)
+	 *
+	 * This means that a value of 15 (0xf) actually means reading/writing 32 bytes
+	 * of data.
+	 *
+	 * To correctly calculate the length we devide the requested len by word and
+	 * round up.
+	 * On the ack function we can skip the odd check as we already handle the
+	 * case here.
 	 */
-	if (len == 16)
-		real_len = 15;
-	else
-		real_len = len;
+	real_len = DIV_ROUND_UP(len, sizeof(u16));
+
+	/* We check if the result len is odd and we round up another time to
+	 * the next size. (length of 3 will be increased to 4 as switch will always
+	 * return 8 bytes)
+	 */
+	if (real_len % sizeof(u16) != 0)
+		real_len++;
+
+	/* Max reg value is 0xf(15) but switch will always return the next size (32 byte) */
+	if (real_len == 16)
+		real_len--;
 
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, skb->len);


