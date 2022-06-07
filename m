Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0288353F3FE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbiFGClo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiFGCln (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:41:43 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC460C0477
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 19:41:42 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id c7-20020a6bec07000000b0066942b01338so3051552ioh.10
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 19:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YsSzLQtvb05lwsRO6DSGoB9POQF3dK+ytO7ed+ufu+c=;
        b=WdnA6UAgApjfFPzxzwdpWa2URbqW1jXR9grpwuAv8ELRZ+Kg8N68zRVX8LxlKFBBFc
         nZWlB1r+dShsSyRkGxHd0c4sU7ui6WBnYl2xQHPGGwuLZCKWTmUxYqZRDmBLNo5tMjI3
         Ip4lzARFEmxg9kyrps7cXCytKw0l1OYM3LR6QQaEKl+Kq5Q8Yq9VfJvwSZczcCcKDSFP
         dbyhDHox5pSKAI4BZ/XDlEZ4Rb2CtOUzscTiX0+K3wUR4HgF4d6IgQrAEpKOcNGgjQNJ
         fOWnMDXTq1lEoAfW8vFdQpj45+gFPAs75PcHdSC/7JpJP/QK74yFgm3PQsQTRLYMiikf
         19yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YsSzLQtvb05lwsRO6DSGoB9POQF3dK+ytO7ed+ufu+c=;
        b=4iunld5bW4QWRPvJ65N4ukSsf4h9lqmx/auMdP/c2V4CDrN8N6E27qQth/oByAL+Ay
         l3TkgmuHahRZKHKlxGtMD5nk2pa/4oK8iXUtdrA1JaK+7V3+NX3Uw5HmB3GXa7JC0Vi0
         84MZRpwKrAd9iesPUDzVxvcb6eBN63MstswpF9iyv6dAGpuK0vc+P8jR3zftX60U5/Ae
         X8opdahPjghb9tAv2fp+qf7TgqpLVd7gqagPHjLl6RkRukpGAJx2b21WQ6jMg2jYr8Kc
         +m8T3h681Ka4HoLgOrRCy5TE1KaEIOncClNcAp3EbvbIjkxkzRzB6paaMxkHgHpfla9D
         Bcsg==
X-Gm-Message-State: AOAM532aHhv3+tDpBBkAKLz23T2psQMCHQTPqyfmVkxvemb+1aRE6Rsf
        9WoyNj829WI9vW9JL5ND716vkszkT/fZcgw=
X-Google-Smtp-Source: ABdhPJzpM0pEi5hybOzrYMYnJRQ7PLup0k9GfLP+X5rG7CEYLl8HE0At6sT6j3G2EuoeODsLdnIVoqpvFATH3i4=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6602:2a42:b0:65a:eb90:2a12 with SMTP
 id k2-20020a0566022a4200b0065aeb902a12mr12681901iov.73.1654569702103; Mon, 06
 Jun 2022 19:41:42 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:41:16 -0500
In-Reply-To: <20220607024117.1344044-1-mfaltesek@google.com>
Message-Id: <20220607024117.1344044-3-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607024117.1344044-1-mfaltesek@google.com>
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

