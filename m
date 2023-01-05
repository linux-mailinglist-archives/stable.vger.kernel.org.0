Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E7E65EB99
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbjAENAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbjAENAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257475AC78
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39C8E619F3
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB68C433D2;
        Thu,  5 Jan 2023 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923615;
        bh=9CqJJAV/kJAGM9j8FkIOzpFkpnee+ca7YXGeEJS5n6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFEmcXuxHhtf50pA7foNOQJUrSbbq/9hi1FFUNzpwcVw2rmOwTFQoTWP7maIQ0YTE
         L688dhuIdQgoXToNkaneM/8u8QeaXmE8V8YglhYyO4mcx7XlaH5GUQZ4VBJu4Zas7l
         mtZLUmWmXzcqAURiPw/5ek/wHaVN2gaabdKT+Wpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/251] bonding: uninitialized variable in bond_miimon_inspect()
Date:   Thu,  5 Jan 2023 13:53:34 +0100
Message-Id: <20230105125338.304398689@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit e5214f363dabca240446272dac54d404501ad5e5 ]

The "ignore_updelay" variable needs to be initialized to false.

Fixes: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/Y4SWJlh3ohJ6EPTL@kili
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 33843b89ab04..d606e0a6b335 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2052,10 +2052,10 @@ static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *in
 /* called with rcu_read_lock() */
 static int bond_miimon_inspect(struct bonding *bond)
 {
+	bool ignore_updelay = false;
 	int link_state, commit = 0;
 	struct list_head *iter;
 	struct slave *slave;
-	bool ignore_updelay;
 
 	ignore_updelay = !rcu_dereference(bond->curr_active_slave);
 
-- 
2.35.1



