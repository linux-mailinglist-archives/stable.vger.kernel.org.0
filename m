Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD1C579A44
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238606AbiGSMMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238603AbiGSMLp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:11:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8393F43E67;
        Tue, 19 Jul 2022 05:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1556F61720;
        Tue, 19 Jul 2022 12:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75F6C341C6;
        Tue, 19 Jul 2022 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232213;
        bh=2RIulnpy12qPfd61qCeePjC6mrMyrKz5F9JHzlryf7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wdo0ZN1WII16MF4YACpXB/JXwBuoqW3qsEYSH5NeAjZU5JTwbn2ZePeaCUVAji3Om
         ZkaUrwYjlkqGN9pqMrotR5B72qEsSl6/hBrYWfYC7Ln0uJqvH4H0UNJ5aana5MJqsJ
         gvNArF6sGLDKYaQxo4/y/3KOmqJX61JAi7VQ0VQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/71] NFC: nxp-nci: dont print header length mismatch on i2c error
Date:   Tue, 19 Jul 2022 13:54:14 +0200
Message-Id: <20220719114557.283043870@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 9577fc5fdc8b07b891709af6453545db405e24ad ]

Don't print a misleading header length mismatch error if the i2c call
returns an error. Instead just return the error code without any error
message.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/nxp-nci/i2c.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -122,7 +122,9 @@ static int nxp_nci_i2c_fw_read(struct nx
 	skb_put_data(*skb, &header, NXP_NCI_FW_HDR_LEN);
 
 	r = i2c_master_recv(client, skb_put(*skb, frame_len), frame_len);
-	if (r != frame_len) {
+	if (r < 0) {
+		goto fw_read_exit_free_skb;
+	} else if (r != frame_len) {
 		nfc_err(&client->dev,
 			"Invalid frame length: %u (expected %zu)\n",
 			r, frame_len);
@@ -166,7 +168,9 @@ static int nxp_nci_i2c_nci_read(struct n
 		return 0;
 
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
-	if (r != header.plen) {
+	if (r < 0) {
+		goto nci_read_exit_free_skb;
+	} else if (r != header.plen) {
 		nfc_err(&client->dev,
 			"Invalid frame payload length: %u (expected %u)\n",
 			r, header.plen);


