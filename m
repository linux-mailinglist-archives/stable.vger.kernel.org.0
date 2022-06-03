Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B6453D0C9
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245165AbiFCSIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346967AbiFCSFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:05:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC705A2F2;
        Fri,  3 Jun 2022 10:58:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5DA3615C8;
        Fri,  3 Jun 2022 17:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A721DC385A9;
        Fri,  3 Jun 2022 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279055;
        bh=0Hxm7VfHN0KwafIDjex29HGSMuWAetdQhX0hc5y9oEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9iRsgKhHgLkhf+0SZEzfYibmLNiv8fC6uaKUxySttsL+PyHshgVanOYcdLcxqth2
         nd5AHWPRWuUNbQ0O5bZZa9X3MFmIp/ilgkE6PQ2RWjf4YpFQlTa/92vA7QZeJX8o6f
         OegFcpIkwbZnip3qiRY1mUfN70ybcamrj6hCoKv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.18 06/67] net: ipa: compute proper aggregation limit
Date:   Fri,  3 Jun 2022 19:43:07 +0200
Message-Id: <20220603173820.916586811@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

commit c5794097b269f15961ed78f7f27b50e51766dec9 upstream.

The aggregation byte limit for an endpoint is currently computed
based on the endpoint's receive buffer size.

However, some bytes at the front of each receive buffer are reserved
on the assumption that--as with SKBs--it might be useful to insert
data (such as headers) before what lands in the buffer.

The aggregation byte limit currently doesn't take into account that
reserved space, and as a result, aggregation could require space
past that which is available in the buffer.

Fix this by reducing the size used to compute the aggregation byte
limit by the NET_SKB_PAD offset reserved for each receive buffer.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/ipa_endpoint.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -130,9 +130,10 @@ static bool ipa_endpoint_data_valid_one(
 		 */
 		if (data->endpoint.config.aggregation) {
 			limit += SZ_1K * aggr_byte_limit_max(ipa->version);
-			if (buffer_size > limit) {
+			if (buffer_size - NET_SKB_PAD > limit) {
 				dev_err(dev, "RX buffer size too large for aggregated RX endpoint %u (%u > %u)\n",
-					data->endpoint_id, buffer_size, limit);
+					data->endpoint_id,
+					buffer_size - NET_SKB_PAD, limit);
 
 				return false;
 			}
@@ -739,6 +740,7 @@ static void ipa_endpoint_init_aggr(struc
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
 			const struct ipa_endpoint_rx_data *rx_data;
+			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
 
@@ -746,7 +748,8 @@ static void ipa_endpoint_init_aggr(struc
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			limit = ipa_aggr_size_kb(rx_data->buffer_size);
+			buffer_size = rx_data->buffer_size;
+			limit = ipa_aggr_size_kb(buffer_size - NET_SKB_PAD);
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = IPA_AGGR_TIME_LIMIT;


