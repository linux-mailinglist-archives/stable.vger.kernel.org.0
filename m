Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C942B53F40D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbiFGCs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiFGCs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:48:26 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46E9580F2
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 19:48:25 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id j18-20020a056e02219200b002d3aff22b4cso12911314ila.9
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 19:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YsSzLQtvb05lwsRO6DSGoB9POQF3dK+ytO7ed+ufu+c=;
        b=Wb5fPe8s7D4SaBvKi6qT4/Hyxy4EKfHUGxZHGwijIJ3u528FxGB4WYgqzC6mGwSbVM
         Q6wUth89XDCDHlzc1el4z7VGcR3uqgUBEup971sVVsSBsStcnG3Kd2QEX01QRZkv/Z0G
         yXQHWoswn85JMVd/4onoG45ZKymbCpoHEvnjFiezlLZCDF3CE7js7m24edYtG4kyc0zP
         913UPqAA5IcE3TTb4eEsCv6sTZR5qQd4HNrViTmVeRwDqYYjRMp2vPETnmC68ljVCoM2
         XzTwElW/VZjUddyZmYWyKq8iw+gG8P/ER2B4aqv3rV1Ya9VdYmwwhEkhY+B+wrjb+AmA
         jsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YsSzLQtvb05lwsRO6DSGoB9POQF3dK+ytO7ed+ufu+c=;
        b=B9LVyHY/rW7IAMrfuPD2gaXFHj/LstVULNXPUJdHbEpu5IQriOALqSq9hNTxiOJlUD
         vdDYx6JF32GpkeLyR988gmS+ogGRYk6zHI7ll9QP7sx3OEoz6N1gQOuHc2DTvQxT0AX0
         dVxfmCJrXF8dgwzlxVPfuNbjUhdu54DgTSbhc5dy8GtZiS5i98FLwRctsezEjh9TkxjG
         fIUE0ME6N3ZRVtg519vNvxy9VH0T2UFa5jrnMCVnVNBOkLfRcAjX4FputPYrkRFS4uL9
         KYmiTczZZn7i7jn8OkWdkeNXB+B+Td028+ezByfx6fLMllBd+60s/AzAegBr8qDH8mj7
         a+mg==
X-Gm-Message-State: AOAM532HIfXhdioOgfmpOKvavC1kxipTQsLIV8DS64qM3pZ7WIIIYKuT
        G/kT/8uaFnu/Zb/2kTzNli3U+yj0z0+I+qQ=
X-Google-Smtp-Source: ABdhPJyOFbjYYljo5CmsaID0iimX/Eh47LEnS1yqgLVxrL4ce0NtF45l59dUJtU7irZftm1MTaQPCcm5McZkDk8=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6602:27cc:b0:5f0:876e:126b with SMTP
 id l12-20020a05660227cc00b005f0876e126bmr13160479ios.129.1654570105025; Mon,
 06 Jun 2022 19:48:25 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:48:18 -0500
In-Reply-To: <20220607024819.1667984-1-mfaltesek@google.com>
Message-Id: <20220607024819.1667984-3-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607024819.1667984-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH net v3 2/3] nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
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

Error paths do not free previously allocated memory. Add devm_kfree() to
those failure paths.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st21nfca/se.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 9645777f2544..8e1113ce139b 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -326,22 +326,29 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		transaction->aid_len = skb->data[1];
 
 		/* Checking if the length of the AID is valid */
-		if (transaction->aid_len > sizeof(transaction->aid))
+		if (transaction->aid_len > sizeof(transaction->aid)) {
+			devm_kfree(dev, transaction);
 			return -EINVAL;
+		}
 
 		memcpy(transaction->aid, &skb->data[2],
 		       transaction->aid_len);
 
 		/* Check next byte is PARAMETERS tag (82) */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
 
 		/* Total size is allocated (skb->len - 2) minus fixed array members */
-		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+		if (transaction->params_len > ((skb->len - 2) -
+		    sizeof(struct nfc_evt_transaction))) {
+			devm_kfree(dev, transaction);
 			return -EINVAL;
+		}
 
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
-- 
2.36.1.255.ge46751e96f-goog

