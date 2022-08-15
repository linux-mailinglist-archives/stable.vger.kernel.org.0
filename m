Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8000A594310
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350600AbiHOWTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347010AbiHOWPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:15:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BA111F771;
        Mon, 15 Aug 2022 12:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3174CB81141;
        Mon, 15 Aug 2022 19:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD1EC433B5;
        Mon, 15 Aug 2022 19:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592384;
        bh=AcJrX1xUykEM0PUZFgTpse9dGF07x7CuOQftmr59ePw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8gwfAPk6Utxl/Bu7Fxsa2Fw6lS555OoeJT7NRpJxBW2e0ajUpfCs5XPyNTuBqDt9
         6EZetjyLv2zMiBQQub+YXIPxrAWjz8VjTyxuJBB1m+/48mHjI0vz1setPUmTvhhnjQ
         cAlyYtlmQieYeIKLrP38plKBpfHLAz/7228TI9/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0779/1095] HID: mcp2221: prevent a buffer overflow in mcp_smbus_write()
Date:   Mon, 15 Aug 2022 20:02:58 +0200
Message-Id: <20220815180501.492424937@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 62ac2473553a00229e67bdf3cb023b62cf7f5a9a ]

Smatch Warning:
drivers/hid/hid-mcp2221.c:388 mcp_smbus_write() error: __memcpy()
'&mcp->txbuf[5]' too small (59 vs 255)
drivers/hid/hid-mcp2221.c:388 mcp_smbus_write() error: __memcpy() 'buf'
too small (34 vs 255)

The 'len' variable can take a value between 0-255 as it can come from
data->block[0] and it is user data. So add an bound check to prevent a
buffer overflow in memcpy().

Fixes: 67a95c21463d ("HID: mcp2221: add usb to i2c-smbus host bridge")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 4211b9839209..de52e9f7bb8c 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -385,6 +385,9 @@ static int mcp_smbus_write(struct mcp2221 *mcp, u16 addr,
 		data_len = 7;
 		break;
 	default:
+		if (len > I2C_SMBUS_BLOCK_MAX)
+			return -EINVAL;
+
 		memcpy(&mcp->txbuf[5], buf, len);
 		data_len = len + 5;
 	}
-- 
2.35.1



