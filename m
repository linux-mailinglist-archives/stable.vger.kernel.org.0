Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B939657C72
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiL1Pc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbiL1Pcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:32:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38A115F2F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:32:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A885B8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46E3C433EF;
        Wed, 28 Dec 2022 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241549;
        bh=jhZpX19fBZ2alVq1ufkdqLv0Yzsjw9K51GnezOInTJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPOJxGbD7ovTcMpafHvRQNnKjnoLFVfRuHbeJ+iO8AjMcySo4SO1eiPuufeRcBk3k
         u0lmv7ZnVHSyhPzyupiebcTCVDtLOxGRQG0P6xDaK5yUx4S+1tjrykL+WcpXrr0+Ik
         RvcTC+HMwvq3U+FOkxmMY4GZgB9AnQteKRv+4cE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheyu Ma <zheyuma97@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 495/731] i2c: ismt: Fix an out-of-bounds bug in ismt_access()
Date:   Wed, 28 Dec 2022 15:40:02 +0100
Message-Id: <20221228144310.895832502@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 39244cc754829bf707dccd12e2ce37510f5b1f8d ]

When the driver does not check the data from the user, the variable
'data->block[0]' may be very large to cause an out-of-bounds bug.

The following log can reveal it:

[   33.995542] i2c i2c-1: ioctl, cmd=0x720, arg=0x7ffcb3dc3a20
[   33.995978] ismt_smbus 0000:00:05.0: I2C_SMBUS_BLOCK_DATA:  WRITE
[   33.996475] ==================================================================
[   33.996995] BUG: KASAN: out-of-bounds in ismt_access.cold+0x374/0x214b
[   33.997473] Read of size 18446744073709551615 at addr ffff88810efcfdb1 by task ismt_poc/485
[   33.999450] Call Trace:
[   34.001849]  memcpy+0x20/0x60
[   34.002077]  ismt_access.cold+0x374/0x214b
[   34.003382]  __i2c_smbus_xfer+0x44f/0xfb0
[   34.004007]  i2c_smbus_xfer+0x10a/0x390
[   34.004291]  i2cdev_ioctl_smbus+0x2c8/0x710
[   34.005196]  i2cdev_ioctl+0x5ec/0x74c

Fix this bug by checking the size of 'data->block[0]' first.

Fixes: 13f35ac14cd0 ("i2c: Adding support for Intel iSMT SMBus 2.0 host controller")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-ismt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index 483428c5e30b..10cdd501d4c5 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -509,6 +509,9 @@ static int ismt_access(struct i2c_adapter *adap, u16 addr,
 		if (read_write == I2C_SMBUS_WRITE) {
 			/* Block Write */
 			dev_dbg(dev, "I2C_SMBUS_BLOCK_DATA:  WRITE\n");
+			if (data->block[0] < 1 || data->block[0] > I2C_SMBUS_BLOCK_MAX)
+				return -EINVAL;
+
 			dma_size = data->block[0] + 1;
 			dma_direction = DMA_TO_DEVICE;
 			desc->wr_len_cmd = dma_size;
-- 
2.35.1



