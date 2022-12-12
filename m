Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBEC64A05F
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiLLNYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbiLLNYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:24:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0D0245
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:24:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498C361059
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34399C433EF;
        Mon, 12 Dec 2022 13:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851457;
        bh=HtijZ5tVO7MeIEPv1AouZAV5k8dZQbJGcI1Vb/AvAhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfiypUV4pLSfhdXgUQSek1xxfsigLNP668qWNqJZRc6qcFCl3bRg9pI7vi5Di8bGM
         GjmXnM9Rro5OrYCeq1ak3G/5YglIRozYXBU8ZefyP9KB5dDQv9GrIKPj5/P9mIiN6b
         xBoP6gtmCKocV3iFKtRZfkIJP7PVUzmMBIdgkPLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/67] Bluetooth: Fix not cleanup led when bt_init fails
Date:   Mon, 12 Dec 2022 14:17:17 +0100
Message-Id: <20221212130919.637292390@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 2f3957c7eb4e07df944169a3e50a4d6790e1c744 ]

bt_init() calls bt_leds_init() to register led, but if it fails later,
bt_leds_cleanup() is not called to unregister it.

This can cause panic if the argument "bluetooth-power" in text is freed
and then another led_trigger_register() tries to access it:

BUG: unable to handle page fault for address: ffffffffc06d3bc0
RIP: 0010:strcmp+0xc/0x30
  Call Trace:
    <TASK>
    led_trigger_register+0x10d/0x4f0
    led_trigger_register_simple+0x7d/0x100
    bt_init+0x39/0xf7 [bluetooth]
    do_one_initcall+0xd0/0x4e0

Fixes: e64c97b53bc6 ("Bluetooth: Add combined LED trigger for controller power")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/af_bluetooth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 5f508c50649d..8031526eeeee 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -735,7 +735,7 @@ static int __init bt_init(void)
 
 	err = bt_sysfs_init();
 	if (err < 0)
-		return err;
+		goto cleanup_led;
 
 	err = sock_register(&bt_sock_family_ops);
 	if (err)
@@ -771,6 +771,8 @@ static int __init bt_init(void)
 	sock_unregister(PF_BLUETOOTH);
 cleanup_sysfs:
 	bt_sysfs_cleanup();
+cleanup_led:
+	bt_leds_cleanup();
 	return err;
 }
 
-- 
2.35.1



