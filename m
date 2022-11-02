Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29C66158A5
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiKBCzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiKBCzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:55:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10C0222A3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C54D617D0
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B12C433D6;
        Wed,  2 Nov 2022 02:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357742;
        bh=8Y8AzjG7v7sq0h+3JMehWrm5Nq8Q8KYGoQWJbathEfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TPdo8t/uyN7ao0sfEnZkySV2HCpF2qxAmLKZfDtEAHdP9FoqHqmoiXoH3LDp2/lSR
         i23dsD77ZHF1f/zhAhslcdzGYc6aOobLMZi2866xHcBGvtinNxOa5W6FTEFwxXuKkQ
         J02MBsFk6FLhQN2MqfXJXQKw33ZX5NACFVFaKLJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 222/240] netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed
Date:   Wed,  2 Nov 2022 03:33:17 +0100
Message-Id: <20221102022116.422636387@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit a6aa8d0ce2cfba57ac0f23293fcb3be0b9f53fba ]

Remove dir in nsim_dev_debugfs_init() when creating ports dir failed.
Otherwise, the netdevsim device will not be created next time. Kernel
reports an error: debugfs: Directory 'netdevsim1' with parent 'netdevsim'
already present!

Fixes: ab1d0cc004d7 ("netdevsim: change debugfs tree topology")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/dev.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index f31af8f0c0d6..b17e4e94a060 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -309,8 +309,10 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	if (IS_ERR(nsim_dev->ddir))
 		return PTR_ERR(nsim_dev->ddir);
 	nsim_dev->ports_ddir = debugfs_create_dir("ports", nsim_dev->ddir);
-	if (IS_ERR(nsim_dev->ports_ddir))
-		return PTR_ERR(nsim_dev->ports_ddir);
+	if (IS_ERR(nsim_dev->ports_ddir)) {
+		err = PTR_ERR(nsim_dev->ports_ddir);
+		goto err_ddir;
+	}
 	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
 			    &nsim_dev->fw_update_status);
 	debugfs_create_u32("fw_update_overwrite_mask", 0600, nsim_dev->ddir,
@@ -346,7 +348,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->nodes_ddir)) {
 		err = PTR_ERR(nsim_dev->nodes_ddir);
-		goto err_out;
+		goto err_ports_ddir;
 	}
 	debugfs_create_bool("fail_trap_drop_counter_get", 0600,
 			    nsim_dev->ddir,
@@ -354,8 +356,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
 	return 0;
 
-err_out:
+err_ports_ddir:
 	debugfs_remove_recursive(nsim_dev->ports_ddir);
+err_ddir:
 	debugfs_remove_recursive(nsim_dev->ddir);
 	return err;
 }
-- 
2.35.1



