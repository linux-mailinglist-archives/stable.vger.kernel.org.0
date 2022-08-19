Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2953759A03D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351994AbiHSQSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352266AbiHSQQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:16:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBD2108976;
        Fri, 19 Aug 2022 08:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3ADA61644;
        Fri, 19 Aug 2022 15:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9590CC433C1;
        Fri, 19 Aug 2022 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924763;
        bh=ZWJtKv6jVkqiridAY8cXFrzdiuW3E35fs+WyaR0mDGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tm6JoIxoVyWHPSLdqtyHm8cvqo2PRNcbKZlyCsnjYIRREYwT+5oMKNUu1Z2mrW1GE
         jI0SUdGSaH085RrDldPGjnWYHobRDw5KgO6gofVHB1roFAFYLO0blnoJztue0XklEt
         UHxWh4tKRRHRQxgb7XrGQheszMo0pNVx39sBCvm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 274/545] HID: cp2112: prevent a buffer overflow in cp2112_xfer()
Date:   Fri, 19 Aug 2022 17:40:44 +0200
Message-Id: <20220819153841.603174653@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 477baa30889c..172f20e88c6c 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -788,6 +788,11 @@ static int cp2112_xfer(struct i2c_adapter *adap, u16 addr,
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



