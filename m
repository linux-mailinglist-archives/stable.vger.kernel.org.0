Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC82E53F40E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiFGCs2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiFGCs1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:48:27 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA8457B23
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 19:48:26 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30c2aa26ebfso137067397b3.4
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 19:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h0VUAZ+/P4d+rcM7OhdmQUwR8fhTt/+FRpwZ4ssNaoY=;
        b=HVRQDav37C0/EpiFBIjtfdk5RzwTZ1x+BD5uv9GLqd4FYWeyCqBB8hldZoW0/uTsr7
         QkhhswmGH3Mn7aMaVG7knCUIjbknfmEcFerRWG8/kZ86bE0ScnzKSmivE2lSqkY1dIoG
         7nc3OXjXhJDE03TdKuojjE95n0Y83br7jqR7a23nkatbp9myQlomge2L/eHN9yByyv9+
         g/ofqnan1I4j1JE+QaTYp7NiE1+ZsibFfWOE9QWnhp1W18OLTn1VYd030Zn+aKFWkhQW
         xnlPuFaX2NbzS/3PhSWWWGgCD8XUFGQqSSrZG1DO7uBsT1FF+Bhz120bv9LV/s3aCYTp
         alPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h0VUAZ+/P4d+rcM7OhdmQUwR8fhTt/+FRpwZ4ssNaoY=;
        b=iPY+1SsHeCcjuuMicUQOpLtvgcLKAyJD6PCIMTcf0QpmwgWmqDITSlC7NnCzlMNKIc
         NYvVrVE/xU6jCVfmXtY6JPRj38tPIFMcmLQkUSPy15UHkp5o8GN14KHO+SFxdvyT7J+w
         Ubs1eQB7/cyBCQkMml9iHHW0DhdT/7yRTW2XM2W2iHMjjUk92MYOswLlX0mwE5+34HI8
         8JMS7PywOXBuI5QYH3Sg6aIeLepEC+vBf7wCBZGSWacxqGKNQhZCt6PS2s24WVoF3yc+
         ntEcNzDqYq4H1HS/V62zzoTfnyWS1R463rrPKSgILlrLXvsV4yxIeyoN1CEGrpi0AJpe
         Dw1Q==
X-Gm-Message-State: AOAM530BGdpIUhh2Z6pTIE+R+hs89ADGXNTvMB93iz6FJvQLEfxCbItw
        nBVeQK7iP3UeDlJddtJ7jgVv2Y9evwm1KD0=
X-Google-Smtp-Source: ABdhPJxT9slbXdAUDbnBt8zYZuywY7svOECuH6eQcfhPMgIw+8nSmKgbigvbh9fE29zFXOIaukZ/W82ClhJETpI=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a25:2c56:0:b0:65d:3766:7dc3 with SMTP id
 s83-20020a252c56000000b0065d37667dc3mr27704876ybs.68.1654570106064; Mon, 06
 Jun 2022 19:48:26 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:48:19 -0500
In-Reply-To: <20220607024819.1667984-1-mfaltesek@google.com>
Message-Id: <20220607024819.1667984-4-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607024819.1667984-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH net v3 3/3] nfc: st21nfca: fix incorrect sizing calculations
 in EVT_TRANSACTION
From:   Martin Faltesek <mfaltesek@google.com>
To:     martin.faltesek@gmail.com
Cc:     Martin Faltesek <mfaltesek@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/nfc/st21nfca/se.c | 60 +++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 8e1113ce139b..df8d27cf2956 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -300,6 +300,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 	int r = 0;
 	struct device *dev = &hdev->ndev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -308,50 +310,48 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
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
-
-		transaction->aid_len = skb->data[1];
+		aid_len = skb->data[1];
 
-		/* Checking if the length of the AID is valid */
-		if (transaction->aid_len > sizeof(transaction->aid)) {
-			devm_kfree(dev, transaction);
-			return -EINVAL;
-		}
+		if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		memcpy(transaction->aid, &skb->data[2],
-		       transaction->aid_len);
+		params_len = skb->data[aid_len + 3];
 
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
-- 
2.36.1.255.ge46751e96f-goog

