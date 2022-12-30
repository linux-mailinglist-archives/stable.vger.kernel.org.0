Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF410658468
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiL1Q5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiL1Q4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:56:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B942A1D67C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:52:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78401B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6226C433EF;
        Wed, 28 Dec 2022 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246342;
        bh=xEMiQK885xmLg3qtc8QmYHFfWoEH/3qKOlQ4YuaktGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NBUUFNpnW6Zc9Nb1ucygUQJnFZe/JGmqzy3xT1jXEzqufH4L3P/k277rgzM7yzsp
         QaDc6dide/nDNX8HMXDXHGmo5kzVhF/RefxpEpv7EbGSIus2nTpuehCIG5dl75yl95
         OnfdNKR8/q2jDXqhN5ZFfI447AX9ru/U55TRPzzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mazin Al Haddad <mazinalhaddad05@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+f66dd31987e6740657be@syzkaller.appspotmail.com
Subject: [PATCH 6.1 1024/1146] media: dvb-usb: fix memory leak in dvb_usb_adapter_init()
Date:   Wed, 28 Dec 2022 15:42:43 +0100
Message-Id: <20221228144358.181126268@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Mazin Al Haddad <mazinalhaddad05@gmail.com>

[ Upstream commit 94d90fb06b94a90c176270d38861bcba34ce377d ]

Syzbot reports a memory leak in "dvb_usb_adapter_init()".
The leak is due to not accounting for and freeing current iteration's
adapter->priv in case of an error. Currently if an error occurs,
it will exit before incrementing "num_adapters_initalized",
which is used as a reference counter to free all adap->priv
in "dvb_usb_adapter_exit()". There are multiple error paths that
can exit from before incrementing the counter. Including the
error handling paths for "dvb_usb_adapter_stream_init()",
"dvb_usb_adapter_dvb_init()" and "dvb_usb_adapter_frontend_init()"
within "dvb_usb_adapter_init()".

This means that in case of an error in any of these functions the
current iteration is not accounted for and the current iteration's
adap->priv is not freed.

Fix this by freeing the current iteration's adap->priv in the
"stream_init_err:" label in the error path. The rest of the
(accounted for) adap->priv objects are freed in dvb_usb_adapter_exit()
as expected using the num_adapters_initalized variable.

Syzbot report:

BUG: memory leak
unreferenced object 0xffff8881172f1a00 (size 512):
  comm "kworker/0:2", pid 139, jiffies 4294994873 (age 10.960s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
backtrace:
    [<ffffffff844af012>] dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:75 [inline]
    [<ffffffff844af012>] dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:184 [inline]
    [<ffffffff844af012>] dvb_usb_device_init.cold+0x4e5/0x79e drivers/media/usb/dvb-usb/dvb-usb-init.c:308
    [<ffffffff830db21d>] dib0700_probe+0x8d/0x1b0 drivers/media/usb/dvb-usb/dib0700_core.c:883
    [<ffffffff82d3fdc7>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<ffffffff8274ab37>] call_driver_probe drivers/base/dd.c:542 [inline]
    [<ffffffff8274ab37>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:621
    [<ffffffff8274ae6c>] really_probe drivers/base/dd.c:583 [inline]
    [<ffffffff8274ae6c>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:752
    [<ffffffff8274af6a>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:782
    [<ffffffff8274b786>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:899
    [<ffffffff82747c87>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff8274b352>] __device_attach+0x122/0x260 drivers/base/dd.c:970
    [<ffffffff827498f6>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:487
    [<ffffffff82745cdb>] device_add+0x5fb/0xdf0 drivers/base/core.c:3405
    [<ffffffff82d3d202>] usb_set_configuration+0x8f2/0xb80 drivers/usb/core/message.c:2170
    [<ffffffff82d4dbfc>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<ffffffff82d3f49c>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<ffffffff8274ab37>] call_driver_probe drivers/base/dd.c:542 [inline]
    [<ffffffff8274ab37>] really_probe.part.0+0xe7/0x310 drivers/base/dd.c:621
    [<ffffffff8274ae6c>] really_probe drivers/base/dd.c:583 [inline]
    [<ffffffff8274ae6c>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:752

Link: https://syzkaller.appspot.com/bug?extid=f66dd31987e6740657be
Reported-and-tested-by: syzbot+f66dd31987e6740657be@syzkaller.appspotmail.com

Link: https://lore.kernel.org/linux-media/20220824012152.539788-1-mazinalhaddad05@gmail.com
Signed-off-by: Mazin Al Haddad <mazinalhaddad05@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dvb-usb-init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 61439c8f33ca..58eea8ab5477 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -81,7 +81,7 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 
 		ret = dvb_usb_adapter_stream_init(adap);
 		if (ret)
-			return ret;
+			goto stream_init_err;
 
 		ret = dvb_usb_adapter_dvb_init(adap, adapter_nrs);
 		if (ret)
@@ -114,6 +114,8 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 	dvb_usb_adapter_dvb_exit(adap);
 dvb_init_err:
 	dvb_usb_adapter_stream_exit(adap);
+stream_init_err:
+	kfree(adap->priv);
 	return ret;
 }
 
-- 
2.35.1



