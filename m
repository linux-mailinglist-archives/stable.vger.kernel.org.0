Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B9053F42A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiFGCz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbiFGCzZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:55:25 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4666E6F482
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 19:55:23 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id a2-20020a923302000000b002d1ad5053feso12907118ilf.17
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 19:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pUBRV97xthCU10usUAjhjvk0rgt9U50UKyWh+gTd9as=;
        b=Q6ifhbdcOe7D/oQGDDeOtKSN2oETyVwndwGg5pf5fuEYvvtmDj0sjV3MsJ64hUsRTh
         Dao0LQ2vRSwCHryBCH1ldFadxtd02tFA0WqPULBIDX6PGx7wbouSEPyC972Qb4CfsVYM
         nK6UPrRLmg2yvJj4DlM2JoJwWn4BqN1DnRHFlXetLuo1ckwViQxckYQCTImGDUYoDWZ6
         hQR/BbL2YQwuFX/ZK9VkwkZceZV6Jf5rg7F+7MUWbOzcl8PTXCY7dAQKGwlKzqrNQ4/V
         aAWrPYb8jdg1jlRRGlZHG8xN4LlYiXwgw6QO0grsczVQvZCs7TEJGJZ6oMj6JJ0dViqG
         HPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pUBRV97xthCU10usUAjhjvk0rgt9U50UKyWh+gTd9as=;
        b=abajDC3nV/toc6hu5ZpA92VpPi4GgzzX+DT/zOikjYNsJgOyV7pslLf5igfhcw9gPf
         OQg6RSWSHPZYTDeJ8HxiBlK7WyUXiNXJ3Qjodirt3Dugk0L8kkYT0OtAIsiNuZCHwch1
         0Bu0uYsHxEwNBdjGSTKXzBt9bMBEEznLMVYAweQlUGpAf3eKRwKz6in0aQI7UC7//Vxr
         FSWhQHTFeRw31mLxH95pxqQBCIWbTFOJncA+53nzw77RTP3xie19QlDLKAHld00aw/If
         IGjUmvpx8HDWwSYUbDCewz9I/FxC/WcuTf6ME3jHbILoWzBtI6qHJenX7RQK6oOcVd5a
         TLJg==
X-Gm-Message-State: AOAM530eFCsKZlt2oKQgWG+gsmM3o3Ewq5YgbOH/XrYELS3b8b7/kLAL
        KBQiJmdqv8puUhwn5K1i2mws/YL29LlQvjw=
X-Google-Smtp-Source: ABdhPJzE9HcMgbUbAMFeYhjXrE4Ti5fRHo21DTEBUcwIYSEAsF1kZ2AJMR7CjIY/RSLJmIOxCr+L/5QMcQ2jrhc=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a6b:8f90:0:b0:669:3ad9:9bd with SMTP id
 r138-20020a6b8f90000000b006693ad909bdmr7157274iod.121.1654570522709; Mon, 06
 Jun 2022 19:55:22 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:55:17 -0500
In-Reply-To: <20220607025519.1670876-1-mfaltesek@google.com>
Message-Id: <20220607025519.1670876-2-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607025519.1670876-1-mfaltesek@google.com>
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

