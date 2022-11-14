Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22B6628064
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbiKNNFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbiKNNFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B65F2A411
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A0C6B80EB8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B09C433D6;
        Mon, 14 Nov 2022 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431127;
        bh=py/kWXnur/KEwzoLvREv5g+/jd3K1SUk7qQq7QgOhgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjOC3RDiUk/Pz/BnPqB5nxpEdstiwdCPGGNpPJLF+XiPjjQ4Eam17dptgQ9Byolad
         kbHN7Yy7QTzfykm4CrvrYmqnbbwq1pzhe5cKtaSY94AnCO2dsOuwY3ypQzXD6iFSiN
         cOZSa0b1VBLm4QaXJubrU+GoZnjQaMX/g/jvihgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 071/190] net: lapbether: fix issue of invalid opcode in lapbeth_open()
Date:   Mon, 14 Nov 2022 13:44:55 +0100
Message-Id: <20221114124501.802628178@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 3faf7e14ec0c3462c2d747fa6793b8645d1391df ]

If lapb_register() failed when lapb device goes to up for the first time,
the NAPI is not disabled. As a result, the invalid opcode issue is
reported when the lapb device goes to up for the second time.

The stack info is as follows:
[ 1958.311422][T11356] kernel BUG at net/core/dev.c:6442!
[ 1958.312206][T11356] invalid opcode: 0000 [#1] PREEMPT SMP KASAN
[ 1958.315979][T11356] RIP: 0010:napi_enable+0x16a/0x1f0
[ 1958.332310][T11356] Call Trace:
[ 1958.332817][T11356]  <TASK>
[ 1958.336135][T11356]  lapbeth_open+0x18/0x90
[ 1958.337446][T11356]  __dev_open+0x258/0x490
[ 1958.341672][T11356]  __dev_change_flags+0x4d4/0x6a0
[ 1958.345325][T11356]  dev_change_flags+0x93/0x160
[ 1958.346027][T11356]  devinet_ioctl+0x1276/0x1bf0
[ 1958.346738][T11356]  inet_ioctl+0x1c8/0x2d0
[ 1958.349638][T11356]  sock_ioctl+0x5d1/0x750
[ 1958.356059][T11356]  __x64_sys_ioctl+0x3ec/0x1790
[ 1958.365594][T11356]  do_syscall_64+0x35/0x80
[ 1958.366239][T11356]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 1958.377381][T11356]  </TASK>

Fixes: 514e1150da9c ("net: x25: Queue received packets in the drivers instead of per-CPU queues")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221107011445.207372-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index cb360dca3250..d62a904d2e42 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -325,6 +325,7 @@ static int lapbeth_open(struct net_device *dev)
 
 	err = lapb_register(dev, &lapbeth_callbacks);
 	if (err != LAPB_OK) {
+		napi_disable(&lapbeth->napi);
 		pr_err("lapb_register error: %d\n", err);
 		return -ENODEV;
 	}
-- 
2.35.1



