Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00961657D95
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiL1Pos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiL1Poo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A28417584
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8D41B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE44C433EF;
        Wed, 28 Dec 2022 15:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242280;
        bh=Q4ePPxLDI//uhmZaWgeKmx1tpKk4NHDU6bjLyAZX8LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yzt6OP8/hFJl98Vu0+X5QTjpbOQn1yhE16Vbxe/G3wQr+jwFKX33gISj7zks1+p/J
         HhHE5jLaiBvz7ylh3/po9B0IThS3hZ0WJkUSryG/nw03BJUQSqhLfyv8EO0Qlk9tqr
         D0RfCZwvZwNtxyMQWv6gq9/q76z05+y7ZdJLhasU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Chen <harperchen1110@gmail.com>,
        Baisong Zhong <zhongbaisong@huawei.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0388/1073] media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()
Date:   Wed, 28 Dec 2022 15:32:56 +0100
Message-Id: <20221228144338.552215947@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index cf15988dfb51..7d78ee09be5e 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -975,6 +975,10 @@ static int az6027_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int n
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



