Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512CE66C719
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbjAPQ2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbjAPQ1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:27:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57BB18B2C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD0EB8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2B5C433EF;
        Mon, 16 Jan 2023 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885759;
        bh=ykiS9gqIOKUeTcu+OBR+7ICt5G8aiKgvRB+1qDg0wAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Gfi3EmZ+PAZdm1Ho359CtUDu3Kx85P7ycrhVO40YOpIHyX2t3bozjD1R9l+07PR6
         mdfC7Q0mcnSY/qRt4RMf3rH9U8c+r1S2jd5v1rSDI2Z6M5MipqpvjDC/eRa1k53BkX
         o5+17Y+04PmYvBWIK8SkFa4pbs3fbK+pvw5e9S9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/658] bonding: uninitialized variable in bond_miimon_inspect()
Date:   Mon, 16 Jan 2023 16:44:21 +0100
Message-Id: <20230116154917.392844817@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 0b7994cb9380..0885991347d0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2102,10 +2102,10 @@ static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *in
 /* called with rcu_read_lock() */
 static int bond_miimon_inspect(struct bonding *bond)
 {
+	bool ignore_updelay = false;
 	int link_state, commit = 0;
 	struct list_head *iter;
 	struct slave *slave;
-	bool ignore_updelay;
 
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP) {
 		ignore_updelay = !rcu_dereference(bond->curr_active_slave);
-- 
2.35.1



