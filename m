Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B18F4E7629
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240834AbiCYPL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355420AbiCYPLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:11:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79405B3C6;
        Fri, 25 Mar 2022 08:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD3C161BF5;
        Fri, 25 Mar 2022 15:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB822C340EE;
        Fri, 25 Mar 2022 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648220894;
        bh=kbWc4PF1sMyfwaJlFZACIvpVjhFNerHYm39HxtmOxUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cx1y+EoK1msFp7RpJ3gfBhn/T5Qb6SaJqETWaQDWa1asacbcyhbPbjGuX1ZwmG7t0
         CbF8fq7LtMff/GjlJADVd3LSzJF0eSOZ66CM4T0QjBDWpPMojCcWzU3+O/4nw29D35
         IbSAc0UbZUcNZsJVlz28T1FzWEd48ij0R0izpKq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordy Zomer <jordy@pwning.systems>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Denis Efremov <denis.e.efremov@oracle.com>
Subject: [PATCH 5.4 03/29] nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION
Date:   Fri, 25 Mar 2022 16:04:43 +0100
Message-Id: <20220325150418.685680338@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
References: <20220325150418.585286754@linuxfoundation.org>
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

From: Jordy Zomer <jordy@pwning.systems>

commit 4fbcc1a4cb20fe26ad0225679c536c80f1648221 upstream.

It appears that there are some buffer overflows in EVT_TRANSACTION.
This happens because the length parameters that are passed to memcpy
come directly from skb->data and are not guarded in any way.

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/st21nfca/se.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -321,6 +321,11 @@ int st21nfca_connectivity_event_received
 			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
+
+		/* Checking if the length of the AID is valid */
+		if (transaction->aid_len > sizeof(transaction->aid))
+			return -EINVAL;
+
 		memcpy(transaction->aid, &skb->data[2],
 		       transaction->aid_len);
 
@@ -330,6 +335,11 @@ int st21nfca_connectivity_event_received
 			return -EPROTO;
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
+
+		/* Total size is allocated (skb->len - 2) minus fixed array members */
+		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+			return -EINVAL;
+
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
 


