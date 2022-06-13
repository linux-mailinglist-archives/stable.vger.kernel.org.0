Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7DE548CF0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376425AbiFMNXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376454AbiFMNVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:21:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0123C4B1;
        Mon, 13 Jun 2022 04:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FDAF60F18;
        Mon, 13 Jun 2022 11:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503FAC34114;
        Mon, 13 Jun 2022 11:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119410;
        bh=9T8ut3yJcEj4oJFttwR4tRBTO4q3a4CFu8mJehVbGC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAyUu1jxgKTGuP1Fti6j8xzhly+F1MkrTzJdTU51+wgqYRIO5ZaDqKRpIZuNNnDvk
         dSmm0K9OfVcXr+ThjKfdmsjPkTZ/aqX77pnXjyI2bvj6bvPx6iPTMRTGi5OXiGrcv+
         w30PUxsBzuZSkzh9Vp8S8C3VC2eXKuVbtGHd3Q88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Faltesek <mfaltesek@google.com>,
        Guenter Roeck <groeck@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 229/247] nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION
Date:   Mon, 13 Jun 2022 12:12:11 +0200
Message-Id: <20220613094929.890993023@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Martin Faltesek <mfaltesek@google.com>

commit f2e19b36593caed4c977c2f55aeba7408aeb2132 upstream.

The transaction buffer is allocated by using the size of the packet buf,
and subtracting two which seem intended to remove the two tags which are
not present in the target structure. This calculation leads to under
counting memory because of differences between the packet contents and the
target structure. The aid_len field is a u8 in the packet, but a u32 in
the structure, resulting in at least 3 bytes always being under counted.
Further, the aid data is a variable length field in the packet, but fixed
in the structure, so if this field is less than the max, the difference is
added to the under counting.

The last validation check for transaction->params_len is also incorrect
since it employs the same accounting error.

To fix, perform validation checks progressively to safely reach the
next field, to determine the size of both buffers and verify both tags.
Once all validation checks pass, allocate the buffer and copy the data.
This eliminates freeing memory on the error path, as those checks are
moved ahead of memory allocation.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/st21nfca/se.c |   62 +++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -304,6 +304,8 @@ int st21nfca_connectivity_event_received
 	int r = 0;
 	struct device *dev = &hdev->ndev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -312,50 +314,48 @@ int st21nfca_connectivity_event_received
 		r = nfc_se_connectivity(hdev->ndev, host);
 	break;
 	case ST21NFCA_EVT_TRANSACTION:
-		/*
-		 * According to specification etsi 102 622
+		/* According to specification etsi 102 622
 		 * 11.2.2.4 EVT_TRANSACTION Table 52
 		 * Description	Tag	Length
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
+		 *
+		 * The key differences are aid storage length is variably sized
+		 * in the packet, but fixed in nfc_evt_transaction, and that the aid_len
+		 * is u8 in the packet, but u32 in the structure, and the tags in
+		 * the packet are not included in nfc_evt_transaction.
+		 *
+		 * size in bytes: 1          1       5-16 1             1           0-255
+		 * offset:        0          1       2    aid_len + 2   aid_len + 3 aid_len + 4
+		 * member name:   aid_tag(M) aid_len aid  params_tag(M) params_len  params
+		 * example:       0x81       5-16    X    0x82 0-255    X
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
-		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
+		if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
-		if (!transaction)
-			return -ENOMEM;
+		aid_len = skb->data[1];
+
+		if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		transaction->aid_len = skb->data[1];
+		params_len = skb->data[aid_len + 3];
 
-		/* Checking if the length of the AID is valid */
-		if (transaction->aid_len > sizeof(transaction->aid)) {
-			devm_kfree(dev, transaction);
-			return -EINVAL;
-		}
-
-		memcpy(transaction->aid, &skb->data[2],
-		       transaction->aid_len);
-
-		/* Check next byte is PARAMETERS tag (82) */
-		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
-			devm_kfree(dev, transaction);
+		/* Verify PARAMETERS tag is (82), and final check that there is enough
+		 * space in the packet to read everything.
+		 */
+		if ((skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG) ||
+		    (skb->len < aid_len + 4 + params_len))
 			return -EPROTO;
-		}
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
+		transaction = devm_kzalloc(dev, sizeof(*transaction) + params_len, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
-		/* Total size is allocated (skb->len - 2) minus fixed array members */
-		if (transaction->params_len > ((skb->len - 2) -
-		    sizeof(struct nfc_evt_transaction))) {
-			devm_kfree(dev, transaction);
-			return -EINVAL;
-		}
+		transaction->aid_len = aid_len;
+		transaction->params_len = params_len;
 
-		memcpy(transaction->params, skb->data +
-		       transaction->aid_len + 4, transaction->params_len);
+		memcpy(transaction->aid, &skb->data[2], aid_len);
+		memcpy(transaction->params, &skb->data[aid_len + 4], params_len);
 
 		r = nfc_se_transaction(hdev->ndev, host, transaction);
 	break;


