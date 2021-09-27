Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB12419C06
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbhI0RYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237611AbhI0RXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:23:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0085E61222;
        Mon, 27 Sep 2021 17:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762897;
        bh=3iDmV1e0wu6nyNkAaBt8R1mKWwqqhwFK6gsYnzNlukY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3tWBuThrKVf4VF0+4m34WdUS6AThvBZ9TJXCvC9Ze901zUXaKc9M3iWLVf3hc63W
         opgBYc4HMhvFU5PnIRMWB0+mDa8wIUNeoPTkQ3weOvFfZE4vIK4lkPPUWlTWEhi3gF
         EF5IEDFjNP/UiEAlhdy+f/R3Wez7+JO+EtV4pqmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        Michael Walle <michael@walle.cc>,
        Christian Lamparter <chunkeey@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 060/162] net: bgmac-bcma: handle deferred probe error due to mac-address
Date:   Mon, 27 Sep 2021 19:01:46 +0200
Message-Id: <20210927170235.557204353@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 029497e66bdc762e001880e4c85a91f35a54b1e2 ]

Due to the inclusion of nvmem handling into the mac-address getter
function of_get_mac_address() by
commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
it is now possible to get a -EPROBE_DEFER return code. Which did cause
bgmac to assign a random ethernet address.

This exact issue happened on my Meraki MR32. The nvmem provider is
an EEPROM (at24c64) which gets instantiated once the module
driver is loaded... This happens once the filesystem becomes available.

With this patch, bgmac_probe() will propagate the -EPROBE_DEFER error.
Then the driver subsystem will reschedule the probe at a later time.

Cc: Petr Štetiar <ynezz@true.cz>
Cc: Michael Walle <michael@walle.cc>
Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac-bcma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 85fa0ab7201c..9513cfb5ba58 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -129,6 +129,8 @@ static int bgmac_probe(struct bcma_device *core)
 	bcma_set_drvdata(core, bgmac);
 
 	err = of_get_mac_address(bgmac->dev->of_node, bgmac->net_dev->dev_addr);
+	if (err == -EPROBE_DEFER)
+		return err;
 
 	/* If no MAC address assigned via device tree, check SPROM */
 	if (err) {
-- 
2.33.0



