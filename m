Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA475657ED0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbiL1P5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbiL1P5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:57:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311F018390
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:57:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDA67B8172B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121CAC433D2;
        Wed, 28 Dec 2022 15:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243069;
        bh=rkLBp7T6HCTqky4JiL2uDPw+MUHvb3s2k95hlO4iD8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmjVj7GLcgM/DhmyDEbf+EcdGD5Wl8BcOBhXBLHo2kvOL5WTRsVV1YEttT3pL85Yy
         yGl8o7DMRSifBUrkJCwNDatgxgz6ivS0FXV9iS+Rq7ORFhOp7ar/aiJgUY7CZ+HoQw
         DRVb2HpizGKBqdim/GXmCQpYdAQLmhGig4mawuvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0448/1146] bonding: uninitialized variable in bond_miimon_inspect()
Date:   Wed, 28 Dec 2022 15:33:07 +0100
Message-Id: <20221228144342.349636334@linuxfoundation.org>
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
index c527f8b37ae6..29d0a6493b1b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2531,10 +2531,10 @@ static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *in
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



