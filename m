Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3164A272
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiLLNyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiLLNyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:54:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C901CF
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3F4CB80D4F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A1DC433EF;
        Mon, 12 Dec 2022 13:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853241;
        bh=L6UDHzbsvVJHY5wZsFFRchZRbTkTrtMeaMD7SSe4IhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wyknmGO0tpIoys0GIAayKpzd2lULg08rYoJ2Xjtjyee4Uf1nLnu8gDkHAZctTSwaa
         Af/pTXjvFjhTJTjMmLKRepSRjBx8cmrSdu9acJvXZcFGVgJoQ9OCkwuk36u+InRMed
         angyIvjbYX3t4Oh1T/EwI5SlfFaz4QL/zpSJgRIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 25/38] mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()
Date:   Mon, 12 Dec 2022 14:19:26 +0100
Message-Id: <20221212130913.358424829@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
References: <20221212130912.069170932@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b3d72d3135d2ef68296c1ee174436efd65386f04 ]

Kernel fault injection test reports null-ptr-deref as follows:

BUG: kernel NULL pointer dereference, address: 0000000000000008
RIP: 0010:cfg802154_netdev_notifier_call+0x120/0x310 include/linux/list.h:114
Call Trace:
 <TASK>
 raw_notifier_call_chain+0x6d/0xa0 kernel/notifier.c:87
 call_netdevice_notifiers_info+0x6e/0xc0 net/core/dev.c:1944
 unregister_netdevice_many_notify+0x60d/0xcb0 net/core/dev.c:1982
 unregister_netdevice_queue+0x154/0x1a0 net/core/dev.c:10879
 register_netdevice+0x9a8/0xb90 net/core/dev.c:10083
 ieee802154_if_add+0x6ed/0x7e0 net/mac802154/iface.c:659
 ieee802154_register_hw+0x29c/0x330 net/mac802154/main.c:229
 mcr20a_probe+0xaaa/0xcb1 drivers/net/ieee802154/mcr20a.c:1316

ieee802154_if_add() allocates wpan_dev as netdev's private data, but not
init the list in struct wpan_dev. cfg802154_netdev_notifier_call() manage
the list when device register/unregister, and may lead to null-ptr-deref.

Use INIT_LIST_HEAD() on it to initialize it correctly.

Fixes: fcf39e6e88e9 ("ieee802154: add wpan_dev_list")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Alexander Aring <aahringo@redhat.com>

Link: https://lore.kernel.org/r/20221130091705.1831140-1-weiyongjun@huaweicloud.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index bd88a9b80773..8c2aedf3fa74 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -669,6 +669,7 @@ ieee802154_if_add(struct ieee802154_local *local, const char *name,
 	sdata->dev = ndev;
 	sdata->wpan_dev.wpan_phy = local->hw.phy;
 	sdata->local = local;
+	INIT_LIST_HEAD(&sdata->wpan_dev.list);
 
 	/* setup type-dependent data */
 	ret = ieee802154_setup_sdata(sdata, type);
-- 
2.35.1



