Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77633643238
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiLETZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiLETYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:24:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1140F24F1E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:19:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A260F61309
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B102DC433C1;
        Mon,  5 Dec 2022 19:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267997;
        bh=Y18W67FIBfMK/SnpYKvn+cJ434YESS4MwiJAvNX9Dnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1ieE5j+eMs/re/Qh8N9eak3Lp0Q9ImOTXDouNKPx1sdJ0qlqHpt78+U3WoH3LtHi
         ZOTfpuwcFJlA1fS4QjIm9pDYxy7U/8jDqGPNTsY+9QzlrDrxLjVnNiezwNnZBSD/Ds
         JfFZKclJlY2PaFqSJrLYD8WyL+j/sU9qM0cjoYcE=
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
Subject: [PATCH 4.19 031/105] nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
Date:   Mon,  5 Dec 2022 20:09:03 +0100
Message-Id: <20221205190804.197273047@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

[ Upstream commit c60c152230828825c06e62a8f1ce956d4b659266 ]

The first validation check for EVT_TRANSACTION has two different checks
tied together with logical AND. One is a check for minimum packet length,
and the other is for a valid aid_tag. If either condition is true (fails),
then an error should be triggered. The fix is to change && to ||.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Reviewed-by: Guenter Roeck <groeck@google.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 5d6e7e931bc6..7774a7196bb3 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -338,7 +338,7 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-- 
2.35.1



