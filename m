Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92E86314F0
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 16:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKTPhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 10:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiKTPhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 10:37:33 -0500
Received: from mailfilter05-out40.webhostingserver.nl (mailfilter05-out40.webhostingserver.nl [195.211.74.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1B625FD
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 07:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=exalondelft.nl; s=whs1;
        h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
         subject:cc:to:from:from;
        bh=pL3v1LXTDSwlVQKeW2cdKoypwqG73N7k6gDtgGMdYn0=;
        b=fykCvFRdSymPbE7P4/0KI1oXYDb0vKv3BSSHwC5nCsm4tkAj1iNWhsuZjswgBU2b2BXR8+Fyox9Vv
         Zxll944e+9uco78mCsfQjRFyi7rJ7e/D3Du6bSYJuvk3hSiThSIdV0FLWYjOU7agxCYh7UraQARJ9n
         oFKWov1IvO/U98EIrFo7w4VXmRx6PR1E5QLdielzxlBzn90JZs7lVppmttEVCaanu6b+Z+//IyLGzV
         iszTq5dL4jJD7s8rDMfDqrMZ5lwtRLDb36m3oWCL3JkZxNruxbNy1kj3Dex0J9yzNgvtVawtz49fS8
         2v435afgopxECdTXJA3KtpUGFjgiS6w==
X-Halon-ID: 3bab168f-68e9-11ed-9686-001a4a4cb933
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
        by mailfilter05.webhostingserver.nl (Halon) with ESMTPSA
        id 3bab168f-68e9-11ed-9686-001a4a4cb933;
        Sun, 20 Nov 2022 16:37:25 +0100 (CET)
Received: from 2a02-a466-68ed-1-a813-1b80-f6b2-b786.fixed6.kpn.net ([2a02:a466:68ed:1:a813:1b80:f6b2:b786] helo=delfion.fritz.box)
        by s198.webhostingserver.nl with esmtpa (Exim 4.96)
        (envelope-from <ftoth@exalondelft.nl>)
        id 1owmNp-004Y9S-1U;
        Sun, 20 Nov 2022 16:37:25 +0100
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
Subject: [PATCH v4 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id timeout
Date:   Sun, 20 Nov 2022 16:37:03 +0100
Message-Id: <20221120153704.9090-2-ftoth@exalondelft.nl>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221120153704.9090-1-ftoth@exalondelft.nl>
References: <20221120153704.9090-1-ftoth@exalondelft.nl>
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

Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")
Dual Role support on Intel Merrifield platform broke due to rearranging
the call to dwc3_get_extcon().

It appears to be caused by ulpi_read_id() on the first test write failing
with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
DT when the test write fails and returns 0 in that case, even if DT does not
provide the phy. As a result usb probe completes without phy.

On Intel Merrifield the issue is reproducible but difficult to find the
root cause. Using an ordinary kernel and rootfs with buildroot ulpi_read_id()
succeeds. As soon as adding ftrace / bootconfig to find out why,
ulpi_read_id() fails and we can't analyze the flow. Using another rootfs
ulpi_read_id() fails even without adding ftrace. Appearantly the issue is
some kind of timing / race, but merely retrying ulpi_read_id() does not
resolve the issue.

This patch makes ulpi_read_id() return -ETIMEDOUT to its user if the first
test write fails. The user should then handle it appropriately. A follow up
patch will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.

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

