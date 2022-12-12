Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F596649FEA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiLLNQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:16:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiLLNQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:16:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BCB101F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:16:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A593B80B9B
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD1CC433EF;
        Mon, 12 Dec 2022 13:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850973;
        bh=aT0DBjzcxm6xNHcBR3LHvhPE0EG5pqSatLjkhNpCgLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPbWAqtAPKeu42S+QolnlzEW32qilkVVywasntbb9cMgv6R4shUhNB2OXPDBXzZin
         F8xEwTRCTw262RM9d54dfcnXgldEvscWZ/e7luoEZVlLd7XtF1/lw0Qdvb5h5HSaYt
         +5KIZFAWpb1p4Z94vN96x0LOSWM59xSRSrLPwkFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/106] Bluetooth: Fix not cleanup led when bt_init fails
Date:   Mon, 12 Dec 2022 14:10:20 +0100
Message-Id: <20221212130928.235332180@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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
index 4ef6a54403aa..2f87f57e7a4f 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -736,7 +736,7 @@ static int __init bt_init(void)
 
 	err = bt_sysfs_init();
 	if (err < 0)
-		return err;
+		goto cleanup_led;
 
 	err = sock_register(&bt_sock_family_ops);
 	if (err)
@@ -772,6 +772,8 @@ static int __init bt_init(void)
 	sock_unregister(PF_BLUETOOTH);
 cleanup_sysfs:
 	bt_sysfs_cleanup();
+cleanup_led:
+	bt_leds_cleanup();
 	return err;
 }
 
-- 
2.35.1



