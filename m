Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8308959D5E6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbiHWJBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346279AbiHWJBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:01:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F6882D39;
        Tue, 23 Aug 2022 01:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1AC6B81C4C;
        Tue, 23 Aug 2022 08:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48251C433C1;
        Tue, 23 Aug 2022 08:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243220;
        bh=EmE0b3BipqP22CZ2IeSNrPTaSB0nxrFpOHiVxEnYbMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehLQZlrHLbd37bFeD7Rncd0IrGN4/WkLNBOkGbHdMRN3hTwTVDlAUr4UV9vZqG0B/
         uzpJqK4zqBBUtcSr50SEcHIhKYHG232vDL+ow42f3gaEjCtTLQp7zUlCW4YqviiNJj
         FOoFX+q+RdPDF6Hyitqc/nuHomnZD25F+sxEgT+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Andrew Melnychenko" <andrew@daynix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 208/365] virtio_net: fix endian-ness for RSS
Date:   Tue, 23 Aug 2022 10:01:49 +0200
Message-Id: <20220823080126.892343887@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

commit 95bb633048fab742230eb2cdf20b8e2676240a54 upstream.

Using native endian-ness for device supplied fields is wrong
on BE platforms. Sparse warns about this.

Fixes: 91f41f01d219 ("drivers/net/virtio_net: Added RSS hash report.")
Cc: "Andrew Melnychenko" <andrew@daynix.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3b3eebad3977..d4e0a775b1ba 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1199,7 +1199,7 @@ static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
 	if (!hdr_hash || !skb)
 		return;
 
-	switch ((int)hdr_hash->hash_report) {
+	switch (__le16_to_cpu(hdr_hash->hash_report)) {
 	case VIRTIO_NET_HASH_REPORT_TCPv4:
 	case VIRTIO_NET_HASH_REPORT_UDPv4:
 	case VIRTIO_NET_HASH_REPORT_TCPv6:
@@ -1217,7 +1217,7 @@ static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
 	default:
 		rss_hash_type = PKT_HASH_TYPE_NONE;
 	}
-	skb_set_hash(skb, (unsigned int)hdr_hash->hash_value, rss_hash_type);
+	skb_set_hash(skb, __le32_to_cpu(hdr_hash->hash_value), rss_hash_type);
 }
 
 static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
-- 
2.37.2



