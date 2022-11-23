Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033106353BF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbiKWI6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbiKWI6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:58:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F86872097
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:58:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22796B81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593E9C433D6;
        Wed, 23 Nov 2022 08:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193914;
        bh=B1CN7ugn0rpQiyuNdjWozjo19Q6e7W/9iWPda5/WdqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T/k7XcfWaMNDvmmT+0mmJCTmY06SWz5WZzcJ0RCw5wVV80dWhkQ88PvqLofZ8KBOE
         wIj+jFXFlD+FJLf+M2zMi8Jpo3Cb2T3wdkRFCMOfyJkeM6zjU7ZL89i+Dr97VAMM6u
         XwpSGT0K4KVE4lIX58TRV+SPd7iMQrEGSbqJ/X7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/88] net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()
Date:   Wed, 23 Nov 2022 09:50:03 +0100
Message-Id: <20221123084548.756954773@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
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

[ Upstream commit 531705a765493655472c993627106e19f7e5a6d2 ]

When following tests are performed, it will cause dev reference counting
leakage.
a)ip link add bond2 type bond mode balance-rr
b)ip link set bond2 up
c)ifenslave -f bond2 rose1
d)ip link del bond2

When new bond device is created, the default type of the bond device is
ether. And the bond device is up, lapbeth_device_event() receives the
message and creates a new lapbeth device. In this case, the reference
count value of dev is hold once. But after "ifenslave -f bond2 rose1"
command is executed, the type of the bond device is changed to rose. When
the bond device is unregistered, lapbeth_device_event() will not put the
dev reference count.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/lapbether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 3ec922bed2d8..6233805fc032 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -406,7 +406,7 @@ static int lapbeth_device_event(struct notifier_block *this,
 	if (dev_net(dev) != &init_net)
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !lapbeth_get_x25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
-- 
2.35.1



