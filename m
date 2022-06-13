Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACED548970
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352048AbiFMMYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355110AbiFMMXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:23:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0033151A;
        Mon, 13 Jun 2022 04:04:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62F67CE1161;
        Mon, 13 Jun 2022 11:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51266C3411C;
        Mon, 13 Jun 2022 11:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118252;
        bh=n3rgOTOCZ/rJGqGmkXaqvBroutI+QFsBaD4ple4Ma+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBpc2Ua9GqDeVW3ljfZHl1WX4pW+yZx48cq5ra0L9DDEeEV7ClxNa7nqmZE/TonSL
         Wbczg5sxlK47C0kq+IR1p7CcUuU4jjRntpYr0JOG45gSFzEDSPzej/fXdooL4dRr5i
         o3Zio8IK9ntQBgCRSV9rUtHymbLPFnhQ0eYPLwdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Faltesek <mfaltesek@google.com>,
        Guenter Roeck <groeck@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 280/287] nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
Date:   Mon, 13 Jun 2022 12:11:44 +0200
Message-Id: <20220613094932.485978890@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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

commit 996419e0594abb311fb958553809f24f38e7abbe upstream.

Error paths do not free previously allocated memory. Add devm_kfree() to
those failure paths.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/st21nfca/se.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -342,22 +342,29 @@ int st21nfca_connectivity_event_received
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


