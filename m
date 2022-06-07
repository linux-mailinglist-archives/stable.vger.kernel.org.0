Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863B553F435
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbiFGC6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiFGC55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:57:57 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A20A6668E
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 19:57:56 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id e2-20020a5ede02000000b006695f3d239aso1967744iok.17
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 19:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YsSzLQtvb05lwsRO6DSGoB9POQF3dK+ytO7ed+ufu+c=;
        b=oBDmeGaAK93GYV5EceayojbLgwe6k4lFS6EEqXVRnI3sXC9fgb+tqwd/+7MxRELrLw
         DbVqpVCrcdNWRTMCQKIYWvo+lpi8ChCf4OUSpm/YI15ZTi2ImmBjQ+w/QBz5oWy/vZG7
         4FauwRND0bL7fVP1qOYG+AcoAtvgt1dZSas5i3zHsdsP8j/yL6zi2SxJPRTvt+gMGjxm
         jcSORNYVXuo9ItCj77qKB0e9AlNWWNSUzCWo90ct0dxMGPZx2suDto1vSJJ3LRlGvIVB
         9eiU3WAxfR7PQdddS8L1mxkcP4dZVaU9HTqC1jlv8qL846S74REZwQn9oUOIiQWDL5fG
         soJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YsSzLQtvb05lwsRO6DSGoB9POQF3dK+ytO7ed+ufu+c=;
        b=6h86lOoCd8azuIpEqY9Pm9NW2LSB/PlW3MBPVdjC1UgrylN0zt9yaOumENnlvEtWeV
         5Aq4NIaivrdH6hLGrezy10Q6T8IQR6kdAYqb45dU55laBGMqofmJsQ240f+JzGPD692F
         Z4WOuqT5ubWrG3gvQct40IvLj/DftPSW9tEYu6RmocUP9shPHp2pZkJEDA5rpuPp1g0R
         +10yglJK68YtMntzdDKdZZ8iw9giI1x0rvXvjURds3NxTJ9GHHoLoe/Gg4ftG7WGpV+z
         f2jbwNn8g1DFxWyhCgu1ykExf4y1QZv45e9KUEvnLRDlWCsh3Zpc7RqbQE29jk5NqtN6
         MU8w==
X-Gm-Message-State: AOAM533fDqRG3KEW5YQEv/Fl5R8F1uINM+8AP0kr4m2d8aN3MOsEyK1O
        iCw+iW81IYI2UwmnAC4v9K7RzLHSemN4lAM=
X-Google-Smtp-Source: ABdhPJzRzqse/ZLNbITnpbyv8MFI/BXBQjAR+/xiyGBU00cL5+yS5zNk++8NEttPIOqDvuD8ww7xXcZrvE3La2g=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6e02:1788:b0:2d1:ed04:88df with SMTP
 id y8-20020a056e02178800b002d1ed0488dfmr16539567ilu.226.1654570676087; Mon,
 06 Jun 2022 19:57:56 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:57:28 -0500
In-Reply-To: <20220607025729.1673212-1-mfaltesek@google.com>
Message-Id: <20220607025729.1673212-3-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607025729.1673212-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH net v3 2/3] nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
From:   Martin Faltesek <mfaltesek@google.com>
To:     kuba@kernel.org, krzysztof.kozlowski@linaro.org
Cc:     christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        mfaltesek@google.com, martin.faltesek@gmail.com,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        sameo@linux.intel.com, wklin@google.com, theflamefire89@gmail.com,
        stable@vger.kernel.org
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

