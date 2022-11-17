Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791EA62E62F
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 21:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239352AbiKQUze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 15:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239207AbiKQUzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 15:55:33 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Nov 2022 12:55:32 PST
Received: from mailfilter03-out40.webhostingserver.nl (mailfilter03-out40.webhostingserver.nl [195.211.72.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C6A218D
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 12:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
         subject:cc:to:from:from;
        bh=Pc/8xsignvpb7hB1IAB5J46UWvZn4zJkaYhKUZ3kXYA=;
        b=fBkyeFIAvIHuBpWxkopNlU0s0jmiZ0nClgzFjBf1U5Fg+FSegUv0B1lwH5D5rhFJmJk0c7k+bmq9V
         WrmICmEuf/aFU8sJsIuyYL/zaYYMrlYtFI25aZrSaKDvSNsBgLvhJPsuuh6Tqs0ADbuVuELh8ui/Im
         ti8K0oyPVy0rlZdeNmbbE93NUgmuHXeARwwsRQVjHrLqd0wA7O52hrKtbmqsWdEd7hyTufvjTNx4He
         d5LzxcYaBLBJah6ROmxCg8ZcUPAVyMto4aazd+nNs/fhQMwsJqarD1tpPPiRz5y6qpGvB6SN+FJqKW
         ypUTLzKeq2RoviHALqpzpXBdLYgpwDA==
X-Halon-ID: ccbc479a-66b9-11ed-af3a-001a4a4cb9a5
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter03.webhostingserver.nl (Halon) with ESMTPSA
        id ccbc479a-66b9-11ed-af3a-001a4a4cb9a5;
        Thu, 17 Nov 2022 21:52:50 +0100 (CET)
Received: from 2a02-a466-68ed-1-6f6f-9a68-8ab0-3e9e.fixed6.kpn.net ([2a02:a466:68ed:1:6f6f:9a68:8ab0:3e9e] helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.96)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1ovltz-0054mk-1t;
        Thu, 17 Nov 2022 21:54:27 +0100
From:   Ferry Toth <ftoth@exalondelft.nl>
To:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org, Ferry Toth <ftoth@exalondelft.nl>
Subject: [PATCH v3 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
Date:   Thu, 17 Nov 2022 21:54:10 +0100
Message-Id: <20221117205411.11489-2-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221117205411.11489-1-ftoth@exalondelft.nl>
References: <20221117205411.11489-1-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 0f010171
Dual Role support on Intel Merrifield platform broke due to rearranging
the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() on the first test write failing
with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
DT when the test write fails and returns 0 in that case even if DT does not
provide the phy. As a result usb probe completes without phy.

Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
---
 drivers/usb/common/ulpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index d7c8461976ce..60e8174686a1 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -207,7 +207,7 @@ static int ulpi_read_id(struct ulpi *ulpi)
 	/* Test the interface */
 	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	ret = ulpi_read(ulpi, ULPI_SCRATCH);
 	if (ret < 0)
-- 
2.37.2

