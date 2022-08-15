Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F616594AA8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352044AbiHPAFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352715AbiHPAA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D2C61DB0;
        Mon, 15 Aug 2022 13:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1355F61057;
        Mon, 15 Aug 2022 20:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC819C433D7;
        Mon, 15 Aug 2022 20:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594903;
        bh=aZcGBsdZmldfbvVLdPKlPrR+pTlUOeweKXXlUsFE84I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6Os2QTFk/SQWFta9qr4KfT0RQhmPpov+6q1xZ/78hX+cdqpRZ2xrmgpZVPiPj5XZ
         ESPFTQYmNxfG9eFPWicX2+bp3FFmcO7qIBYf7OHVEm6eAhv6nIg46aO27TL1mbtB2v
         zbtq6wFCmlhD6pwU3PgaS/s9f+OAOL4rmaVA+PgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0596/1157] HID: cp2112: prevent a buffer overflow in cp2112_xfer()
Date:   Mon, 15 Aug 2022 19:59:12 +0200
Message-Id: <20220815180503.499512051@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 381583845d19cb4bd21c8193449385f3fefa9caf ]

Smatch warnings:
drivers/hid/hid-cp2112.c:793 cp2112_xfer() error: __memcpy()
'data->block[1]' too small (33 vs 255)
drivers/hid/hid-cp2112.c:793 cp2112_xfer() error: __memcpy() 'buf' too
small (64 vs 255)

The 'read_length' variable is provided by 'data->block[0]' which comes
from user and it(read_length) can take a value between 0-255. Add an
upper bound to 'read_length' variable to prevent a buffer overflow in
memcpy().

Fixes: 542134c0375b ("HID: cp2112: Fix I2C_BLOCK_DATA transactions")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-cp2112.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index ece147d1a278..1e16b0fa310d 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -790,6 +790,11 @@ static int cp2112_xfer(struct i2c_adapter *adap, u16 addr,
 		data->word = le16_to_cpup((__le16 *)buf);
 		break;
 	case I2C_SMBUS_I2C_BLOCK_DATA:
+		if (read_length > I2C_SMBUS_BLOCK_MAX) {
+			ret = -EINVAL;
+			goto power_normal;
+		}
+
 		memcpy(data->block + 1, buf, read_length);
 		break;
 	case I2C_SMBUS_BLOCK_DATA:
-- 
2.35.1



