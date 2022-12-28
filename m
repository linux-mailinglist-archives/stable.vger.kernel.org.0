Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E345B658397
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbiL1Qs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbiL1QsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:48:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A56F1EAED
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:43:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ECFDB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DBBC433EF;
        Wed, 28 Dec 2022 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245825;
        bh=yOqexlF7Pg6JfdPBE3az4NjdJGwGGeRXN3SazuVHnZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d78CjChgTJg1As0SvRbpXhT352VHVf/yxxz6mtm64V6gA0P2zK5/Y1njvJpbA2MSq
         RI7WvDCXDzjVinSo6VzeHmfBtYBuIs/OvrTadbrlAM5jhb3V2lCCWXeH8dIUtL2oJT
         z+ACYOZWhY7OZfh+IghVLXwG1SO0Mk7tlOM67L2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harsh Tyagi <harshtya@google.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0931/1146] mctp: serial: Fix starting value for frame check sequence
Date:   Wed, 28 Dec 2022 15:41:10 +0100
Message-Id: <20221228144355.574667028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 2856a62762c8409e360d4fd452194c8e57ba1058 ]

RFC1662 defines the start state for the crc16 FCS to be 0xffff, but
we're currently starting at zero.

This change uses the correct start state. We're only early in the
adoption for the serial binding, so there aren't yet any other users to
interface to.

Fixes: a0c2ccd9b5ad ("mctp: Add MCTP-over-serial transport binding")
Reported-by: Harsh Tyagi <harshtya@google.com>
Tested-by: Harsh Tyagi <harshtya@google.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-serial.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index 7cd103fd34ef..9f9eaf896047 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -35,6 +35,8 @@
 #define BYTE_FRAME		0x7e
 #define BYTE_ESC		0x7d
 
+#define FCS_INIT		0xffff
+
 static DEFINE_IDA(mctp_serial_ida);
 
 enum mctp_serial_state {
@@ -123,7 +125,7 @@ static void mctp_serial_tx_work(struct work_struct *work)
 		buf[2] = dev->txlen;
 
 		if (!dev->txpos)
-			dev->txfcs = crc_ccitt(0, buf + 1, 2);
+			dev->txfcs = crc_ccitt(FCS_INIT, buf + 1, 2);
 
 		txlen = write_chunk(dev, buf + dev->txpos, 3 - dev->txpos);
 		if (txlen <= 0) {
@@ -303,7 +305,7 @@ static void mctp_serial_push_header(struct mctp_serial *dev, unsigned char c)
 	case 1:
 		if (c == MCTP_SERIAL_VERSION) {
 			dev->rxpos++;
-			dev->rxfcs = crc_ccitt_byte(0, c);
+			dev->rxfcs = crc_ccitt_byte(FCS_INIT, c);
 		} else {
 			dev->rxstate = STATE_ERR;
 		}
-- 
2.35.1



