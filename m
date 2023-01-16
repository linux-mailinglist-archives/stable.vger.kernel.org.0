Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C797B66CC94
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbjAPR1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbjAPR1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:27:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DED936098
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:04:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF36061086
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C539FC433D2;
        Mon, 16 Jan 2023 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888653;
        bh=z4OWxsMqc4jmGsGwyPEq7uJhm9+Y2Q2LbM3MLfhd574=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ne827gxClBdWPVkoptNo4YV04HGzjarR+BMm1QUz725Ua9IVDSiAaFeptYYqJIDzI
         w+ijnkinkyuokfaBNCJx64cQ8SWFQYgXo9DubY/pziQLp4egsU0nPQHuzTD9tvWEew
         5IwSePkouzoV7fEST1rzybnKVrniW8W3YoRWWM4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Chen <harperchen1110@gmail.com>,
        Baisong Zhong <zhongbaisong@huawei.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 088/338] media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()
Date:   Mon, 16 Jan 2023 16:49:21 +0100
Message-Id: <20230116154824.708961385@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Baisong Zhong <zhongbaisong@huawei.com>

[ Upstream commit 0ed554fd769a19ea8464bb83e9ac201002ef74ad ]

Wei Chen reports a kernel bug as blew:

general protection fault, probably for non-canonical address
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
...
Call Trace:
<TASK>
__i2c_transfer+0x77e/0x1930 drivers/i2c/i2c-core-base.c:2109
i2c_transfer+0x1d5/0x3d0 drivers/i2c/i2c-core-base.c:2170
i2cdev_ioctl_rdwr+0x393/0x660 drivers/i2c/i2c-dev.c:297
i2cdev_ioctl+0x75d/0x9f0 drivers/i2c/i2c-dev.c:458
vfs_ioctl fs/ioctl.c:51 [inline]
__do_sys_ioctl fs/ioctl.c:870 [inline]
__se_sys_ioctl+0xfb/0x170 fs/ioctl.c:856
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fd834a8bded

In az6027_i2c_xfer(), if msg[i].addr is 0x99,
a null-ptr-deref will caused when accessing msg[i].buf.
For msg[i].len is 0 and msg[i].buf is null.

Fix this by checking msg[i].len in az6027_i2c_xfer().

Link: https://lore.kernel.org/lkml/CAO4mrfcPHB5aQJO=mpqV+p8mPLNg-Fok0gw8gZ=zemAfMGTzMg@mail.gmail.com/

Link: https://lore.kernel.org/linux-media/20221120065918.2160782-1-zhongbaisong@huawei.com
Fixes: 76f9a820c867 ("V4L/DVB: AZ6027: Initial import of the driver")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/az6027.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index 382c8075ef52..f2b5ba1d2809 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -978,6 +978,10 @@ static int az6027_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int n
 		if (msg[i].addr == 0x99) {
 			req = 0xBE;
 			index = 0;
+			if (msg[i].len < 1) {
+				i = -EOPNOTSUPP;
+				break;
+			}
 			value = msg[i].buf[0] & 0x00ff;
 			length = 1;
 			az6027_usb_out_op(d, req, value, index, data, length);
-- 
2.35.1



