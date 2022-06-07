Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089F153F3FD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 04:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbiFGClm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 22:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiFGClm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 22:41:42 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F28C0477
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 19:41:41 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id e4-20020a056e020b2400b002d5509de6f3so1258117ilu.6
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 19:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pUBRV97xthCU10usUAjhjvk0rgt9U50UKyWh+gTd9as=;
        b=Dwo9rGUyrtrJqWbHf1aXycd1i5qlTGw23Ff3pPIf56mD0PDConQSxRPQZrFYDCrxrm
         Z7WEnhJHlmYI42ROJuvMMY70BB9cYO7WtDXNMLByVns/Y999P9+WH6spKQWUKWMJZ1jF
         yOLNYaIxkcg40adCfSvK7ZyhbPXJrdSTCxm3eVV2Vhk5Tv+uRSENkb/qmJZZDNAJC5UC
         hcLY2LR7LSJ4f9bMU3hfAa+kcSm0MmxEzyLrFCBs4Pgub/23ufnxaPNcHqPGXyGGL3Ao
         lgwJnDCNxWzfpf09IrYgdJbwDJN19FZOFpuPnf2ZXeqfkUMmvqz0X6io3fKcGCk6U8Ce
         cfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pUBRV97xthCU10usUAjhjvk0rgt9U50UKyWh+gTd9as=;
        b=pCivas9dFfw9xf65JKKe+fGjN51Go7gx1OBvkNZepMbHRTO/p7mkPolvPqyMpoM6+u
         JkGpH4UXFmD3QgX+WB5bpwBxSp0GZ7k+gWrTOIqU95Xwvoi+PYGE4GKp4oVnMxRbj/gk
         /WUZ6z6GBVwv4pxuxj7uvPPWD5bSHklpzJ8mzAalD5oFOW2aqjfDaOYcX2YAcAORZE3L
         IbMQkb0HiebeGlHn3WEKpjP0iZdnP/w/dDWJoFW7HCEI7+u0+WWt8HgYQt9gXVBlr/ms
         p5l6+6mvWoponiRvqRd0+yo0EYSAKdsyoWHLD4U07fuTOIHR3jcUIosML58WmRGu0YtN
         WHGA==
X-Gm-Message-State: AOAM533bLMyBOTTm9pII2j5cBpIxYK3TIGqtfDYYkVzKTNUFDtYN+dRa
        szkRNIOgGyiy4viqPF6eslfIGeVPx+OCqQM=
X-Google-Smtp-Source: ABdhPJxtFBxYQjhnQmwigppwRSft0i6adwrkVaHDucdtyfIbE9fphCt5WETtSYbWY7Gvj7HmI1Uc3L9YLJSCiOQ=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6638:1446:b0:32e:a9c4:10c3 with SMTP
 id l6-20020a056638144600b0032ea9c410c3mr14464981jad.280.1654569700648; Mon,
 06 Jun 2022 19:41:40 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:41:15 -0500
In-Reply-To: <20220607024117.1344044-1-mfaltesek@google.com>
Message-Id: <20220607024117.1344044-2-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607024117.1344044-1-mfaltesek@google.com>
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

