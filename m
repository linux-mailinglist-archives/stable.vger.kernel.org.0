Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AF2548FED
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242862AbiFMKcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343494AbiFMKax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:30:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CDD1FA64;
        Mon, 13 Jun 2022 03:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 897BA60AE8;
        Mon, 13 Jun 2022 10:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9637CC34114;
        Mon, 13 Jun 2022 10:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115685;
        bh=Ym2gayHShbwnYrByExXQKnsYA+VbtPJwydeWu4wmwvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WE5EtaXeh658c/TNZX1e/apfELYQ6QWrpNMSl6Vh6AG6lgTAUxrAYjtJhHVb5eLr8
         sGD7QyuTLVDD7Q1C87i7ju0DIf85QQpehUzrzkjVzJghQhqO6xugi/2HMIYPqoPQsL
         PksUgjjWT6KfXNoIGKnGeClF+1qe9wdOiUElL3x8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Faltesek <mfaltesek@google.com>,
        Guenter Roeck <groeck@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 161/167] nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
Date:   Mon, 13 Jun 2022 12:10:35 +0200
Message-Id: <20220613094918.753491371@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
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

commit 77e5fe8f176a525523ae091d6fd0fbb8834c156d upstream.

The first validation check for EVT_TRANSACTION has two different checks
tied together with logical AND. One is a check for minimum packet length,
and the other is for a valid aid_tag. If either condition is true (fails),
then an error should be triggered.  The fix is to change && to ||.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/st21nfca/se.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -320,7 +320,7 @@ int st21nfca_connectivity_event_received
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 


