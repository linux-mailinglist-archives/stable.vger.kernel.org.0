Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3941615958
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiKBDJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiKBDJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:09:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E5B22B11
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:08:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76749617BC
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDDEC43470;
        Wed,  2 Nov 2022 03:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358537;
        bh=CovcO1uugOj57XNx2RTkEDNWzAWMP3HZecXgyEPQWok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u61dGjdQCDlq7ywrmsd1HxWT7MzMPW0++bcK97wCv1cZBYeStP7cZoZ+RcGKnAMe8
         CxHl//oqRpPKf+B070rDJYqfHpXZ63aUSXe0QTv64c4vUF2r9cBhtmz3FO0hUamWO4
         +duLZYndVl5H96wBlBwGgy9Iig8hI65aC52nBUWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhengchao Shao <shaozhengchao@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/132] netdevsim: remove dir in nsim_dev_debugfs_init() when creating ports dir failed
Date:   Wed,  2 Nov 2022 03:33:42 +0100
Message-Id: <20221102022102.715093602@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
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
index 54313bd57797..94490dfae656 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -229,8 +229,10 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
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
@@ -267,7 +269,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 	nsim_dev->nodes_ddir = debugfs_create_dir("rate_nodes", nsim_dev->ddir);
 	if (IS_ERR(nsim_dev->nodes_ddir)) {
 		err = PTR_ERR(nsim_dev->nodes_ddir);
-		goto err_out;
+		goto err_ports_ddir;
 	}
 	debugfs_create_bool("fail_trap_drop_counter_get", 0600,
 			    nsim_dev->ddir,
@@ -275,8 +277,9 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
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



