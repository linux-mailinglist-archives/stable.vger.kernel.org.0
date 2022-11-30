Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237B163DE97
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiK3Sio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiK3Sim (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:38:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B43197012
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:38:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF143B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293F3C433D7;
        Wed, 30 Nov 2022 18:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833516;
        bh=hnDeOxY67/rhT8mtH1IlQcKERjAyvkPAUoZ1t041Nxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0VOUfG+v3KN1PKCgCbhkfo78RIcpLo2bkqUIYxqXjsuDgKwN1YQ0WSoKbpZGCrsuP
         enKRhwJiFdFJAEkOWMVYKALMPDlULwfeY7baGRmui0CEKqKnCqQnrn7yKanZLMU62h
         MaUs0X/WEs0BYYbsKtnyYKRZyu/HU1/mdzgYPu5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Denis Efremov <denis.e.efremov@oracle.com>,
        Guenter Roeck <groeck@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/206] nfc: st-nci: fix memory leaks in EVT_TRANSACTION
Date:   Wed, 30 Nov 2022 19:22:57 +0100
Message-Id: <20221130180536.226563305@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Faltesek <mfaltesek@google.com>

[ Upstream commit 440f2ae9c9f06e26f5dcea697a53717fc61a318c ]

Error path does not free previously allocated memory. Add devm_kfree() to
the failure path.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Reviewed-by: Guenter Roeck <groeck@google.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/se.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 522b7a128f4c..a915cad909b4 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -339,8 +339,10 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 
 		/* Check next byte is PARAMETERS tag (82) */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
 		memcpy(transaction->params, skb->data +
-- 
2.35.1



