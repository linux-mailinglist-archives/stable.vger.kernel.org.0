Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8723595086
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiHPEmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbiHPElj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2781517ED60;
        Mon, 15 Aug 2022 13:34:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFEC960EE9;
        Mon, 15 Aug 2022 20:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE559C433C1;
        Mon, 15 Aug 2022 20:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595663;
        bh=AcJrX1xUykEM0PUZFgTpse9dGF07x7CuOQftmr59ePw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnzbR1uczoLughH+2LCILbxULfC6nHivQqaoOtVr58xOEiivlyfHFO2eBBM4bk6Bh
         tfFS4DECRAnLazM4sX4+f9UbtGFNcnK21gEUt2xHR+FW3DF+hFaNjjo44/5gsQ563V
         b/TRqs7wZt4/VtXjk2jEYcJJoQlPapHp7YQb2WAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0836/1157] HID: mcp2221: prevent a buffer overflow in mcp_smbus_write()
Date:   Mon, 15 Aug 2022 20:03:12 +0200
Message-Id: <20220815180512.938203773@linuxfoundation.org>
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



