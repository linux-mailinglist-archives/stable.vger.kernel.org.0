Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AEF53CFB8
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345718AbiFCR4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345563AbiFCRyS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:54:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B0C2A730;
        Fri,  3 Jun 2022 10:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E18561244;
        Fri,  3 Jun 2022 17:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395A3C385B8;
        Fri,  3 Jun 2022 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278756;
        bh=6vq5ZPUa7dZjMfqV76WFz9nRr50JLE/6zI0Y9s9xcII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2EWUFe1x0rhQ5cEZAn7aKa6UcR4Zj1st6BRMYrz2YUU2b14v8APn0iuY1nEDGzN3
         Mqi/7KFS2zizz8ZvuyXIKzWPsmfLwgnwKnHy68FqCitn0tDhyfw71hECK00UHM4JhY
         Gqz0dJi+DsNaGldDyX0CtcmmtfiQo05CpMUJ3u3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.17 17/75] net: ipa: compute proper aggregation limit
Date:   Fri,  3 Jun 2022 19:43:01 +0200
Message-Id: <20220603173822.238798419@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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
 drivers/net/ipa/ipa_endpoint.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -723,13 +723,15 @@ static void ipa_endpoint_init_aggr(struc
 
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
+			u32 buffer_size;
 			bool close_eof;
 			u32 limit;
 
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			limit = ipa_aggr_size_kb(IPA_RX_BUFFER_SIZE);
+			buffer_size = IPA_RX_BUFFER_SIZE - NET_SKB_PAD;
+			limit = ipa_aggr_size_kb(buffer_size);
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = IPA_AGGR_TIME_LIMIT;


