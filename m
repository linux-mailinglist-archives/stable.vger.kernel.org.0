Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E8C566DBB
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbiGEM05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236909AbiGEMZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33991902E;
        Tue,  5 Jul 2022 05:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71D1BB817D1;
        Tue,  5 Jul 2022 12:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEA0C341C7;
        Tue,  5 Jul 2022 12:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023461;
        bh=jzkFDmSMQEdcCXzeN1VJevw4S6A6EmA4JQDB+UhsubQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsLmreln28ZdQIwwR5OQrzqVG2XBw+61r3CX4fkHBCkA2YP0AMITgU5GT+/DJ3NuT
         wxHTVlEHWDdxFvY4fCPhPJPxAqwNy8nw1u/t3qcRRVFvwxou+3npll4S3LVdK60UMa
         aYewrG+eHkyMLUk315oounDberwzQYI9pT4uRjX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.18 067/102] NFC: nxp-nci: Dont issue a zero length i2c_master_read()
Date:   Tue,  5 Jul 2022 13:58:33 +0200
Message-Id: <20220705115620.308295445@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

commit eddd95b9423946aaacb55cac6a9b2cea8ab944fc upstream.

There are packets which doesn't have a payload. In that case, the second
i2c_master_read() will have a zero length. But because the NFC
controller doesn't have any data left, it will NACK the I2C read and
-ENXIO will be returned. In case there is no payload, just skip the
second i2c master read.

Fixes: 6be88670fc59 ("NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/nxp-nci/i2c.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -162,6 +162,9 @@ static int nxp_nci_i2c_nci_read(struct n
 
 	skb_put_data(*skb, (void *)&header, NCI_CTRL_HDR_SIZE);
 
+	if (!header.plen)
+		return 0;
+
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
 	if (r != header.plen) {
 		nfc_err(&client->dev,


