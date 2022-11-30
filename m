Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299F063DE98
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiK3Sip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiK3Sin (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:38:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B7F9492B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:38:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7DC061D73
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D908BC433C1;
        Wed, 30 Nov 2022 18:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833519;
        bh=nU+ZHSJSa5x5rNW9g2A2vRDAftXxMPaQPzcDIbV/nL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMQO4RXPuxfcmtdc/bzEQ8MXWCPfCpYFJRFB2Td8jHCK/ezDZeRZ4NYNURgtnm6l+
         +WQkFeSUR3CkfoYlgpNFiKCfF6XKTnDt6UULjoImk5//KNVtlde5hZPsih5+NK/gbd
         qfcsXKlPQzRE5r+5uGJ8YFefM8f9nwjy5ueHcnyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Denis Efremov <denis.e.efremov@oracle.com>,
        Guenter Roeck <groeck@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/206] nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION
Date:   Wed, 30 Nov 2022 19:22:58 +0100
Message-Id: <20221130180536.251651748@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Martin Faltesek <mfaltesek@google.com>

[ Upstream commit 0254f31a7df3bb3b90c2d9dd2d4052f7b95eb287 ]

The transaction buffer is allocated by using the size of the packet buf,
and subtracting two which seems intended to remove the two tags which are
not present in the target structure. This calculation leads to under
counting memory because of differences between the packet contents and the
target structure. The aid_len field is a u8 in the packet, but a u32 in
the structure, resulting in at least 3 bytes always being under counted.
Further, the aid data is a variable length field in the packet, but fixed
in the structure, so if this field is less than the max, the difference is
added to the under counting.

To fix, perform validation checks progressively to safely reach the
next field, to determine the size of both buffers and verify both tags.
Once all validation checks pass, allocate the buffer and copy the data.
This eliminates freeing memory on the error path, as validation checks are
moved ahead of memory allocation.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Reviewed-by: Guenter Roeck <groeck@google.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/se.c | 51 +++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index a915cad909b4..04a2cea6d6b6 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -312,6 +312,8 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 	int r = 0;
 	struct device *dev = &ndev->nfc_dev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -325,28 +327,47 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * Description  Tag     Length
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
+		 *
+		 * The key differences are aid storage length is variably sized
+		 * in the packet, but fixed in nfc_evt_transaction, and that
+		 * the aid_len is u8 in the packet, but u32 in the structure,
+		 * and the tags in the packet are not included in
+		 * nfc_evt_transaction.
+		 *
+		 * size(b):  1          1       5-16 1             1           0-255
+		 * offset:   0          1       2    aid_len + 2   aid_len + 3 aid_len + 4
+		 * mem name: aid_tag(M) aid_len aid  params_tag(M) params_len  params
+		 * example:  0x81       5-16    X    0x82          0-255       X
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
-		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
+		if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
-		if (!transaction)
-			return -ENOMEM;
+		aid_len = skb->data[1];
 
-		transaction->aid_len = skb->data[1];
-		memcpy(transaction->aid, &skb->data[2], transaction->aid_len);
+		if (skb->len < aid_len + 4 ||
+		    aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		/* Check next byte is PARAMETERS tag (82) */
-		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
-			devm_kfree(dev, transaction);
+		params_len = skb->data[aid_len + 3];
+
+		/* Verify PARAMETERS tag is (82), and final check that there is
+		 * enough space in the packet to read everything.
+		 */
+		if (skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG ||
+		    skb->len < aid_len + 4 + params_len)
 			return -EPROTO;
-		}
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
-		memcpy(transaction->params, skb->data +
-		       transaction->aid_len + 4, transaction->params_len);
+		transaction = devm_kzalloc(dev, sizeof(*transaction) +
+					   params_len, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
+
+		transaction->aid_len = aid_len;
+		transaction->params_len = params_len;
+
+		memcpy(transaction->aid, &skb->data[2], aid_len);
+		memcpy(transaction->params, &skb->data[aid_len + 4],
+		       params_len);
 
 		r = nfc_se_transaction(ndev->nfc_dev, host, transaction);
 		break;
-- 
2.35.1



