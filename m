Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E544643569
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 21:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbiLEUPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 15:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiLEUPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 15:15:47 -0500
Received: from mailfilter05-out40.webhostingserver.nl (mailfilter05-out40.webhostingserver.nl [195.211.74.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE55C27FD9
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 12:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
         subject:cc:to:from:from;
        bh=dr7UwJp1aWEnCa4twHC7nPXuky/8LKPXZIlvLw50gwY=;
        b=FiilAHVFYovMsp/DEEMDbX1gG3gpcz315Q+nUTOTDXIpWcAtxGcD8sZLL9ktJL4PIRCsErdW7wg3g
         XHkTxxmyHesDqCOW1RY435eaIdzPyrbjZ82N2dIRJ9xukVQFf2X78WN9HG1denjgG27VBTQA/xzze8
         W1Put4fi07ZFyhsMChyyIEgy/dNqFKalQ5Rd2FGXs47/+NtY/wypFUalv0719UFnWxmPzTGC5mlsIU
         c8WiWhFZbyIWoI/Izi9qpejhBBJ3QLUKW7ROanWuvv3eZC26eiKhBH/fzet+u+V+69WWLpJkGfL0tY
         vEIPbfGrQSXT4FPGd+3NclRd62C5szQ==
X-Halon-ID: 985df67c-74d9-11ed-9686-001a4a4cb933
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter05.webhostingserver.nl (Halon) with ESMTPSA
        id 985df67c-74d9-11ed-9686-001a4a4cb933;
        Mon, 05 Dec 2022 21:15:43 +0100 (CET)
Received: from 2a02-a466-68ed-1-f633-1bb8-92a6-ba5d.fixed6.kpn.net ([2a02:a466:68ed:1:f633:1bb8:92a6:ba5d] helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.96)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1p2HsM-001b54-2t;
        Mon, 05 Dec 2022 21:15:42 +0100
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
        Ferry Toth <ftoth@exalondelft.nl>, stable@vger.kernel.org
Subject: [PATCH v5 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
Date:   Mon,  5 Dec 2022 21:15:26 +0100
Message-Id: <20221205201527.13525-2-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221205201527.13525-1-ftoth@exalondelft.nl>
References: <20221205201527.13525-1-ftoth@exalondelft.nl>
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

Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
if extcon is present") Dual Role support on Intel Merrifield platform
broke due to rearranging the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() on the first test write failing
with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
DT when the test write fails and returns 0 in that case, even if DT does not
provide the phy. As a result usb probe completes without phy.

Make ulpi_read_id() return -ETIMEDOUT to its user if the first test write
fails. The user should then handle it appropriately. A follow up patch
will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable@vger.kernel.org
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

