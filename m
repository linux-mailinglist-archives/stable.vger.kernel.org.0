Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C42D53F40C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbiFGCs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbiFGCs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:48:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DFC57B23
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 19:48:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n201-20020a2540d2000000b0065cbae85d67so13998746yba.11
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 19:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pUBRV97xthCU10usUAjhjvk0rgt9U50UKyWh+gTd9as=;
        b=CZDDoq7takdJnIzEqQhXBVK3WEQEP14bQkOxQeh9vDVrnLCJwit927Bb2WXgYUMaFy
         B3Alc7HiUHiS+fCXBD01wsv61O+bvNKYFl/DhTEzt9YBbeC7q035IhrwYsAzbq5YaB4p
         Tap3eYq6RmR0WH61GZlqXR+RdBflyhiNqTDJRK7nUfSa+gO/JOmuzxSI7/OPkRDmxwQY
         Q5B5bWVJyjuG5TrdC+q6yCBUNtKYV1nJyc+414ktdITvreDbr9602tHjmX/5y5VRPo4j
         iVqT4K5AJc6O3qpTpNoSGQSq3M63LBXJFjfeiO0AOKapPdBuxEG0cj1hNFm4j7XOdoQU
         e7VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pUBRV97xthCU10usUAjhjvk0rgt9U50UKyWh+gTd9as=;
        b=vA8vwg6FBr4+8N7sILTF0b+eVrrlkrlz5c9SA1JDNK9o55SPqrfIHgkT6ZJK2t5nOE
         +TQlS78aMYJLCZ9PFYF36G6zH/XkMvQt4xn3JvGbYfLCXWuj3mKrENqE0b7JF7yJTh2e
         /uTNwN2A3/ULFdxJBtc+SBcMZRVXX3aDBCVm98R8rCRXWrc82++TWrhyU++Wc1b+w++g
         gThX0gkranTanFebKrnwDOuO3MPn0PfLxsiecWhGUQfhVpMysRvJUZ3nazvKrsPcFj+7
         DaLQ6iXZI9+1ghasJLQnKiO9Hw++JP31lESFhf8IP57GGGHapxemITqtdUHMJGVzn5w8
         yEZA==
X-Gm-Message-State: AOAM530w+kj5wNT7woqrZWKhCrwZXDTgy97FHSo4JZ72dgZKvGHsIIJK
        yufEa+RBfBcx1KW4DCF5k9+6/glnmCI5z3o=
X-Google-Smtp-Source: ABdhPJxWSTC+5o3T9Mw6tUGuBwQKE7IAXmTOO/AcSphHC5n4z0gqFuxkSBNJZGNqovi0B0aVL52u8v6nDtifBK0=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a25:c003:0:b0:64d:6291:a6b with SMTP id
 c3-20020a25c003000000b0064d62910a6bmr26902380ybf.19.1654570103730; Mon, 06
 Jun 2022 19:48:23 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:48:17 -0500
In-Reply-To: <20220607024819.1667984-1-mfaltesek@google.com>
Message-Id: <20220607024819.1667984-2-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607024819.1667984-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH net v3 1/3] nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
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

The first validation check for EVT_TRANSACTION has two different checks
tied together with logical AND. One is a check for minimum packet length,
and the other is for a valid aid_tag. If either condition is true (fails),
then an error should be triggered.  The fix is to change && to ||.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st21nfca/se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 7e213f8ddc98..9645777f2544 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -315,7 +315,7 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-- 
2.36.1.255.ge46751e96f-goog

