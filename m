Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C450627FF4
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbiKNNCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237722AbiKNNCp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C162980A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43764B80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9593AC433D7;
        Mon, 14 Nov 2022 13:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430959;
        bh=AAHd2nsvD91YZhghRBw4m9erM/tQW6YU7Rj0fdsgqhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTO6TrcGYkOXyT/+gj9GhMMLzFhL0MxpLhPZSLlsA1VWDfLuvAhpvkpYuYpoDzUo5
         IBiLhxxsIQJuFROSVPD9KOyTaWv89h6Shdg5LnX0l+lhG4mEQ09nkeOPk6rQ0rVp3r
         2ntTHAXIVOAsrTICLK8xguSZ5Wwd1E3oIpFj//Ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 049/190] hamradio: fix issue of dev reference count leakage in bpq_device_event()
Date:   Mon, 14 Nov 2022 13:44:33 +0100
Message-Id: <20221114124500.948637497@linuxfoundation.org>
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

[ Upstream commit 85cbaf032d3cd9f595152625eda5d4ecb1d6d78d ]

When following tests are performed, it will cause dev reference counting
leakage.
a)ip link add bond2 type bond mode balance-rr
b)ip link set bond2 up
c)ifenslave -f bond2 rose1
d)ip link del bond2

When new bond device is created, the default type of the bond device is
ether. And the bond device is up, bpq_device_event() receives the message
and creates a new bpq device. In this case, the reference count value of
dev is hold once. But after "ifenslave -f bond2 rose1" command is
executed, the type of the bond device is changed to rose. When the bond
device is unregistered, bpq_device_event() will not put the dev reference
count.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/bpqether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 30af0081e2be..83a16d10eedb 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -533,7 +533,7 @@ static int bpq_device_event(struct notifier_block *this,
 	if (!net_eq(dev_net(dev), &init_net))
 		return NOTIFY_DONE;
 
-	if (!dev_is_ethdev(dev))
+	if (!dev_is_ethdev(dev) && !bpq_get_ax25_dev(dev))
 		return NOTIFY_DONE;
 
 	switch (event) {
-- 
2.35.1



