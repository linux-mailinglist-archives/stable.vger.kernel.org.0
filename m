Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C61B53F42B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiFGCz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbiFGCz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:55:26 -0400
Received: from mail-oa1-x49.google.com (mail-oa1-x49.google.com [IPv6:2001:4860:4864:20::49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3D572219
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 19:55:24 -0700 (PDT)
Received: by mail-oa1-x49.google.com with SMTP id 586e51a60fabf-f1ca0bd7d7so9475026fac.22
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 19:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YsSzLQtvb05lwsRO6DSGoB9POQF3dK+ytO7ed+ufu+c=;
        b=fL1BN0CQ/xmJL8anz3xkkIwevwOtC80uZ/DBoZUAGbC65svTyiWFej5tXb1T/Tm5Ir
         EfhEIrCyHNirEiPYsXNBFrDsDqOUf8WqsnWSmpv/TqsPM0NM6vA4Ybhp5Fwd6Aq41Pzt
         xRyVeVt5e71/tzYjNUvuHmcEejzUlnP1Zx51ihjZEjFynz0CAqxzCaJdvdzyLW2POV8S
         a7YnWnLGiisJ2jhRUpyaQZxEhbDl6DMlOMF7tePUjLFQHCycHTfVAlaT5byT5JKxw2Rb
         Y7huATuJz+fLh38e/Zk37y/5x1jLYnApNPKaoSdARixSyflIVxMVKVeegqYhUqbsrdiN
         D1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YsSzLQtvb05lwsRO6DSGoB9POQF3dK+ytO7ed+ufu+c=;
        b=UNeeCZ3jSVWhcUR7VENScIiUhhKrCItuxFhqKp86i/s9FIGjrNRF+ziJL8aGIfvXSx
         Ux62j0DZKz0uHMAJLnxdovHuKF5QfHp66LfdSxTehyYe9+sfjom/83txHM3QgyByefbJ
         BxWkekoSZ6KcAmDexzqveJvmwL4XC/Ij4SY05U+Vb2kUbwjHc/v+edIFewEq9pegI/zd
         21gnthifHJvHLnDtjqJILSHkmxT4aU47Psa9gn4HjHEJu7ed1h/sVSOrsULmdq+AgEcn
         /cc8jI5ecKbewGPtrWHp21CvLXjS/Vspkc6rKjpuF11THTY6G3Lm7PvlNPTkFrEJjGQa
         c5ZA==
X-Gm-Message-State: AOAM532eFR1o2zNckxDDh7nyGRhhXh7AsgqP9KPYI5Ar3+d4V+Y7qwvs
        upfei6xmz3k62azsxV565358v+QqKTgAaOI=
X-Google-Smtp-Source: ABdhPJxTMtJt2GfkbE3b/4LBFTBIR/mmk+BbxW6gTsD/4qcgKv43e1sAyeV0NrKjXebuBtUBi+E453ME4qcjF9M=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6808:1311:b0:32e:70f1:8b28 with SMTP
 id y17-20020a056808131100b0032e70f18b28mr8489242oiv.220.1654570523841; Mon,
 06 Jun 2022 19:55:23 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:55:18 -0500
In-Reply-To: <20220607025519.1670876-1-mfaltesek@google.com>
Message-Id: <20220607025519.1670876-3-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607025519.1670876-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH net v3 2/3] nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
From:   Martin Faltesek <mfaltesek@google.com>
To:     martin.faltesek@gmail.com
Cc:     Martin Faltesek <mfaltesek@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

