Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE275412AA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356195AbiFGTxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357514AbiFGTu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:50:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AFA7E1E5;
        Tue,  7 Jun 2022 11:19:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD0E360A21;
        Tue,  7 Jun 2022 18:19:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE772C385A5;
        Tue,  7 Jun 2022 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625972;
        bh=1FGITE9cSQ7P/XRgO9DxDaKqCo/fkaKYnIe8TByOLMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzEWSo8tqmzDXLAym5m9K5cxvPN1TW5IKSF7U+O3imdY92n094kCIsatTFbCLIfzA
         f9EauPLMWYojKALeMq+jGKv3VyvjldM+SPPckbO4911JTX7TXl8ohrac54t3StAA2i
         3bbZjdMR8MS/V/WHxuimAgL8sPeRssdviFRKBCwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 170/772] net: ipa: ignore endianness if there is no header
Date:   Tue,  7 Jun 2022 18:56:02 +0200
Message-Id: <20220607164954.049841462@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 332ef7c814bdd60f08d0d9013d0e1104798b2d23 ]

If we program an RX endpoint to have no header (header length is 0),
header-related endpoint configuration values are meaningless and are
ignored.

The only case we support that defines a header is QMAP endpoints.
In ipa_endpoint_init_hdr_ext() we set the endianness mask value
unconditionally, but it should not be done if there is no header
(meaning it is not configured for QMAP).

Set the endianness conditionally, and rearrange the logic in that
function slightly to avoid testing the qmap flag twice.

Delete an incorrect comment in ipa_endpoint_init_aggr().

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_endpoint.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index dde55ccae9d7..b421bb1cc23d 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -571,19 +571,23 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
-	val |= HDR_ENDIANNESS_FMASK;		/* big endian */
-
-	/* A QMAP header contains a 6 bit pad field at offset 0.  The RMNet
-	 * driver assumes this field is meaningful in packets it receives,
-	 * and assumes the header's payload length includes that padding.
-	 * The RMNet driver does *not* pad packets it sends, however, so
-	 * the pad field (although 0) should be ignored.
-	 */
-	if (endpoint->data->qmap && !endpoint->toward_ipa) {
-		val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
-		/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
-		val |= HDR_PAYLOAD_LEN_INC_PADDING_FMASK;
-		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
+	if (endpoint->data->qmap) {
+		/* We have a header, so we must specify its endianness */
+		val |= HDR_ENDIANNESS_FMASK;	/* big endian */
+
+		/* A QMAP header contains a 6 bit pad field at offset 0.
+		 * The RMNet driver assumes this field is meaningful in
+		 * packets it receives, and assumes the header's payload
+		 * length includes that padding.  The RMNet driver does
+		 * *not* pad packets it sends, however, so the pad field
+		 * (although 0) should be ignored.
+		 */
+		if (!endpoint->toward_ipa) {
+			val |= HDR_TOTAL_LEN_OR_PAD_VALID_FMASK;
+			/* HDR_TOTAL_LEN_OR_PAD is 0 (pad, not total_len) */
+			val |= HDR_PAYLOAD_LEN_INC_PADDING_FMASK;
+			/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0 */
+		}
 	}
 
 	/* HDR_PAYLOAD_LEN_INC_PADDING is 0 */
@@ -741,8 +745,6 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 			close_eof = endpoint->data->rx.aggr_close_eof;
 			val |= aggr_sw_eof_active_encoded(version, close_eof);
-
-			/* AGGR_HARD_BYTE_LIMIT_ENABLE is 0 */
 		} else {
 			val |= u32_encode_bits(IPA_ENABLE_DEAGGR,
 					       AGGR_EN_FMASK);
-- 
2.35.1



