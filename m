Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB6D566AF5
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiGEMDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbiGEMCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C28E17AAA;
        Tue,  5 Jul 2022 05:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADBB561830;
        Tue,  5 Jul 2022 12:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B07C341C7;
        Tue,  5 Jul 2022 12:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022560;
        bh=IXuzRz5oVHoJYP8Vq7RjV2ZsHhZp2usTsI+g98gYu2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fjeo3Y9A+jJ6YI9lZusj+SJK+7zV7kmzJID2znPyRgcWjlKdZvLea/d/wjOmT15aF
         rw+yF5Ypfdk0pSGqJZBawKgfk53dmQCNAWBNYHTlSHHIS5DVtwXDqvz65tZeHEnc6+
         BIWyWO1+7+AshWx+IEjNGej+kl2mg3lx6aOeACvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 20/33] NFC: nxp-nci: Dont issue a zero length i2c_master_read()
Date:   Tue,  5 Jul 2022 13:58:12 +0200
Message-Id: <20220705115607.304839322@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
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
@@ -178,6 +178,9 @@ static int nxp_nci_i2c_nci_read(struct n
 
 	skb_put_data(*skb, (void *)&header, NCI_CTRL_HDR_SIZE);
 
+	if (!header.plen)
+		return 0;
+
 	r = i2c_master_recv(client, skb_put(*skb, header.plen), header.plen);
 	if (r != header.plen) {
 		nfc_err(&client->dev,


