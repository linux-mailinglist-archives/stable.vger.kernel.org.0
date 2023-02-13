Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D596948D3
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjBMOxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjBMOxo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B05E3A1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19EEDB8125C
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87228C433EF;
        Mon, 13 Feb 2023 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300002;
        bh=L8AFb/G63IYPcaKXKpN9yFy2v5j/Jg10ZGAbnJISkkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOmyIC/MVZEe9CiCSAC3w4hGD8+PtBT2iYJ+Akw7vpQKbzJC+f0eIRjY8nJkOqEU+
         BvQkIf44ELfuEDiHgz2CfURvvkqfHzJtcRQgZzfnotkz23HMvWd8NDA1zvXW502C8X
         UKIgd0gxgWVzWE/kepHCfxyhyzvE5cfXO5IXIVVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/114] bonding: fix error checking in bond_debug_reregister()
Date:   Mon, 13 Feb 2023 15:47:41 +0100
Message-Id: <20230213144743.500906489@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit cbe83191d40d8925b7a99969d037d2a0caf69294 ]

Since commit ff9fb72bc077 ("debugfs: return error values,
not NULL") changed return value of debugfs_rename() in
error cases from %NULL to %ERR_PTR(-ERROR), we should
also check error values instead of NULL.

Fixes: ff9fb72bc077 ("debugfs: return error values, not NULL")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/20230202093256.32458-1-zhengqi.arch@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_debugfs.c b/drivers/net/bonding/bond_debugfs.c
index 4f9b4a18c74cd..5940945266489 100644
--- a/drivers/net/bonding/bond_debugfs.c
+++ b/drivers/net/bonding/bond_debugfs.c
@@ -76,7 +76,7 @@ void bond_debug_reregister(struct bonding *bond)
 
 	d = debugfs_rename(bonding_debug_root, bond->debug_dir,
 			   bonding_debug_root, bond->dev->name);
-	if (d) {
+	if (!IS_ERR(d)) {
 		bond->debug_dir = d;
 	} else {
 		netdev_warn(bond->dev, "failed to reregister, so just unregister old one\n");
-- 
2.39.0



