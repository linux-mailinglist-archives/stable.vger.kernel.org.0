Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236AB4C73D5
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbiB1Ri1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238538AbiB1Rh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:37:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909E750059;
        Mon, 28 Feb 2022 09:32:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C4ECB815B3;
        Mon, 28 Feb 2022 17:32:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F51C340F1;
        Mon, 28 Feb 2022 17:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069569;
        bh=C6gmUbI3lDqmvA6/v3kymtV/MNnaqkTM8sJlK3mLUn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CSQ2m6AVeIMWcvfSIO85c9pHFAdMZJuuFz9a3BzQr0KBAHO7oa4PWcMxdyUBEZweH
         AiGB/VsuUDP0jxye1jekLnnr4GAvoj9Zs1v1BhPY+bIUN4NzE+MgO5fx4xj5fIdvR/
         C9IkLFJ8AtKido6oJXtx3mwhIwPrDQkUkWEdYFbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 14/80] CDC-NCM: avoid overflow in sanity checking
Date:   Mon, 28 Feb 2022 18:23:55 +0100
Message-Id: <20220228172313.354550555@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 8d2b1a1ec9f559d30b724877da4ce592edc41fdc upstream.

A broken device may give an extreme offset like 0xFFF0
and a reasonable length for a fragment. In the sanity
check as formulated now, this will create an integer
overflow, defeating the sanity check. Both offset
and offset + len need to be checked in such a manner
that no overflow can occur.
And those quantities should be unsigned.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ncm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1702,10 +1702,10 @@ int cdc_ncm_rx_fixup(struct usbnet *dev,
 {
 	struct sk_buff *skb;
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
-	int len;
+	unsigned int len;
 	int nframes;
 	int x;
-	int offset;
+	unsigned int offset;
 	union {
 		struct usb_cdc_ncm_ndp16 *ndp16;
 		struct usb_cdc_ncm_ndp32 *ndp32;
@@ -1777,8 +1777,8 @@ next_ndp:
 			break;
 		}
 
-		/* sanity checking */
-		if (((offset + len) > skb_in->len) ||
+		/* sanity checking - watch out for integer wrap*/
+		if ((offset > skb_in->len) || (len > skb_in->len - offset) ||
 				(len > ctx->rx_max) || (len < ETH_HLEN)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "invalid frame detected (ignored) offset[%u]=%u, length=%u, skb=%p\n",


