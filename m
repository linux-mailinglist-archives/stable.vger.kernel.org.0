Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E7D649FCC
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiLLNPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiLLNOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:14:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B8512D3C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:14:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16C5861043
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17555C433EF;
        Mon, 12 Dec 2022 13:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850878;
        bh=Ph1UPeaek+ozl1Octva9TCAYmAUBi7iaRP5P5Qn5WzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImUMVPbT7T0ZngvB9HwqchzsWzpGOG8XUBZZ1BQ+qCNTaDMShBfXu529FukrTGP+o
         XhckvBrmfdD/5SAiaelTBlhX0W30l6xAxHFCTRQGakHjO3pvxH6W8L6XHZ+PlDMZ99
         gH2u5zF75MjhH5/do5ZWckga3eUbDxUdFbDgdRLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Davide Tronchin <davide.tronchin.94@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/106] net: usb: qmi_wwan: add u-blox 0x1342 composition
Date:   Mon, 12 Dec 2022 14:09:29 +0100
Message-Id: <20221212130925.998267497@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Davide Tronchin <davide.tronchin.94@gmail.com>

[ Upstream commit a487069e11b6527373f7c6f435d8998051d0b5d9 ]

Add RmNet support for LARA-L6.

LARA-L6 module can be configured (by AT interface) in three different
USB modes:
* Default mode (Vendor ID: 0x1546 Product ID: 0x1341) with 4 serial
interfaces
* RmNet mode (Vendor ID: 0x1546 Product ID: 0x1342) with 4 serial
interfaces and 1 RmNet virtual network interface
* CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1343) with 4 serial
interface and 1 CDC-ECM virtual network interface

In RmNet mode LARA-L6 exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parset/alternative functions
If 4: RMNET interface

Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
Acked-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 7313e6e03c12..bce151e3706a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1352,6 +1352,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
 	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM support*/
 	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded Qualcomm 05c6:9025) */
+	{QMI_QUIRK_SET_DTR(0x1546, 0x1342, 4)},	/* u-blox LARA-L6 */
 
 	/* 4. Gobi 1000 devices */
 	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */
-- 
2.35.1



