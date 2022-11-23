Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0746353B3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbiKWI6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbiKWI6O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:58:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F9378D57
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:58:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6091161B10
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A818C433D7;
        Wed, 23 Nov 2022 08:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193888;
        bh=6vfxvUiDy/ovGihM8y2YGMzCW6JJ5IrqDmRSHMTjxzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0co//KHWBtmjWtMgdGHmv27HNDDMVaevAO3EjDVYt4jtdkd6ewpg04MpGavmElFY
         Tl3ttlF/EmKWdq1n1vvLIWfW9xuWXAFWRQyVKZhtgDyC5Hp+KfvjCEpHw1Vvalevp9
         wFlFXsIBQvXsfssOXs3LDZcBJwePew7oG0CdZ+8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 13/88] net: cxgb3_main: disable napi when bind qsets failed in cxgb_up()
Date:   Wed, 23 Nov 2022 09:50:10 +0100
Message-Id: <20221123084548.979814611@linuxfoundation.org>
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

[ Upstream commit d75aed1428da787cbe42bc073d76f1354f364d92 ]

When failed to bind qsets in cxgb_up() for opening device, napi isn't
disabled. When open cxgb3 device next time, it will trigger a BUG_ON()
in napi_enable(). Compile tested only.

Fixes: 48c4b6dbb7e2 ("cxgb3 - fix port up/down error path")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109021451.121490-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index b8779afb8550..b3ebd5a4ebae 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1304,6 +1304,7 @@ static int cxgb_up(struct adapter *adap)
 		if (ret < 0) {
 			CH_ERR(adap, "failed to bind qsets, err %d\n", ret);
 			t3_intr_disable(adap);
+			quiesce_rx(adap);
 			free_irq_resources(adap);
 			err = ret;
 			goto out;
-- 
2.35.1



